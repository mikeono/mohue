//
//  MOScheduleOccurrence.m
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleOccurrence.h"
#import "MOLightState.h"
#import "MOSchedule.h"

@interface MOScheduleOccurrence () {
  NSString* _occurrenceIdentifier;
}

@end

@implementation MOScheduleOccurrence

- (id)initWithSchedule:(MOSchedule*)schedule day:(NSDate*)day {
  if ( self = [super init] ) {
    _scheduleUUID = schedule.UUID;
    _lightState = schedule.lightState;
    _name = schedule.name;
    _date = [MOScheduleOccurrence dateByCombiningTime: schedule.timeOfDay withDay: day];
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSString*)occurrenceIdentifier {
  if ( _occurrenceIdentifier == nil ) {
    // Format date
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
    [dateFormatter setTimeZone: gmt];
    [dateFormatter  setDateFormat: @"MMddyyyy"];
    NSString* dateString = [dateFormatter stringFromDate: _date];
    
    _occurrenceIdentifier = [NSString stringWithFormat: @"%@ %@", _scheduleUUID, dateString];
  }
  return _occurrenceIdentifier;
}

- (void)setDate:(NSDate *)date {
  _date = date;
  
  // Reset occurrence identifier
  _occurrenceIdentifier = nil;
}

- (void)setScheduleUUID:(NSString *)scheduleUUID {
  _scheduleUUID = scheduleUUID;
  
  // Reset occurrence identifier
  _occurrenceIdentifier = nil;
}

#pragma mark - Static Methods

// TODO(MO): Make this faster by using NSDateComponents
+ (NSDate*)dateByCombiningTime:(NSDate*)time withDay:(NSDate*)day {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
  [dateFormatter setTimeZone: gmt];
  
  // Format time
  [dateFormatter  setDateFormat: @"HHmmss"];
  NSString* timeString = [dateFormatter stringFromDate: time];
  
  // Format day
  [dateFormatter  setDateFormat: @"MMddyyyy"];
  NSString* dayString = [dateFormatter stringFromDate: day];
  
  // Concat and Parse
  NSString* dateString = [NSString stringWithFormat: @"%@%@", dayString, timeString];
  [dateFormatter  setDateFormat: @"MMddyyyyHHmmss"];
  return [dateFormatter dateFromString: dateString];
}


@end
