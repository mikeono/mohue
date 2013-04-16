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
#import "NSDate+Hue.h"

@interface MOScheduleOccurrence () {
  NSString* _occurrenceIdentifier;
}

@end

@implementation MOScheduleOccurrence

- (id)initWithSchedule:(MOSchedule*)schedule day:(NSDate*)day {
  if ( self = [super init] ) {
    
    // Populate fields
    _scheduleUUID = schedule.UUID;
    _date = [NSDate dateByCombiningTime: schedule.timeOfDay withDay: day];
    _schedule = schedule;
    
    // Generate occurrence identifier
    NSString* dateString = [[NSDate occurrenceIdentifierDateFormatter] stringFromDate: _date];
    _occurrenceIdentifier = [NSString stringWithFormat: @"%@ %@", _scheduleUUID, dateString];
  }
  return self;
}

- (id)initWithHueOccurrenceDict:(NSDictionary*)dict {
  if ( self = [super init] ) {
    
    // Structure: { "name": occurrenceIdentifier, "description": additionalFields, "command":{"body": commandBodyDict}, "time": "2013-04-14T23:00:50"}
    
    // Populate occurrence fields
    _occurrenceIdentifier = [dict valueForKey: @"name"];
    _scheduleUUID = [MOScheduleOccurrence scheduleUUIDFromOccurrenceIdentifier: _occurrenceIdentifier];
    _date = [NSDate dateFromHueString: [dict valueForKey: @"time"]];
    
    // Populate schedule
    _schedule = [[MOSchedule alloc] initWithHueOccurrenceDict: dict];
  }
  return self;
}

#pragma mark - Static Methods

+ (NSString*)scheduleUUIDFromOccurrenceIdentifier:(NSString*)occurrenceIdentifier {
  NSArray* components = [occurrenceIdentifier componentsSeparatedByString: @" "];
  if ( [components count] > 0 ) {
    return [components objectAtIndex: 0];
  }
  return nil;
}

@end
