//
//  MOModelService.m
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModelService.h"

@implementation MOModelService

+ (MOHueServiceResponseCode)parseHueServiceResponseFromResponseObject:(id)responseObject {
  if ( [responseObject isKindOfClass: [NSArray class]] && [responseObject count] > 0 ) {
    NSArray* responseStrings = [[responseObject objectAtIndex: 0] allKeys];
    int successes = 0;
    int errors = 0;
    for ( NSString* string in responseStrings ) {
      if ( [string isEqualToString: @"success"] ) {
        successes++;
      } else if ( [string isEqualToString: @"error"] ) {
        errors++;
      }
    }
    if ( errors > 0 ) {
      return MOHueServiceResponseFailure;
    } else if ( successes > 0 ) {
      return MOHueServiceResponseSuccess;
    }
  }
  return MOHueServiceResponseUnspecified;
}

@end
