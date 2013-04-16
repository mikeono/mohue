//
//  NSDate+Hue.h
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Hue)

- (NSString*)hueDateString;

+ (NSDate*)dateFromHueString:(NSString*)string;

+ (NSDateFormatter*)hueDateFormatter;

+ (NSDateFormatter*)occurrenceIdentifierDateFormatter;

+ (NSDate*)dateByCombiningTime:(NSDate*)time withDay:(NSDate*)day;

@end
