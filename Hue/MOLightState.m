//
//  MOLightState.m
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightState.h"
#import "JSONKit.h"
#import "NSDictionary+MO.h"

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

- (id)initWithHueStateDict:(NSDictionary*)dict {
  if ( self = [super init] ) {
    // Structure {"bri":bri,"ct":ct,"colorMode":colorMode,"on":on}
    DBG(@"dict %@", dict);
    _on = [dict numberForKey: @"on"].boolValue;
    _bri = [dict numberForKey: @"bri"].integerValue;
    _hue = [dict numberForKey: @"hue"].integerValue;
    _sat = [dict numberForKey: @"sat"].integerValue;
    _xy = [dict pointForKey: @"xy"];
    _ct = [dict numberForKey: @""].integerValue;
    NSString* colorMode = [dict valueForKey: @"colormode"];
    _colorMode = colorMode;
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSDictionary*)dictionary {
  NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
  [dictionary setObject: [NSNumber numberWithBool: _on] forKey: @"on"];
  [dictionary setObject: [NSNumber numberWithInteger: _bri] forKey: @"bri"];
  [dictionary setObject: _colorMode forKey: @"colormode"];
  
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
