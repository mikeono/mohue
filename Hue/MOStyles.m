//
//  MOStyles.m
//  Hue
//
//  Created by Mike Onorato on 4/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOStyles.h"

@implementation MOStyles

+ (void)applyStylesToAppearance {  
  [[UINavigationBar appearance] setTintColor: [MOStyles colorDarkBrown]];
  [[UIToolbar appearance] setTintColor: [MOStyles colorDarkBrown]];
  [[UISlider appearance] setThumbTintColor: [MOStyles colorDarkBrown]];
}

#pragma mark - Colors

+ (UIColor*)colorDarkBrown {
  return [UIColor colorWithRed:0.089 green:0.086 blue:0.066 alpha:1.000];
}

+ (UIColor*)colorLightYellow {
  return [UIColor colorWithRed:0.886 green:0.863 blue:0.765 alpha:1.000];
}

+ (UIColor*)colorBrightYellow {
  return [UIColor colorWithRed:0.931 green:0.848 blue:0.267 alpha:1.000];
}

@end