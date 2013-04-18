//
//  MOSchedule.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOSchedule.h"
#import "MOLightState.h"
#import "MOScheduleOccurrence.h"
#import "NSDate+Hue.h"

@implementation MOSchedule

- (id)init {
  if ( self = [super init] ) {
    _UUID = [MOModel generateUUID];
    _dayOfWeekMask = MODayOfWeekAll;
    _label = @"";
  }
  return self;
}

- (id)initWithHueOccurrenceDict:(NSDictionary*)hueOccurrenceDictionary {
  if ( self = [super init] ) {
    // Structure: { "name": occurrenceIdentifier, "description": additionalFields, "command":{"body": commandBodyDict}, "time": "2013-04-14T23:00:50"}
    
    // Parse UUID
    NSString* occurrenceIdentifier = [hueOccurrenceDictionary valueForKey: @"name"];
    _UUID = [MOScheduleOccurrence scheduleUUIDFromOccurrenceIdentifier: occurrenceIdentifier];
    
    // Parse Additional Fields
    NSString* additionalFieldsString = [hueOccurrenceDictionary valueForKey: @"description"];
    NSArray* additionalFields = [additionalFieldsString componentsSeparatedByString: @"-"];
    NSString* dayOfWeekMaskString = [additionalFields objectAtIndex: 0];
    _dayOfWeekMask = dayOfWeekMaskString.integerValue;
    _label = [additionalFields objectAtIndex: 1];
    
    // Parse Command Body Dict
    NSDictionary* commandBodyDict = [[hueOccurrenceDictionary valueForKey: @"command"] valueForKey: @"body"];
    _lightState = [[MOLightState alloc] initWithHueCommandDict: commandBodyDict];
    
    // Parse Time
    NSString* dateString = [hueOccurrenceDictionary valueForKey: @"time"];
    _timeOfDay = [NSDate dateFromHueString: dateString];
  }
  return self;
}

#pragma mark - Getters and Setters

- (MOLightState*)lightState {
  if ( _lightState == nil ) {
    _lightState = [[MOLightState alloc] init];
  }
  return _lightState;
}

- (NSString*)timeString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle: NSDateFormatterNoStyle];
  [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
  
  return [dateFormatter stringFromDate: self.timeOfDay];
}

- (NSString*)dayOfWeekString {
  return [MOSchedule stringForDayOfWeekMask: self.dayOfWeekMask];
}

- (NSString*)additionalFields {
  DBG(@"Additional fields %@", [NSString stringWithFormat: @"%d-%@", self.dayOfWeekMask, self.label]);
  return [NSString stringWithFormat: @"%d-%@", self.dayOfWeekMask, self.label];
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

+ (NSString*)shortStringForDayOfWeek:(MODayOfWeek)dayOfWeek {
  switch ( dayOfWeek ) {
    case MODayOfWeekSunday:
      return @"Sun";
    case MODayOfWeekMonday:
      return @"Mon";
    case MODayOfWeekTuesday:
      return @"Tue";
    case MODayOfWeekWednesday:
      return @"Wed";
    case MODayOfWeekThursday:
      return @"Thu";
    case MODayOfWeekFriday:
      return @"Fri";
    case MODayOfWeekSaturday:
      return @"Sat";
    default:
      return nil;
  }
}


+ (NSString*)stringForDayOfWeekMask:(MODayOfWeek)dayOfWeekMask {

  // Return day of week if it is one 
  NSString* stringForDay = [self stringForDayOfWeek: dayOfWeekMask];
  if ( stringForDay ) {
    return [NSString stringWithFormat: @"Every %@", stringForDay];
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
      [array addObject: [self shortStringForDayOfWeek: dayOfWeek]];
    }
  }
  return [array componentsJoinedByString: @" "];
}

static NSArray *daysOfTheWeek;

+ (NSArray*)daysOfTheWeek {
  if (!daysOfTheWeek) {
    daysOfTheWeek = @[[NSNumber numberWithInteger: MODayOfWeekSunday],
           [NSNumber numberWithInteger: MODayOfWeekMonday],
           [NSNumber numberWithInteger: MODayOfWeekTuesday],
           [NSNumber numberWithInteger: MODayOfWeekWednesday],
           [NSNumber numberWithInteger: MODayOfWeekThursday],
           [NSNumber numberWithInteger: MODayOfWeekFriday],
           [NSNumber numberWithInteger: MODayOfWeekSaturday],
           ];
  }
  return daysOfTheWeek;
}


@end
