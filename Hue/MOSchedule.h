//
//  MOSchedule.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@class MOLightState;

typedef enum MODayOfWeek {
  MODayOfWeekSunday    = 0x0000001,
  MODayOfWeekMonday    = 0x0000010,
  MODayOfWeekTuesday   = 0x0000100,
  MODayOfWeekWednesday = 0x0001000,
  MODayOfWeekThursday  = 0x0010000,
  MODayOfWeekFriday    = 0x0100000,
  MODayOfWeekSaturday  = 0x1000000,
  MODayOfWeekWeekend   = 0x1000001,
  MODayOfWeekWeekday   = 0x0111110,
  MODayOfWeekAll       = 0x1111111,
  MODayOfWeekNone      = 0
} MODayOfWeek;

@interface MOSchedule : MOModel

@property (nonatomic, strong) NSDate* timeOfDay;
@property (nonatomic, assign) MODayOfWeek dayOfWeekMask;
@property (nonatomic, strong) MOLightState* lightState;
@property (nonatomic, strong) NSString* name;

@property (nonatomic, readonly) NSString* timeString;

@property (nonatomic, readonly) NSString* dayOfWeekString;

#pragma mark - Static methods

+ (NSString*)stringForDayOfWeek:(MODayOfWeek)dayOfWeek;

+ (NSString*)stringForDayOfWeekMask:(MODayOfWeek)dayOfWeekMask;

+ (NSArray*)daysOfTheWeek;

@end
