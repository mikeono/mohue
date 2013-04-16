//
//  MOLightModeControl.h
//  Hue
//
//  Created by Mike Onorato on 4/13/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MOLightMode {
  MOLightModeOn = 0,
  MOLightModeOff = 1
} MOLightMode;

@interface MOLightModeControl : UIView

@property (nonatomic, assign) MOLightMode lightMode;

@end
