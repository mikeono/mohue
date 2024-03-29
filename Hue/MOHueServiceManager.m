//
//  MOHueService.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueServiceManager.h"
#import "JSONKit.h"
#import "MOHueService.h"

@interface MOHueServiceManager ()

@property (nonatomic, strong) NSOperationQueue* resultProcessingQueue;

@end

@implementation MOHueServiceManager

static MOHueServiceManager *instance = nil;

- (id)init {
  self = [super init];
  if ( self ) {
    // Init iVars
    _resultProcessingQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSString*)serverName {
  return @"192.168.1.5";
}

#pragma mark - Making URL Requests


- (NSMutableURLRequest*)requestWithPath:(NSString*)path body:(NSDictionary*)body method:(NSString*)method {
  NSString* fullURLString = [NSString stringWithFormat: @"http://%@/api/%@/%@", self.serverName, [MOHueService sharedInstance].username, path];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fullURLString]];
  
  NSData* data = [body JSONData];
  [request setHTTPMethod: method ? method : @"POST"];
  [request setValue: @"text/json" forHTTPHeaderField: @"Content-type"];
  [request setValue: [NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField: @"Content-length"];
  [request setHTTPBody: data];
  
  return request;
}

- (NSMutableURLRequest*)startAsyncRequestWithPath:(NSString*)path body:(NSDictionary*)body method:(NSString*)method completionHandler:(void (^)(id, NSError*))completionHandler {
  NSMutableURLRequest* request = [self requestWithPath: path body: body method: method];
  request.timeoutInterval = 5.0f;
  
  [NSURLConnection sendAsynchronousRequest: request queue: _resultProcessingQueue completionHandler: ^(NSURLResponse* response, NSData* data, NSError* error) {
    
    // Do stuff with response
    if ( error ) {
      DBG(@"Got error %@", error);
    }
    
    id responseObject = [data objectFromJSONData];
    
    // Call the user completion handler if it's set
    if ( completionHandler ) {
      dispatch_async( dispatch_get_main_queue(), ^{
        completionHandler(responseObject, error);
      });
    }
  }];
  return request;
}

#pragma mark - Static Methods

+ (MOHueServiceManager *)sharedInstance {
  @synchronized( self )
  {
    if (instance == nil)
      instance = [[self alloc] init];
  }
  return(instance);
}

@end
