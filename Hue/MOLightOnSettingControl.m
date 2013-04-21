//
//  MOLightOnSettingControl.m
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightOnSettingControl.h"
#import "MOStyles.h"

#define kMOMaxBrightness 255
#define kMOMaxCt 500
#define kMOMinCt 153
#define kMOLightOnSettingControlHeight 300.0f

@interface MOLightOnSettingControl () {
  UILabel* _brightnessLabel;
  UILabel* _ctLabel;
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
    _brightnessLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: _brightnessLabel];
    
    _brightnessSlider = [[UISlider alloc] init];
    _brightnessSlider.maximumTrackTintColor = [MOStyles colorDarkBrown];
    _brightnessSlider.minimumTrackTintColor = [MOStyles colorLightYellow];
    [self addSubview: _brightnessSlider];
    
    _ctLabel = [[UILabel alloc] init];
    _ctLabel.text = @"Color Temperature";
    _ctLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: _ctLabel];
    
    _ctSlider = [[UISlider alloc] init];
    _ctSlider.maximumTrackTintColor = [MOStyles colorBrightYellow];
    //_ctSlider.minimumTrackTintColor = [MOStyles colorLightYellow];
    [self addSubview: _ctSlider];
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
  _ctLabel.frame = CGRectMake(xPadding,
                              _brightnessSlider.frame.origin.y + _brightnessSlider.frame.size.height + yPadding,
                              self.frame.size.width - 2 * xPadding,
                              labelHeight);
  _ctSlider.frame = CGRectMake(xPadding,
                               _ctLabel.frame.origin.y + _ctLabel.frame.size.height + yPadding,
                               self.frame.size.width - 2 * xPadding,
                               _ctSlider.frame.size.height);
}

#pragma mark - Getters and Setters

- (NSUInteger)brightness {
  return _brightnessSlider.value * kMOMaxBrightness;
}

- (void)setBrightness:(NSUInteger)brightness {
  _brightnessSlider.value = brightness / ((float) kMOMaxBrightness);
}

- (NSUInteger)ct {
  return ((1.0f - _ctSlider.value) * (kMOMaxCt - kMOMinCt)) + kMOMinCt;
}

- (void)setCt:(NSUInteger)ct {
  _ctSlider.value = 1.0f - ((ct - kMOMinCt) / (float) (kMOMaxCt - kMOMinCt));
}

@end
