//
//  MOLightState.m
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightState.h"

@implementation MOLightState

- (id)init {
  if ( self = [super init] ) {
    _on = YES;
    _bri = 255;
    _ct = 326;
    _colorMode = MOLightColorModeCT;
  }
  return self;
}

@end
