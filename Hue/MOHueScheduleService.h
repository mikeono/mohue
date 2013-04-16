//
//  MOHueScheduleService.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kMOReceivedScheduleFromHue;

@class MOSchedule;
@class MOScheduleOccurrence;

@interface MOHueScheduleService : NSObject

+ (void)syncDownSchedules;

+ (void)syncDownScheduleWithHueId:(NSString*)hueScheduleId;

+ (void)getAllSchedules;

+ (void)postScheduleOccurrence:(MOScheduleOccurrence*)scheduleOccurrence;

+ (void)postSchedule:(MOSchedule*)schedule;

+ (void)saveSchedule:(MOSchedule*)schedule;

@end
