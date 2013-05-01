//
//  MOLightService.m
//  Hue
//
//  Created by Mike Onorato on 4/20/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightService.h"
#import "MOLightState.h"
#import "MOHueService.h"
#import "MOHueServiceRequest.h"
#import "MOCache.h"
#import "MOLight.h"

NSString* kMOReceivedLightFromHue = @"ReceivedScheduleFromHue";

@implementation MOLightService

+ (void)putStateForAllLights:(MOLightState*)lightState {
  
  DBG(@"putting state for all lights");
  
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"groups/0/action" bodyDict: lightState.dictionary httpMethod: kMOHTTPRequestMethodPut completionBlock: nil];
  
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)putState:(MOLightState*)lightState forLightIdString:(NSString*)lightIdString {
  
  DBG(@"putting state for light %@", lightIdString);
  
  NSString* relativePath = [NSString stringWithFormat: @"lights/%@/state", lightIdString];
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: relativePath bodyDict: lightState.dictionary httpMethod: kMOHTTPRequestMethodPut completionBlock: nil];
  
  [[MOHueService sharedInstance] executeRequestWhenReady: hueRequest];
}


+ (void)syncDownLightsWithCompletion:(void(^)(BOOL success))completion {
  
  DBG(@"Syncing lights");
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"lights" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
    
    BOOL success = NO;
    // TODO(MO): Handle errors here or in MOHueService
    
    DBG(@"Syncing lights %@", resultObject);
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      // Result Structure: {lightIdString1:{"name": lightName}, lightIdString2:{"name": lightName}}
      NSDictionary* lightListDict = resultObject;
      
      // For each light:
      [MOCache sharedInstance].lights = [NSMutableArray array];
      for ( NSString* lightIdString in lightListDict.allKeys ) {
        [MOLightService syncDownLightWithIdString: lightIdString];
      }
      success = YES;
    }
    if ( completion ) {
     completion ( success );
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)syncDownLightWithIdString:(NSString*)idString {
  NSString* relativePath = [NSString stringWithFormat: @"lights/%@", idString];
  
  DBG(@"syncing light %@", idString);
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: relativePath bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock: ^(id resultObject, NSError* error) {
    
    // TODO(MO): Handle errors here or in MOHueService
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      
      // Create MOSchedule and add it to MOCache
      MOLight* light = [[MOLight alloc] initWithIdString: idString hueDict: resultObject];
      
      dispatch_sync( dispatch_get_main_queue(), ^{
        [[MOCache sharedInstance].lights addObject: light];
          DBG(@"added object for light %@", idString);
        [MOCache sharedInstance].lightSyncDate = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName: kMOReceivedLightFromHue object: nil userInfo: nil];
      });
    }
  }];
  [[MOHueService sharedInstance] executeRequestWhenReady: hueRequest];
}

@end
