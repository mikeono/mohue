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

@property (nonatomic, strong) MOLightState* lightState;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* scheduleUUID;
@property (nonatomic, readonly) NSString* occurrenceIdentifier;

- (id)initWithSchedule:(MOSchedule*)schedule day:(NSDate*)day;

+ (NSDate*)dateByCombiningTime:(NSDate*)time withDay:(NSDate*)day;

@end
