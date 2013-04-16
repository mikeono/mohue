//
//  MOScheduleOccurrenceList.m
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleOccurrenceList.h"
#import "MOScheduleOccurrence.h"

@implementation MOScheduleOccurrenceList

- (id)init {
  if ( self = [super init] ) {
    _occurrencesByHueId = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (id)initWithHueListDictionary:(NSDictionary*)hueListDict {
  if ( self = [super init] ) {
    _occurrencesByHueId = [[NSMutableDictionary alloc] init];
    
    // Structure: {hueIdString:{"name": occurrenceIdentifier},
    for ( NSString* hueIdString in hueListDict.allKeys ) {
      // Create occurrence and add to occurrences dicts
      NSString* occurrenceIdentifier = [[hueListDict objectForKey: hueIdString] objectForKey: @"name"];
      MOScheduleOccurrence* occurrence = [[MOScheduleOccurrence alloc] initWithHueIdString: hueIdString occurrenceIdentifier: occurrenceIdentifier];
      [_occurrencesByHueId setObject: occurrence forKey: hueIdString];
    }
  }
  return self;
}

- (NSArray*)occurrences {
  return _occurrencesByHueId.allValues;
}

@end
