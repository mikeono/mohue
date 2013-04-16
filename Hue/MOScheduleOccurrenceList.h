//
//  MOScheduleOccurrenceList.h
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@interface MOScheduleOccurrenceList : MOModel {
  NSMutableDictionary* _occurrencesByHueId; // Structure: {hueIdNumber:scheduleOccurrence},
  NSDictionary* _occurrencesByIdentifier; // Structure: {occurrenceIdentifier:scheduleOccurrence},
}

@property (nonatomic, readonly) NSArray* occurrences;

- (id)init;

- (id)initWithHueListDictionary:(NSDictionary*)hueListDict;

@end
