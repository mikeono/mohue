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

@property (nonatomic, readonly) UISlider* ctSlider;

@property (nonatomic, assign) NSUInteger brightness;

@property (nonatomic, assign) NSUInteger ct;

@end
