//
//  MOHueService.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueService.h"
#import "JSONKit.h"

@interface MOHueService ()

@property (nonatomic, strong) NSOperationQueue* resultProcessingQueue;

@end

@implementation MOHueService

static MOHueService *instance = nil;

- (id)init {
  self = [super init];
  if ( self ) {
    // Init iVars
    _resultProcessingQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

#pragma mark - Getters and Setters

- (NSString*)serverName {
  return @"192.168.0.20"; //@"192.168.1.8";
}

#pragma mark - Making URL Requests


- (NSMutableURLRequest*)requestWithPath:(NSString*)path body:(NSDictionary*)body method:(NSString*)method {
  NSString* fullURLString = [NSString stringWithFormat: @"http://%@/%@", self.serverName, path];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fullURLString]];
  
  NSData* data = [body JSONData];
  [request setHTTPMethod: method ? method : @"POST"];
  [request setValue: @"text/json" forHTTPHeaderField: @"Content-type"];
  [request setValue: [NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField: @"Content-length"];
  [request setHTTPBody: data];
  
  return request;
}

- (NSMutableURLRequest*)startAsyncRequestWithPath:(NSString*)path body:(NSDictionary*)body method:(NSString*)method userCompletionHandler:(void (^)(NSURLResponse*, id, NSError*))userCompletionHandler {
  NSMutableURLRequest* request = [self requestWithPath: path body: body method: method];
 
  [NSURLConnection sendAsynchronousRequest: request queue: _resultProcessingQueue completionHandler: ^(NSURLResponse* response, NSData* data, NSError* error) {
    
    // Do stuff with response
    NSString* responseString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    DBG(@"Got response: %@", responseString);
    
    // Call the user completion handler if it's set
    if ( userCompletionHandler ) {
      userCompletionHandler(response, responseString, error);
    }
  }];
  return request;
}

#pragma mark - Static Methods

+ (MOHueService *)sharedInstance {
  @synchronized( self )
  {
    if (instance == nil)
      instance = [[self alloc] init];
  }
  return(instance);
}

@end
