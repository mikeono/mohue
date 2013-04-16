//
//  MOHueService.h
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOHueServiceManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString* serverName;

+ (MOHueServiceManager *)sharedInstance;

#pragma mark - Making URL Requests

- (NSMutableURLRequest*)startAsyncRequestWithPath:(NSString*)path body:(NSDictionary*)body  method:(NSString*)method completionHandler:(void (^)(id, NSError*))completionHandler;

@end
