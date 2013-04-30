//
//  MOHueServiceOperation.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOHueServiceOperation.h"
#import "MOHueServiceRequest.h"

@implementation MOHueServiceOperation

- (id)initWithRequest:(MOHueServiceRequest*)request date:(NSDate*)date priority:(float)priority {
  if ( self = [super init] ) {
    _request = request;
    _priority = priority;
    _date = date;
  }
  return self;
}

@end
