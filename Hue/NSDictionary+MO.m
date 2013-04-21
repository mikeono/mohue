//
//  NSDictionary+MO.m
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "NSDictionary+MO.h"
#import "NSArray+MO.h"

@implementation NSDictionary (MO)

- (NSNumber*)numberForKey:(id)key {
  id object = [self objectForKey: key];
  if ( [object isKindOfClass: [NSNumber class]] ) {
    return object;
  }
  return nil;
}

- (NSDictionary*)dictForKey:(id)key {
  id object = [self objectForKey: key];
  if ( [object isKindOfClass: [NSDictionary class]] ) {
    return object;
  }
  return nil;
}

- (CGPoint)pointForKey:(id)key {
  id object = [self objectForKey: key];
  if ( [object isKindOfClass: [NSArray class]] ) {
    NSArray* array = object;
    if ( [array count] >= 2 ) {
      return CGPointMake([array numberAtIndex: 0].floatValue, [array numberAtIndex: 1].floatValue);
    }
  }
  return CGPointZero;
}

@end
