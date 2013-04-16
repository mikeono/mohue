//
//  MOHueServiceRequest.h
//  Hue
//
//  Created by Mike Onorato on 4/14/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kMOHTTPRequestMethodGet;
extern NSString* kMOHTTPRequestMethodPost;
extern NSString* kMOHTTPRequestMethodPut;
extern NSString* kMOHTTPRequestMethodDelete;

typedef void(^MOCompletionBlock)(id, NSError*);

@interface MOHueServiceRequest : NSObject

@property (nonatomic, strong) NSString* relativePath;
@property (nonatomic, strong) NSDictionary* bodyDict;
@property (nonatomic, strong) NSString* httpMethod;
@property (nonatomic, assign) float timeout;
@property (nonatomic, copy) MOCompletionBlock completionBlock;

- (id)init;

- (id)initWithRelativePath:(NSString*)relativePath bodyDict:(NSDictionary*)bodyDict httpMethod:(NSString*)httpMethod completionBlock:(MOCompletionBlock)completionBlock;

- (NSURLRequest*)urlRequest;

@end
