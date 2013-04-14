//
//  MOHueServiceRequest.m
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueServiceRequest.h"
#import "MOHueService.h"
#import "JSONKit.h"

NSString* kMOHTTPRequestMethodGet = @"GET";
NSString* kMOHTTPRequestMethodPost = @"POST";
NSString* kMOHTTPRequestMethodPut = @"PUT";
NSString* kMOHTTPRequestMethodDelete = @"DELETE";

@implementation MOHueServiceRequest

- (id)init {
  if ( self = [super init] ) {
    _timeout = [MOHueService sharedInstance].defaultTimeout;
  }
  return self;
}

- (id)initWithRelativePath:(NSString*)relativePath bodyDict:(NSDictionary*)bodyDict httpMethod:(NSString*)httpMethod completionBlock:(MOCompletionBlock)completionBlock {
  if ( self = [self init] ) {
    _relativePath = relativePath;
    _bodyDict = bodyDict;
    _httpMethod = httpMethod;
    _completionBlock = completionBlock;
  }
  return self;
}

- (NSURLRequest*)urlRequest {
  // Create Request
  NSString* fullPath = [NSString stringWithFormat: @"http://%@/%@", [MOHueService sharedInstance].serverName, _relativePath];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fullPath]];
  
  // Set HTTP Method and Body
  NSData* data = [_bodyDict JSONData];
  [request setHTTPMethod: _httpMethod ? _httpMethod : kMOHTTPRequestMethodPost];
  [request setValue: @"text/json" forHTTPHeaderField: @"Content-type"];
  [request setValue: [NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField: @"Content-length"];
  [request setHTTPBody: data];
  
  // Set timeout
  request.timeoutInterval = _timeout;
  
  return request;
}

@end
