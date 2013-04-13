//
//  MOLightOnSettingControl.h
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLightOnSettingControl : UIView

@property (nonatomic, readonly) UISlider* brightnessSlider;

@property (nonatomic, assign) NSUInteger brightness;

@end
