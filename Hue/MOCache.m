//
//  MOCache.m
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOCache.h"
#import "MOScheduleList.h"
#import "MOScheduleOccurrenceList.h"

@implementation MOCache

- (id)init {
  if ( self = [super init] ) {
    
  }
  return self;
}

#pragma mark - Getters and Setters

- (MOScheduleList*)scheduleList {
  if ( _scheduleList == nil ) {
    _scheduleList = [[MOScheduleList alloc] init];
  }
  return _scheduleList;
}

- (MOScheduleOccurrenceList*)occurrenceList {
  if ( _occurrenceList == nil ) {
    _occurrenceList = [[MOScheduleOccurrenceList alloc] init];
  }
  return _occurrenceList;
}

#pragma mark - Static Methods

+ (MOCache*)sharedInstance {
  static MOCache *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MOCache alloc] init];
  });
  return sharedInstance;
}

@end
