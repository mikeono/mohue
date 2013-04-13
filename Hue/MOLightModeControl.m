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
    _segmentedControl.selectedSegmentIndex = 0;
    [self addSubview: _segmentedControl];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _segmentedControl.frame = self.bounds;
}

@end
