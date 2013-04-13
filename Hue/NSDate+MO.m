//
//  NSDate+MO.m
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "NSDate+MO.h"

@implementation NSDate (MO)

+ (NSDate*)dateInGMT {
  NSLog(@"newDate: %@", [NSDate date]);
  
  NSDate *newDate;
  NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate: [NSDate date]];
  
  newDate = [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
  NSLog(@"newDate: %@", newDate);
  NSLog(@"newDate: %.0f", [newDate timeIntervalSinceReferenceDate]);
  
  [dateComponents setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
  newDate = [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
  NSLog(@"newDate: %@", newDate);
  NSLog(@"newDate: %.0f", [newDate timeIntervalSinceReferenceDate]);

  return newDate;
}

@end
