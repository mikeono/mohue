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

@end
