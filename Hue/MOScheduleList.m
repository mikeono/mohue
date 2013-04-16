//
//  MOScheduleList.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleList.h"
#import "MOSchedule.h"

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

#pragma mark - Mutation

- (void)addSchedule:(MOSchedule*)schedule {
  // Additional check to make sure not adding an existing schedule
  if ( ! [self containsUUID: schedule.UUID] ) {
    [self.schedules addObject: schedule];
  }
  
  // TODO(MO): Sort by time
  
}

#pragma mark - Reading

- (BOOL)containsUUID:(NSString*)scheduleUUID {
  for ( MOSchedule* schedule in _schedules ) {
    if ( [schedule.UUID isEqualToString: scheduleUUID] ) {
      return YES;
    }
  }
  return NO;
}

@end
