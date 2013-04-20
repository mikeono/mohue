//
//  MOHueScheduleService.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleService.h"
#import "MOHueService.h"
#import "MOHueServiceRequest.h"
#import "MOScheduleList.h"
#import "MOSchedule.h"
#import "MOScheduleOccurrence.h"
#import "NSDate+Hue.h"
#import "MOLightState.h"
#import "MOCache.h"
#import "MOScheduleOccurrenceService.h"

NSString* kMOReceivedScheduleFromHue = @"ReceivedScheduleFromHue";

@implementation MOScheduleService

#pragma mark - Getting Schedules

+ (void)syncDownSchedules {
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
    
    // TODO(MO): Handle errors here or in MOHueService
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      // Result Structure: {hueScheduleIdString:{"name": scheduleOccurenceIdentifier}}
      NSDictionary* hueScheduleListDict = resultObject;
      
      // For each schedule:
      for ( NSString* hueScheduleIdString in hueScheduleListDict.allKeys ) {
        NSDictionary* hueScheduleDict = [hueScheduleListDict valueForKey: hueScheduleIdString];
        NSString* scheduleOccurenceIdentifier = [hueScheduleDict valueForKey: @"name"];
        
        // Ensure the occurrence identifier is valid
        if ( [MOScheduleOccurrence isValidOccurrenceIdentifier: scheduleOccurenceIdentifier] ) {
          NSString* scheduleUUID = [MOScheduleOccurrence scheduleUUIDFromOccurrenceIdentifier: scheduleOccurenceIdentifier];
          
          // If schedule doesn't exist in cache, sync it down
          if ( ! [[[MOCache sharedInstance] scheduleList] containsUUID: scheduleUUID] ) {
            // TODO(MO): Implement MOHueServiceOperationQueue so schedule sync requests can be sent synchronously 
            [MOScheduleService syncDownScheduleWithHueId: hueScheduleIdString];
          }
        }
      }
    }
    
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)syncDownScheduleWithHueId:(NSString*)hueScheduleId {
  NSString* relativePath = [NSString stringWithFormat: @"api/1234567890/schedules/%@", hueScheduleId];
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: relativePath bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock: ^(id resultObject, NSError* error) {
    
    // TODO(MO): Handle errors here or in MOHueService
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      
      // Create MOSchedule and add it to MOCache
      MOSchedule* schedule = [[MOSchedule alloc] initWithHueOccurrenceDict: resultObject];
      
      dispatch_sync( dispatch_get_main_queue(), ^{
        [[[MOCache sharedInstance] scheduleList] addSchedule: schedule];
        [[NSNotificationCenter defaultCenter] postNotificationName: kMOReceivedScheduleFromHue object: nil userInfo: nil];
      });
    }
  }];
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)getAllSchedules {
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
  }];
  
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

#pragma mark - Posting Schedules

+ (void)postScheduleOccurrence:(MOScheduleOccurrence*)scheduleOccurrence {
  
  // Create body
  NSDictionary* commandBody = scheduleOccurrence.schedule.lightState.dictionary;
  NSDictionary* command = @{@"address": @"/api/1234567890/groups/0/action",
                            @"method": kMOHTTPRequestMethodPut,
                            @"body": commandBody};
  NSDictionary* requestBody = @{@"name": scheduleOccurrence.occurrenceIdentifier,
                                @"description": scheduleOccurrence.schedule.additionalFields,
                                @"command": command,
                                @"time": scheduleOccurrence.date.hueDateString};
  
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: requestBody httpMethod: kMOHTTPRequestMethodPost completionBlock: nil];
  
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)postSchedule:(MOSchedule*)schedule {
  
  // Create and post up to 7 occurrences 
  for (int daysAfterToday = -1; daysAfterToday < 6; daysAfterToday++) {
    NSDate* day = [NSDate dateWithTimeIntervalSinceNow: daysAfterToday * 60 * 60 * 24];
    MOScheduleOccurrence* scheduleOccurrence = [[MOScheduleOccurrence alloc] initWithSchedule: schedule day: day];
    [MOScheduleService postScheduleOccurrence: scheduleOccurrence];
  }
}

+ (void)saveSchedule:(MOSchedule*)schedule {
  
  // If schedule exists, remove it
  [MOScheduleOccurrenceService deleteAllOccurrencesOfUUID: schedule.UUID withCompletion: ^(BOOL success) {
    if ( success ) {
      DBG(@"Deleted all occurrences successfully");
    } else {
      DBG(@"Deleted all occurrences with errors");
    }
    
    // Post schedule
    [MOScheduleService postSchedule: schedule];
  }];
}

@end
