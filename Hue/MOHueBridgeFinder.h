//
//  MOHueBridgeFinder.h
//  Hue
//
//  Created by Mike Onorato on 4/21/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kMOHueBridgeFinderStatusChangeNotification;

typedef enum MOHueBridgeStatus {
  MOHueBridgeStatusNotUpdated = 0,
  MOHueBridgeStatusUpdating = 1,
  MOHueBridgeStatusNoWifi = 2,
  MOHueBridgeStatusNoInternet = 3,
  MOHueBridgeStatusNoWebsite = 4,
  MOHueBridgeStatusNoBridge = 5,
  MOHueBridgeStatusNoAuth = 6,
  MOHueBridgeStatusAuthCancelled = 7,
  MOHueBridgeStatusAuthed = 8
} MOHueBridgeStatus;

@interface MOHueBridgeFinder : NSObject <UIAlertViewDelegate>

- (void)updateBridgeStatus;

- (void)resetStatus;

- (MOHueBridgeStatus)bridgeStatus;

- (void)reconnect;

+ (MOHueBridgeFinder*)sharedInstance;

@end
