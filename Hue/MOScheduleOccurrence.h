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

@property (nonatomic, readonly) MOLightState* lightState;
@property (nonatomic, readonly) NSDate* date;
@property (nonatomic, readonly) NSString* label;
@property (nonatomic, readonly) NSString* scheduleUUID;
@property (nonatomic, readonly) NSString* additionalFields;
@property (nonatomic, readonly) NSString* occurrenceIdentifier;


- (id)initWithSchedule:(MOSchedule*)schedule day:(NSDate*)day;

- (id)initWithHueOccurrenceDict:(NSDictionary*)hueOccurrenceDictionary;

+ (NSDate*)dateByCombiningTime:(NSDate*)time withDay:(NSDate*)day;

+ (NSString*)scheduleUUIDFromOccurrenceIdentifier:(NSString*)occurrenceIdentifier;

@end
