//
//  MOScheduleList.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleList.h"

@implementation MOScheduleList

- (id)init {
  if ( self = [super init] ) {
  }
  return self;
}

- (id)initWithAPIDictionary:(NSDictionary*)dictionary {
  if ( self = [super init] ) {
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSArray*)schedules {
  if ( _schedules == nil ) {
    _schedules = [[NSMutableArray alloc] init];
  }
  return _schedules;
}

#pragma mark - Mutations

- (void)addSchedule:(MOSchedule*)schedule {
  [self.schedules addObject: schedule];
}

@end
