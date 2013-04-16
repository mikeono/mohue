//
//  MOHueScheduleOccurrenceService.m
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueScheduleOccurrenceService.h"
#import "MOHueService.h"
#import "MOHueServiceRequest.h"
#import "MOScheduleList.h"
#import "MOSchedule.h"
#import "MOScheduleOccurrence.h"
#import "NSDate+Hue.h"
#import "MOLightState.h"
#import "MOCache.h"
#import "MOScheduleOccurrenceList.h"

@implementation MOHueScheduleOccurrenceService

#pragma mark - Getting Schedule Occurrences

+ (void)getOccurrenceListWithCompletion:(void(^)(MOScheduleOccurrenceList*, NSError*))completion {
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
    
    // TODO(MO): Handle errors here or in MOHueService
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      // Result Structure: {hueScheduleIdString:{"name": scheduleOccurenceIdentifier}}
      MOScheduleOccurrenceList* occurrenceList = [[MOScheduleOccurrenceList alloc] initWithHueListDictionary: resultObject];
      if ( completion ) {
        completion(occurrenceList, error);
      }
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

#pragma mark - Mutating Occurrences

+ (void)deleteAllOccurrencesOfUUID:(NSString*)scheduleUUID withCompletion:(void(^)(BOOL success))completion {

  __block NSInteger errors = 0;
  [MOHueScheduleOccurrenceService getOccurrenceListWithCompletion: ^(MOScheduleOccurrenceList* occurrenceList, NSError* error) {
    // For each occurrence, if it has the specified UUID, delete it
    for ( MOScheduleOccurrence* occurrence in occurrenceList.occurrences ) {
      if ( [occurrence.scheduleUUID isEqualToString: scheduleUUID] ) {
        [MOHueScheduleOccurrenceService deleteOccurrenceWithHueIdString: occurrence.hueIdString withCompletion: ^(BOOL success) {
          if ( ! success ) {
            errors++;
          }
        }];
      }
    }
    if ( completion ) {
      completion(errors == 0);
    }
  }];

}

+ (void)deleteOccurrenceWithHueIdString:(NSString*)hueIdString withCompletion:(void(^)(BOOL success))completion {
  
  NSString* resourceRelativePath = [NSString stringWithFormat: @"api/1234567890/schedules/%@", hueIdString];
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: resourceRelativePath bodyDict: nil httpMethod: kMOHTTPRequestMethodDelete completionBlock: ^(id resultObject, NSError* error) {
    
    MOHueServiceResponseCode responseCode = [MOHueScheduleOccurrenceService parseHueServiceResponseFromResponseObject: resultObject];
    BOOL success = (responseCode == MOHueServiceResponseSuccess);
    
    if ( completion ) {
      completion(success);
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

@end
