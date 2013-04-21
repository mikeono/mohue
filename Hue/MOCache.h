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

@property (atomic, strong) MOScheduleList* scheduleList;
@property (atomic, strong) MOScheduleOccurrenceList* occurrenceList;
@property (atomic, strong) NSMutableArray* lights;
@property (atomic, strong) NSDate* lightSyncDate;

+ (MOCache*)sharedInstance;

@end
