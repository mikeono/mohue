//
//  MOScheduleList.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@interface MOScheduleList : MOModel

@property (nonatomic, strong) NSArray* schedules;

- (id)initWithAPIDictionary:(NSDictionary*)dictionary;

- (id)init;

@end
