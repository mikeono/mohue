//
//  MOHueScheduleService.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueScheduleService.h"
#import "MOHueService.h"
#import "MOHueServiceRequest.h"
#import "MOScheduleList.h"
#import "MOSchedule.h"
#import "MOScheduleOccurrence.h"
#import "NSDate+Hue.h"
#import "MOLightState.h"
#import "MOCache.h"

NSString* kMOReceivedScheduleFromHue = @"ReceivedScheduleFromHue";

@implementation MOHueScheduleService

#pragma mark - Posting Schedules

+ (void)postScheduleOccurrence:(MOScheduleOccurrence*)scheduleOccurrence {
  
  // Create body
  NSDictionary* commandBody = scheduleOccurrence.schedule.lightState.dictionary;
  NSDictionary* command = @{@"address": @"/api/1234567890/lights/1/state",
                            @"method": @"PUT",
                            @"body": commandBody};
  NSDictionary* requestBody = @{@"name": scheduleOccurrence.occurrenceIdentifier,
                                @"description": scheduleOccurrence.schedule.additionalFields,
                                @"command": command,
                                @"time": scheduleOccurrence.date.hueDateString};
  
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: requestBody httpMethod: kMOHTTPRequestMethodPost completionBlock: nil];
  
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)postSchedule:(MOSchedule*)schedule {
  
  // Create 1 occurrence and post it
  MOScheduleOccurrence* scheduleOccurrence = [[MOScheduleOccurrence alloc] initWithSchedule: schedule day:[NSDate date]];
  
  [MOHueScheduleService postScheduleOccurrence: scheduleOccurrence];
}

+ (void)saveSchedule:(MOSchedule*)schedule {
  
  // If schedule exists, remove it
  
  // Post schedule
  [MOHueScheduleService postSchedule: schedule];
}

#pragma mark - Getting Schedules

+ (void)syncDownSchedules {
  
  // Create request
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
    
    // TODO(MO): Handle errors here or in MOHueService
    
    // Make sure got back a dict
    if ( [resultObject isKindOfClass: [NSDictionary class]] ) {
      // Result Structure: {hueScheduleIdString:{"name": scheduleOccurenceIdentifier}}
      NSDictionary* hueScheduleListDict = resultObject;
      
      // For each schedule, if it doesn't exist in cache, sync it down
      for ( NSString* hueScheduleIdString in hueScheduleListDict.allKeys ) {
        NSDictionary* hueScheduleDict = [hueScheduleListDict valueForKey: hueScheduleIdString];
        NSString* scheduleOccurenceIdentifier = [hueScheduleDict valueForKey: @"name"];
        NSString* scheduleUUID = [MOScheduleOccurrence scheduleUUIDFromOccurrenceIdentifier: scheduleOccurenceIdentifier];
        if ( ! [[[MOCache sharedInstance] scheduleList] containsUUID: scheduleUUID] ) {
          [MOHueScheduleService syncDownScheduleWithHueId: hueScheduleIdString];
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
    
      // MOCache is not thread safe so add schedule on main thread
      dispatch_async( dispatch_get_main_queue(), ^{
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

@end
