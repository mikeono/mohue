//
//  MOHueBridgeFinder.m
//  Hue
//
//  Created by Mike Onorato on 4/21/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueBridgeFinder.h"
#import "Reachability.h"
#import "MOHueService.h"
#import "JSONKit.h"
#import "MOHueServiceRequest.h"

NSString* kMOHueBridgeFinderStatusChangeNotification = @"hue.bridge.status.change.notification";

static MOHueBridgeFinder *instance = nil;

@interface MOHueBridgeFinder () {
  BOOL _updating;
  Reachability* _wifiReachability;
  Reachability* _internetReachability;
  Reachability* _websiteReachability;
  UIAlertView* _alertView;
  NSOperationQueue* _urlResultProcessingQueue;
  MOHueBridgeStatus _bridgeStatus;
}

@property (nonatomic, assign) MOHueBridgeStatus bridgeStatus;

@end

@implementation MOHueBridgeFinder

- (id)init {
  if ( self = [super init] ) {
    _wifiReachability = [Reachability reachabilityForLocalWiFi];
    _internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
    _websiteReachability = [Reachability reachabilityWithHostname: @"www.meethue.com"];
    _urlResultProcessingQueue = [[NSOperationQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityHasChanged:) name: kReachabilityChangedNotification object: nil];
  }
  return self;
}

#pragma mark - Getters and Setters

- (MOHueBridgeStatus)bridgeStatus {
  if ( _bridgeStatus == MOHueBridgeStatusNotUpdated ) {
    [self updateBridgeStatus];
  }
  return _bridgeStatus;
}

- (void)setBridgeStatus:(MOHueBridgeStatus)bridgeStatus {
  if ( bridgeStatus == _bridgeStatus ) {
    return;
  }
  _bridgeStatus = bridgeStatus;
  
  [self presentAlert];
  
  [[NSNotificationCenter defaultCenter] postNotificationName: kMOHueBridgeFinderStatusChangeNotification object: nil];
}

#pragma mark - Bridge

- (void)updateBridgeStatus {
  [self updateBridgeStatusNoAlert];
}

- (void)reconnect {
  self.bridgeStatus = MOHueBridgeStatusUpdating;
  [NSTimer scheduledTimerWithTimeInterval: 0.2f target: self selector: @selector(updateBridgeStatus) userInfo: nil repeats: NO];
}

- (void)updateBridgeStatusNoAlert {
  
  // Check for wifi reachability
  if ( ! _wifiReachability.isReachable ) {
    self.bridgeStatus = MOHueBridgeStatusNoWifi;
    return;
  }
  
  // Otherwise if no bridge found yet:
  else if ( ! [MOHueService sharedInstance].serverName ) {
    
    // Check for internet reachability
    if ( ! _internetReachability.isReachable ) {
      self.bridgeStatus = MOHueBridgeStatusNoInternet;
      return;
    }
  
    // Make request for hue bridge IP
    [self startBridgeSearchWithCompletion:^(BOOL success){
      if ( success ) {
        [self updateBridgeStatus];
      } else {
        self.bridgeStatus = MOHueBridgeStatusNoBridge;
      }
    }];
    self.bridgeStatus = MOHueBridgeStatusUpdating;
    return;
  }
  
  // Otherwise, if auth cancelled do nothing
  else if ( _bridgeStatus == MOHueBridgeStatusAuthCancelled ) {
    return;
  }
  
  // Otherwise, check if authed
  [self testAuthWithCompletion: ^(BOOL success) {
    
    // If authed, save status
    if ( success ) {
      self.bridgeStatus = MOHueBridgeStatusAuthed;
    }
    
    // If not authed, start auth request
    else {
      [self startAuthRequestWithCompletion:^(MOHueServiceResponseCode responseCode) {
        if ( responseCode == MOHueServiceResponseSuccess ) {
          self.bridgeStatus = MOHueBridgeStatusAuthed;
        } else {
          self.bridgeStatus = MOHueBridgeStatusNoAuth;
        }
      }];
    }
  }];
  
}

