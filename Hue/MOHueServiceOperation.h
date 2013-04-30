//
//  MOHueServiceOperation.h
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOHueServiceRequest;

@interface MOHueServiceOperation : NSObject

@property (nonatomic, strong) MOHueServiceRequest* request;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) float priority;

- (id)initWithRequest:(MOHueServiceRequest*)request date:(NSDate*)date priority:(float)priority;

@end
