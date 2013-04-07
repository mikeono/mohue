//
//  MOScheduleEditController.m
//  Hue
//
//  Created by Mike Onorato on 4/7/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleEditController.h"
#import "MOSchedule.h"

@interface MOScheduleEditController ()

@end

@implementation MOScheduleEditController

- (id)initWithSchedule:(MOSchedule*)schedule {
  if ( self = [super init] ) {
    // Init navigation
    self.title = schedule ? @"Edit Schedule" : @"Add Schedule";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

@end
