//
//  MOScheduleList.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleList.h"

@implementation MOScheduleList

- (id)initWithAPIDictionary:(NSDictionary*)dictionary {
  if ( self = [super init] ) {
    _dictionary = dictionary;
  }
  return self;
}

- (NSArray*)scheduleIds {
  return [_dictionary allKeys];
}

@end
