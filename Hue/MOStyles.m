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
  [[UINavigationBar appearance] setTintColor: [MOStyles brownDark]];
  [[UIToolbar appearance] setTintColor: [MOStyles brownDark]];
  [[UISlider appearance] setThumbTintColor: [MOStyles brownDark]];
}

#pragma mark - Colors

+ (UIColor*)brownDark {
  return [UIColor colorWithRed:0.089 green:0.086 blue:0.066 alpha:1.000];
}

+ (UIColor*)yellowLight {
  return [UIColor colorWithRed:0.886 green:0.863 blue:0.765 alpha:1.000];
}

+ (UIColor*)yellowBright {
  return [UIColor colorWithRed:0.931 green:0.848 blue:0.267 alpha:1.000];
}

+ (UIColor*)blueBright {
  return [UIColor colorWithRed:0.083 green:0.508 blue:0.883 alpha:1.000];
}

+ (UIColor*)blueLightBackground {
  return [UIColor colorWithRed:0.859 green:0.873 blue:0.931 alpha:1.000];
}

+ (UIColor*)grayMediumText {
  return [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1.000];
}

@end