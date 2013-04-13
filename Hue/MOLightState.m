//
//  MOLightState.m
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightState.h"
#import "JSONKit.h"

NSString* kMOLightColorModeHS = @"hs";
NSString* kMOLightColorModeXY = @"xy";
NSString* kMOLightColorModeCT = @"ct";

@implementation MOLightState

- (id)init {
  if ( self = [super init] ) {
    _on = YES;
    _bri = 255;
    _ct = 326;
    _colorMode = kMOLightColorModeCT;
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSDictionary*)dictionary {
  NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
  [dictionary setObject: [NSNumber numberWithBool: _on] forKey: @"on"];
  [dictionary setObject: [NSNumber numberWithInteger: _bri] forKey: @"bri"];
  [dictionary setObject: _colorMode forKey: @"colorMode"];
  
  if ( [_colorMode isEqualToString: kMOLightColorModeHS] ) {
    [dictionary setObject: [NSNumber numberWithInteger: _hue] forKey: @"hue"];
    [dictionary setObject: [NSNumber numberWithInteger: _sat] forKey: @"sat"];
  } else if ( [_colorMode isEqualToString: kMOLightColorModeXY] ) {
    [dictionary setObject: @[[NSNumber numberWithFloat: _xy.x], [NSNumber numberWithFloat: _xy.y]] forKey: @"xy"];
  } else if ( [_colorMode isEqualToString: kMOLightColorModeCT] ) {
    [dictionary setObject: [NSNumber numberWithInteger: _ct] forKey: @"ct"];
  }
  
  return dictionary;
}

@end
