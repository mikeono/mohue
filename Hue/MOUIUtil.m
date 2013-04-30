//
//  MOUIUtil.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOUIUtil.h"

@implementation MOUIUtil

-(id)init {
  if ( self = [super init] ) {
#ifdef UI_USER_INTERFACE_IDIOM
    _iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    _iPad = NO;
#endif
    _iPhone4Inch = !_iPad && CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136));
  }
  return self;
}

#pragma mark - Static Methods

static MOUIUtil* instance = nil;

+ (MOUIUtil*)sharedInstance {
  @synchronized( self )
  {
    if (instance == nil)
      instance = [[self alloc] init];
  }
  return(instance);
}

@end
