//
//  MOScheduleTests.m
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleTests.h"
#import "MOSchedule.h"

@implementation MOScheduleTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testDayOfWeekString {
  MODayOfWeek dayOfWeekMask;
  
  dayOfWeekMask = MODayOfWeekMonday;
  STAssertTrue( [[MOSchedule stringForDayOfWeek: dayOfWeekMask] isEqualToString: @"Monday"], nil);
  
  dayOfWeekMask = MODayOfWeekSunday | MODayOfWeekSaturday;
  STAssertTrue( [[MOSchedule stringForDayOfWeek: dayOfWeekMask] isEqualToString: @"Weekends"], nil);
  
  dayOfWeekMask = MODayOfWeekMonday | MODayOfWeekTuesday;
  STAssertTrue( [[MOSchedule stringForDayOfWeek: dayOfWeekMask] isEqualToString: @"Monday, Tuesday"], nil);
}

@end
