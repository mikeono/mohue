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

@interface MOHueService () {
  NSOperationQueue* _resultProcessingQueue;
}

@end

@implementation MOHueService

- (id)init {
  if ( self = [super init] ) {
    //_serverName = @"192.168.1.5";
    _username = @"1234567890";
    _defaultTimeout = 5.0f;
    _resultProcessingQueue = [[NSOperationQueue alloc] init];
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
  NSString* responseString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
  //DBG(@"Got response: %@", responseString);
  if ( error ) {
    DBG(@"Got error %@", error);
  }
  
  id responseObject = [data objectFromJSONData];
  
  if ( hueRequest.completionBlock ) {
    hueRequest.completionBlock(responseObject, error);
  }
}

- (void)handleAsyncResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error hueRequest:(MOHueServiceRequest*)hueRequest {
  
}

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
