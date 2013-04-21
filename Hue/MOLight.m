//
//  MOLight.m
//  Hue
//
//  Created by Mike Onorato on 4/20/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOLight.h"
#import "MOLightState.h"

@implementation MOLight

- (id)initWithIdString:(NSString*)idString hueDict:(NSDictionary*)hueDict {
  if ( self = [super init] ) {
    // Format: { "state": stateDict, "name", name, "type", ...}
    _idString = idString;
    _name = [hueDict objectForKey: @"name"];
    _state = [[MOLightState alloc] initWithHueStateDict: [hueDict dictForKey: @"state"]];
  }
  return self;
}

@end