- (void)startBridgeSearchWithCompletion:(void(^)(BOOL success))completion {
  NSString* fullPath = @"https://www.meethue.com/api/nupnp";
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fullPath]];
  [self executeAsyncRequest: request completion: ^(NSURLResponse* response, NSData* data, NSError* error) {
    NSArray* responseArray = [data objectFromJSONData];
    
    BOOL parsedIPAddress = NO;
    
    // Parse IP Address
    if ( [responseArray isKindOfClass: [NSArray class]] ) {
      if ( [responseArray count] > 0 ) {
        NSDictionary* hueDict = [responseArray objectAtIndex: 0];
        if ( [hueDict isKindOfClass: [NSDictionary class]] ) {
          NSString* ipAddress = [hueDict valueForKey: @"internalipaddress"];
          if ( [ipAddress length] > 3 ) {
            [MOHueService sharedInstance].serverName = ipAddress;
            parsedIPAddress = YES;
          }
        }
      }
    }
    
    // Run completion handler on main queue
    if ( completion ) {
      dispatch_async(dispatch_get_main_queue(), ^(){
        completion( parsedIPAddress );
      });
    }
    
  }];
}

- (void)executeAsyncRequest:(NSURLRequest*)urlRequest completion:(void(^)(NSURLResponse* response, NSData* data, NSError* error))completion {
  NSURLRequest* request = urlRequest;
  
  [NSURLConnection sendAsynchronousRequest: request queue: _urlResultProcessingQueue completionHandler: ^(NSURLResponse* response, NSData* data, NSError* error) {
    
    if ( error ) {
      DBG(@"Got error %@", error);
    }
    
    if ( completion ) {
      completion(response, data, error);
    }
  }];
}

- (void)testAuthWithCompletion:(void(^)(BOOL success))completion {
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"config" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
    
    BOOL success = NO;
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      NSDictionary* resultDict = resultObject;
      NSString* hueUTC = [resultDict objectForKey: @"UTC"];
      if ( hueUTC ) {
        success = YES;
      }
    }
    
    DBG(@"response %@", resultObject);
    
    if ( completion ) {
      dispatch_async(dispatch_get_main_queue(), ^(){
        completion ( success );
      });
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

- (void)startAuthRequestWithCompletion:(void(^)(MOHueServiceResponseCode responseCode))completion {
  
  // Create request
  NSDictionary* requestBody = @{@"devicetype": @"SchedHue", @"username": [MOHueService sharedInstance].username};
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: nil bodyDict: requestBody httpMethod: kMOHTTPRequestMethodPost completionBlock:^(id resultObject, NSError* error) {
    
    MOHueServiceResponseCode responseCode = [MOHueService parseHueServiceResponseFromResponseObject: resultObject];
    
    DBG(@"response %@", resultObject);
    
    if ( completion ) {
      dispatch_async(dispatch_get_main_queue(), ^(){
        completion ( responseCode );
      });
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

- (void)presentAlert {
  // If an alert is already being presented don't do anything.
  if ( _alertView.isVisible ) {
    //return;
  }
  
  // Otherwise, configure alert.
  NSString* title = nil;
  NSString* message = nil;
  
  switch ( self.bridgeStatus ) {
    case MOHueBridgeStatusNoWifi:
    {
      title = @"Please connect to WiFi";
      message = @"You must be connected to a WiFi network to communicate with the Hue bridge";
      break;
    }
    case MOHueBridgeStatusNoInternet:
    case MOHueBridgeStatusNoWebsite:
    {
      title = @"Please connect to the Internet";
      message = @"You must be connected to the Internet to locate the Hue bridge";
      break;
    }
    case MOHueBridgeStatusNoBridge:
    {
      title = @"No bridge";
      message = @"No Hue-compatibile bridges were found on this WiFi network.  Make sure the Hue bridge is on and connected to the same WiFi network.";
      break;
    }
    case MOHueBridgeStatusNoAuth:
    {
      title = @"Press the button on your bridge";
      message = @"Press the round button in the middle of your bridge to pair with this app.";
      _alertView = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Continue", nil];
      _alertView.delegate = self;
      [_alertView show];
      return;
    }
    default:
    {
      return;
    }
  }
  
  _alertView = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: nil otherButtonTitles: @"Okay", nil];
  [_alertView show];
}

#pragma mark - Event Handling

- (void)reachabilityHasChanged:(Reachability*)reachabillity {
  [self updateBridgeStatus];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ( buttonIndex == 1 ) {
    self.bridgeStatus = MOHueBridgeStatusUpdating;
    [self updateBridgeStatus];
  } else {
    self.bridgeStatus = MOHueBridgeStatusAuthCancelled;
    [self updateBridgeStatus];
  }
}

#pragma mark - Static Methods

+ (MOHueBridgeFinder*)sharedInstance {
  @synchronized( self )
  {
    if (instance == nil)
      instance = [[self alloc] init];
  }
  return(instance);
}

@end
