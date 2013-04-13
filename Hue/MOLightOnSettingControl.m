//
//  MOLightOnSettingControl.m
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightOnSettingControl.h"

#define kMOLightOnSettingControlHeight 300.0f

@interface MOLightOnSettingControl () {
  UILabel* _brightnessLabel;
}

@end

@implementation MOLightOnSettingControl

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kMOLightOnSettingControlHeight)];
  if ( self ) {
    // Init view
    self.backgroundColor = [UIColor clearColor];
    
    // Add subviews
    _brightnessLabel = [[UILabel alloc] init];
    _brightnessLabel.text = @"Brightness";
    [self addSubview: _brightnessLabel];
    
    _brightnessSlider = [[UISlider alloc] init];
    [self addSubview: _brightnessSlider];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  float yPadding = 5.0f;
  float xPadding = 10.0f;
  float labelHeight = 20.0f;
  
  _brightnessLabel.frame = CGRectMake(xPadding,
                                      yPadding,
                                      self.frame.size.width - 2 * xPadding,
                                      labelHeight);
  _brightnessSlider.frame = CGRectMake(xPadding,
                                       _brightnessLabel.frame.origin.y + _brightnessLabel.frame.size.height + yPadding,
                                       self.frame.size.width - 2 * xPadding,
                                       _brightnessSlider.frame.size.height);
}

#pragma mark - Getters and Setters

- (NSUInteger)brightness {
  return _brightnessSlider.value * 255;
}

- (void)setBrightness:(NSUInteger)brightness {
  _brightnessSlider.value = brightness / 255.0f;
}

@end
