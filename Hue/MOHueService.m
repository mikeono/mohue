//
//  MOHueService.m
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueService.h"
#import "MOHueServiceRequest.h"
#import "JSONKit.h"
#import "MOHueServiceOperationQueue.h"

@interface MOHueService () {
  MOHueServiceOperationQueue* _requestQueue;
  NSOperationQueue* _resultProcessingQueue;
  BOOL _requestQueueProcessing;
}

@property (atomic, strong) NSDate* lastRequestDate;

@end

@implementation MOHueService

- (id)init {
  if ( self = [super init] ) {
    _username = @"ab72e636502d70a68c88ed42b46825a6";
    _defaultTimeout = 5.0f;
    _resultProcessingQueue = [[NSOperationQueue alloc] init];
    _requestQueue = [[MOHueServiceOperationQueue alloc] init];
    _lastRequestDate = [NSDate dateWithTimeIntervalSince1970: 0];
  }
  return self;
}

#pragma mark - Making requests

- (void)executeAsyncRequest:(MOHueServiceRequest*)hueRequest {
  NSURLRequest* request = hueRequest.urlRequest;
  
  [NSURLConnection sendAsynchronousRequest: request queue: _resultProcessingQueue completionHandler: ^(NSURLResponse* response, NSData* data, NSError* error) {
    
    // Do stuff with response
    //NSString* responseString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //DBG(@"Got response: %@", responseString);
    if ( error ) {
      DBG(@"Got error %@", error);
    }
    
    id responseObject = [data objectFromJSONData];
    
    if ( hueRequest.completionBlock ) {
      hueRequest.completionBlock(responseObject, error);
    }
  }];
}

- (void)executeSyncRequest:(MOHueServiceRequest*)hueRequest {
  NSURLRequest* request = hueRequest.urlRequest;
  NSError *error = nil;
  NSHTTPURLResponse *response = nil;
  
  NSData* data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
  
  // Do stuff with response
  if ( error ) {
    DBG(@"Got error %@", error);
  }
  
  id responseObject = [data objectFromJSONData];
  
  if ( hueRequest.completionBlock ) {
    hueRequest.completionBlock(responseObject, error);
  }
}

#pragma mark - Request Queue

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest {
  [self enqueueRequest: hueRequest withPriority: 0];
}

- (void)enqueueRequest:(MOHueServiceRequest*)hueRequest withPriority:(float)priority {
  MOHueServiceOperation* operation = [[MOHueServiceOperation alloc] initWithRequest: hueRequest date: [NSDate date] priority: priority];
  [_requestQueue enqueueOperation: operation];
}

- (void)processNextQueuedRequest {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
    MOHueServiceRequest* request = [_requestQueue dequeueOperation].request;
    [self executeSyncRequest: request];
  });
}

#pragma mark - Getters and Setters



#pragma mark - Static Methods

+ (MOHueService*)sharedInstance {
  static MOHueService *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MOHueService alloc] init];
  });
  return sharedInstance;
}

+ (MOHueServiceResponseCode)parseHueServiceResponseFromResponseObject:(id)responseObject {
  if ( [responseObject isKindOfClass: [NSArray class]] && [responseObject count] > 0 ) {
    NSArray* responseStrings = [[responseObject objectAtIndex: 0] allKeys];
    int successes = 0;
    int errors = 0;
    for ( NSString* string in responseStrings ) {
      if ( [string isEqualToString: @"success"] ) {
        successes++;
      } else if ( [string isEqualToString: @"error"] ) {
        errors++;
      }
    }
    if ( errors > 0 ) {
      return MOHueServiceResponseFailure;
    } else if ( successes > 0 ) {
      return MOHueServiceResponseSuccess;
    }
  }
  return MOHueServiceResponseUnspecified;
}

@end
