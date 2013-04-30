//
//  NSMutableArray+MO.h
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MO)

- (id)dequeue;

- (void)enqueue:(id)object;

@end
