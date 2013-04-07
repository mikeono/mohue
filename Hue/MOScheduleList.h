//
//  MOScheduleList.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@interface MOScheduleList : MOModel

- (id)initWithAPIDictionary:(NSDictionary*)dictionary;

// Array of NSString indexes 
- (NSArray*)scheduleIds;

@end
