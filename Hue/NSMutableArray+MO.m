//
//  NSMutableArray+MO.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "NSMutableArray+MO.h"

@implementation NSMutableArray (MO)

#pragma mark - Queue Operations

- (id)dequeue {
  if ( [self count] == 0 ) {
    return nil;
  }
  id object = [self objectAtIndex: 0];
  [self removeObjectAtIndex: 0];
  return object;
}

- (void)enqueue:(id)object {
  [self addObject: object];
}

@end
