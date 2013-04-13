//
//  MOScheduleList.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@class MOSchedule;

@interface MOScheduleList : MOModel

@property (nonatomic, strong) NSMutableArray* schedules;

- (id)initWithAPIDictionary:(NSDictionary*)dictionary;

- (id)init;

- (void)addSchedule:(MOSchedule*)schedule;

@end
