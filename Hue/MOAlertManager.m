//
//  MOAlertManager.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOAlertManager.h"

NSString* kMOAlertNoWifi = @"alert.no.wifi";
NSString* kMOAlertNoInternet = @"alert.no.internet";
NSString* kMOAlertNoBridge = @"alert.no.bridge";
NSString* kMOAlertNoAuth = @"alert.no.auth";

@interface MOAlertManager () {
  NSMutableSet* _alertsShown;
}

@end

@implementation MOAlertManager

- (id)init {
  if ( self = [super init] ) {
    _alertsShown = [NSMutableSet set];
  }
  return self;
}

- (BOOL)alertShown:(NSString*)alert {
  return [_alertsShown containsObject: alert];
}

- (void)setShown:(BOOL)shown forAlert:(NSString*)alert {
  
  [_alertsShown removeObject: alert];
  
  if ( shown ) {
    [_alertsShown addObject: alert];
  }
}

- (void)clearState {
  _alertsShown = [NSMutableSet set];
}

+ (UIAlertView*)alertViewWithIdentifier:(NSString*)identifier title:(NSString*)title message:(NSString*)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle {
  
  // If alert not shown before, return nil
  if ( [[MOAlertManager sharedInstance] alertShown: identifier] ) {
    return nil;
    
  // Otherwise return alert view
  } else {
    if ( identifier != nil ) {
      [[MOAlertManager sharedInstance] setShown: YES forAlert: identifier];
    }
    return [[UIAlertView alloc] initWithTitle: title message: message delegate: delegate cancelButtonTitle: cancelButtonTitle otherButtonTitles: otherButtonTitle, nil];
  }
}

#pragma mark - Static Methods

+ (MOAlertManager*)sharedInstance {
  static MOAlertManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MOAlertManager alloc] init];
  });
  return sharedInstance;
}


@end
