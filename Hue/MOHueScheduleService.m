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
#import "NSDate+MO.h"
#import "MOLightState.h"

@implementation MOHueScheduleService

+ (void)getAllSchedules {
  MOHueServiceRequest* hueRequest = [[MOHueServiceRequest alloc] initWithRelativePath: @"api/1234567890/schedules" bodyDict: nil httpMethod: kMOHTTPRequestMethodGet completionBlock:^(id resultObject, NSError* error) {
  }];
  
  [[MOHueService sharedInstance] executeAsyncRequest: hueRequest];
}

+ (void)getScheduleId:(NSString*)scheduleId {
  
}

+ (void)postScheduleOccurrence:(MOScheduleOccurrence*)scheduleOccurrence {
  
  // Format time
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  [dateFormatter setTimeZone:gmt];
  [dateFormatter  setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
  NSString* timeString = [dateFormatter stringFromDate: scheduleOccurrence.date];
  
  // Create body
  NSDictionary* commandBody = scheduleOccurrence.lightState.dictionary;
  NSDictionary* command = @{@"address": @"/api/1234567890/lights/1/state",
                            @"method": @"PUT",
                            @"body": commandBody};
  NSDictionary* requestBody = @{@"name": scheduleOccurrence.occurrenceIdentifier,
                                @"description": @"schedule-2-1",
                                @"command": command,
                                @"time": timeString};
  
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

@end
