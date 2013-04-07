//
//  MOLightState.h
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

typedef enum MOLightColorMode {
  MOLightColorModeHS,
  MOLightColorModeXY,
  MOLightColorModeCT
} MOLightColorMode;

@interface MOLightState : MOModel

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) NSUInteger bri;
@property (nonatomic, assign) NSUInteger hue;
@property (nonatomic, assign) NSUInteger sat;
@property (nonatomic, assign) CGPoint xy;
@property (nonatomic, assign) NSUInteger ct;
@property (nonatomic, assign) MOLightColorMode colorMode;

@end
