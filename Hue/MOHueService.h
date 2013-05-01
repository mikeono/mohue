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
@property (nonatomic, assign) float maxRequestsPerSecond;
@property (nonatomic, assign) BOOL requestQueuePaused;

#pragma mark - Making requests

- (void)executeRequest:(MOHueServiceRequest*)hueRequest;

// TODO(MO): remove this from interface
- (void)executeRequestWhenReady:(MOHueServiceRequest*)hueRequest;

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest;

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest priority:(NSInteger)priority;

#pragma mark - Rate Limiting

- (BOOL)isReady;

#pragma mark - Static Methods

+ (MOHueService*)sharedInstance;

+ (MOHueServiceResponseCode)parseHueServiceResponseFromResponseObject:(id)responseObject;

@end
