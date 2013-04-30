//
//  MOHueServiceOperationQueue.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueServiceOperationQueue.h"

@interface MOHueServiceOperationQueue () {
  NSMutableArray* _operations;
}

@end

@implementation MOHueServiceOperationQueue

- (id)init {
  if ( self = [super init] ) {
    _operations = [[NSMutableArray alloc] initWithCapacity: 200];
  }
  return self;
}

- (void)enqueueOperation:(MOHueServiceOperation*)operation {
  @synchronized(_operations) {
    [_operations enqueue: operation];
  }
}

- (MOHueServiceOperation*)dequeueOperation {
  @synchronized(_operations) {
    [_operations sortUsingComparator: ^NSComparisonResult(MOHueServiceOperation* operation1, MOHueServiceOperation* operation2) {
      // Descending priority order
      if ( operation1.priority < operation2.priority ) {
        return NSOrderedDescending;
      } else if ( operation1.priority > operation2.priority ) {
        return NSOrderedAscending;
      } else {
        // Ties broken by ascending date order 
        if ( operation1.date.timeIntervalSince1970 < operation2.date.timeIntervalSince1970 ) {
          return NSOrderedAscending;
        } else if ( operation1.date.timeIntervalSince1970 > operation2.date.timeIntervalSince1970 ) {
          return NSOrderedDescending;
        } else {
          return NSOrderedSame;
        }
      }
    }];
    return [_operations dequeue];
  }
}

- (NSUInteger)count {
  @synchronized(_operations) {
    return [_operations count];
  }
}

@end
