//
//  NSArray+MO.m
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "NSArray+MO.h"

@implementation NSArray (MO)

- (NSNumber*)numberAtIndex:(NSUInteger)index {
  id object = [self objectAtIndex: index];
  if ( [object isKindOfClass: [NSNumber class]] ) {
    return object;
  }
  return nil;
}

@end
