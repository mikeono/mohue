//
//  MOScheduleOccurrence.h
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@class MOLightState;
@class MOSchedule;

@interface MOScheduleOccurrence : MOModel

@property (nonatomic, readonly) NSString* occurrenceIdentifier;
@property (nonatomic, readonly) NSString* scheduleUUID;
@property (nonatomic, readonly) NSString* hueIdString;
@property (nonatomic, readonly) NSDate* date;
@property (nonatomic, readonly) MOSchedule* schedule;


- (id)initWithSchedule:(MOSchedule*)schedule day:(NSDate*)day;

- (id)initWithHueOccurrenceDict:(NSDictionary*)hueOccurrenceDictionary;

- (id)initWithHueIdString:(NSString*)hueIdString occurrenceIdentifier:(NSString*)occurrenceIdentifier;

+ (NSString*)scheduleUUIDFromOccurrenceIdentifier:(NSString*)occurrenceIdentifier;

+ (BOOL)isValidOccurrenceIdentifier:(NSString*)occurrenceIdentifier;

@end
