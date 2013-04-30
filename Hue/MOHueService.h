//
//  MOHueService.h
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MOHueServiceResponseCode {
  MOHueServiceResponseUnspecified = 0,
  MOHueServiceResponseSuccess,
  MOHueServiceResponseFailure
} MOHueServiceResponseCode;

@class MOHueServiceRequest;

@interface MOHueService : NSObject

@property (nonatomic, strong) NSString* serverName;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, assign) float defaultTimeout;
@property (nonatomic, assign) BOOL requestQueuePaused;

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest;

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest withPriority:(float)priority;

- (void)executeAsyncRequest:(MOHueServiceRequest*)hueRequest;

- (void)executeSyncRequest:(MOHueServiceRequest*)hueRequest;

+ (MOHueService*)sharedInstance;

+ (MOHueServiceResponseCode)parseHueServiceResponseFromResponseObject:(id)responseObject;

@end
