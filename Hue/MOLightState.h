//
//  MOLightState.h
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

extern NSString* kMOLightColorModeHS;
extern NSString* kMOLightColorModeXY;
extern NSString* kMOLightColorModeCT;

@interface MOLightState : MOModel

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) NSUInteger bri;
@property (nonatomic, assign) NSUInteger hue;
@property (nonatomic, assign) NSUInteger sat;
@property (nonatomic, assign) CGPoint xy;
@property (nonatomic, assign) NSUInteger ct;
@property (nonatomic, assign) NSString* colorMode;

@property (nonatomic, readonly) NSDictionary* dictionary;

@end
