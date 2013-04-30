//
//  MOLightService.h
//  Hue
//
//  Created by Mike Onorato on 4/20/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kMOReceivedLightFromHue;

@class MOLightState;

@interface MOLightService : NSObject

+ (void)putStateForAllLights:(MOLightState*)lightState;

+ (void)putStateForAllLightsIfReady:(MOLightState*)lightState;

+ (void)putState:(MOLightState*)lightState forLightIdString:(NSString*)lightIdString;

+ (void)syncDownLightsWithCompletion:(void(^)(BOOL success))completion;

+ (void)syncDownLightWithIdString:(NSString*)idString;

@end
