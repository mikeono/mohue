//
//  MOHueScheduleService.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOSchedule;
@class MOScheduleOccurrence;

@interface MOHueScheduleService : NSObject

+ (void)getAllSchedules;

+ (void)getScheduleId:(NSString*)scheduleId;

+ (void)postScheduleOccurrence:(MOScheduleOccurrence*)scheduleOccurrence;

+ (void)postSchedule:(MOSchedule*)schedule;

+ (void)saveSchedule:(MOSchedule*)schedule;

@end
