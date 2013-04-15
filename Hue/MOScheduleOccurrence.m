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
    _label = schedule.label;
    _additionalFields = schedule.additionalFields;
    _date = [MOScheduleOccurrence dateByCombiningTime: schedule.timeOfDay withDay: day];
  }
  return self;
}

- (id)initWithHueOccurrenceDict:(NSDictionary*)hueOccurrenceDictionary {
  if ( self = [super init] ) {
    //Structure: { "name": occurrenceIdentifier, "description": additionalFields, "command":{"body": commandBodyDict}, "time": "2013-04-14T23:00:50"}
    _occurrenceIdentifier = [hueOccurrenceDictionary valueForKey: @"name"];
    [MOScheduleOccurrence scheduleUUIDFromOccurrenceIdentifier: _occurrenceIdentifier];
    
    // TODO(MO): Convert to using a schedule object property and populate that here
    
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
      DBG(@"Occ identifier name is %@", _occurrenceIdentifier);
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

#pragma mark - Parsing hue data

- (void)parseAdditionalFields {
  
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

+ (NSString*)scheduleUUIDFromOccurrenceIdentifier:(NSString*)occurrenceIdentifier {
  NSArray* components = [occurrenceIdentifier componentsSeparatedByString: @" "];
  if ( [components count] > 0 ) {
    return [components objectAtIndex: 0];
  }
  return nil;
}

@end
