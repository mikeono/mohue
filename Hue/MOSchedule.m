//
//  MOSchedule.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOSchedule.h"

@implementation MOSchedule

- (NSString*)timeString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle: NSDateFormatterNoStyle];
  [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
  
  return [dateFormatter stringFromDate: self.timeOfDay];
}

- (NSString*)dayOfWeekString {
  return [MOSchedule stringForDayOfWeek: self.dayOfWeekMask];
}

#pragma mark - Static Methods

+ (NSString*)stringForDayOfWeek:(MODayOfWeek)dayOfWeek {
  switch ( dayOfWeek ) {
    case MODayOfWeekSunday:
      return @"Sunday";
    case MODayOfWeekMonday:
      return @"Monday";
    case MODayOfWeekTuesday:
      return @"Tuesday";
    case MODayOfWeekWednesday:
      return @"Wednesday";
    case MODayOfWeekThursday:
      return @"Thursday";
    case MODayOfWeekFriday:
      return @"Friday";
    case MODayOfWeekSaturday:
      return @"Saturday";
    default:
      return nil;
  }
}

+ (NSString*)stringForDayOfWeekMask:(MODayOfWeek)dayOfWeekMask {

  // Return day of week if it is one 
  NSString* ret = [self stringForDayOfWeek: dayOfWeekMask];
  if ( ret ) {
    return ret;
  }
  
  // Otherwise return mask if there is one predefined
  switch ( dayOfWeekMask ) {
    case MODayOfWeekWeekend:
      return @"Weekends";
    case MODayOfWeekWeekday:
      return @"Weekdays";
    case MODayOfWeekAll:
      return @"Everyday";
    case MODayOfWeekNone:
      return @"";
    default:
      break;
  }
  
  // Otherwise, create a comma seperated list of the 7 days
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for ( NSNumber* dayNumber in [self daysOfTheWeek] ) {
    MODayOfWeek dayOfWeek = dayNumber.integerValue;
    if ( dayOfWeek & dayOfWeekMask ) {
      [array addObject: [self stringForDayOfWeek: dayOfWeek]];
    }
  }
  return [array componentsJoinedByString: @", "];
}

+ (NSArray*)daysOfTheWeek {
  return @[[NSNumber numberWithInteger: MODayOfWeekSunday],
           [NSNumber numberWithInteger: MODayOfWeekMonday],
           [NSNumber numberWithInteger: MODayOfWeekTuesday],
           [NSNumber numberWithInteger: MODayOfWeekWednesday],
           [NSNumber numberWithInteger: MODayOfWeekThursday],
           [NSNumber numberWithInteger: MODayOfWeekFriday],
           [NSNumber numberWithInteger: MODayOfWeekSaturday],
           ];
}


@end
