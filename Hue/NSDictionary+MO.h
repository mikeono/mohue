//
//  NSDictionary+MO.h
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MO)

- (NSNumber*)numberForKey:(id)key;

- (NSDictionary*)dictForKey:(id)key;

- (CGPoint)pointForKey:(id)key;

@end
