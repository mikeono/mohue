//
//  MOCache.h
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOScheduleList;
@class MOScheduleOccurrenceList;

@interface MOCache : NSObject

@property (nonatomic, strong) MOScheduleList* scheduleList;
@property (nonatomic, strong) MOScheduleOccurrenceList* occurrenceList;

+ (MOCache*)sharedInstance;

@end
