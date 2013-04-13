//
//  MOLightModeControl.m
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLightModeControl.h"

#define kMOLightModeControlHeight 60.0f

@interface MOLightModeControl () {
  UISegmentedControl* _segmentedControl;
}

@end

@implementation MOLightModeControl

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kMOLightModeControlHeight)];
  if ( self ) {
    // Init view
    self.backgroundColor = [UIColor clearColor];
    
    // Add subviews
    _segmentedControl = [[UISegmentedControl alloc] initWithItems: @[@"ON", @"OFF"]];
    self.lightMode = MOLightModeOn;
    [self addSubview: _segmentedControl];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _segmentedControl.frame = self.bounds;
}

#pragma mark - Getters and Setters

- (MOLightMode)lightMode {
  return _segmentedControl.selectedSegmentIndex;
}

- (void)setLightMode:(MOLightMode)lightMode {
  _segmentedControl.selectedSegmentIndex = lightMode;
}

@end
