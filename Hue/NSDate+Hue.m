//
//  NSDate+Hue.m
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "NSDate+Hue.h"

@implementation NSDate (Hue)

- (NSString*)hueDateString {
  return [[NSDate hueDateFormatter] stringFromDate: self];
}

+ (NSDate*)dateFromHueString:(NSString*)string {
  return [[NSDate hueDateFormatter] dateFromString: string];
}

+ (NSDateFormatter*)hueDateFormatter {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  [dateFormatter setTimeZone:gmt];
  [dateFormatter  setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
  return dateFormatter;
}

+ (NSDateFormatter*)occurrenceIdentifierDateFormatter {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation: @"GMT"];
  [dateFormatter setTimeZone: gmt];
  [dateFormatter  setDateFormat: @"MMddyyyy"];
  return dateFormatter;
}

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

@end
