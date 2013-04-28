//
//  MOAlertManager.h
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kMOAlertNoWifi;
extern NSString* kMOAlertNoInternet;
extern NSString* kMOAlertNoBridge;
extern NSString* kMOAlertNoAuth;

@interface MOAlertManager : NSObject

- (BOOL)alertShown:(NSString*)alert;

- (void)setShown:(BOOL)shown forAlert:(NSString*)alert;

- (void)clearState;

+ (MOAlertManager*)sharedInstance;

+ (UIAlertView*)alertViewWithIdentifier:(NSString*)identifier title:(NSString*)title message:(NSString*)message delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle;

@end
