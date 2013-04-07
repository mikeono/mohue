//
//  MOHueScheduleService.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueScheduleService.h"
#import "MOHueServiceManager.h"
#import "MOScheduleList.h"

@implementation MOHueScheduleService

+ (void)getAllSchedules {
  [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: nil method: @"GET" completionHandler: ^(id resultObject, NSError* error) {
    //MOScheduleList* scheduleList = [[MOScheduleList alloc] initWithAPIDictionary: resultObject];
  }];
}

+ (void)getScheduleId:(NSString*)scheduleId {
  
}

@end
