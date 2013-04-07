//
//  MOHueService.h
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOHueService : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString* serverName;

+ (MOHueService *)sharedInstance;

#pragma mark - Making URL Requests

- (NSMutableURLRequest*)requestWithPath:(NSString*)path body:(NSDictionary*)body method:(NSString*)method;

- (NSMutableURLRequest*)startAsyncRequestWithPath:(NSString*)path body:(NSDictionary*)body  method:(NSString*)method userCompletionHandler:(void (^)(NSURLResponse*, id, NSError*))userCompletionHandler;

@end
