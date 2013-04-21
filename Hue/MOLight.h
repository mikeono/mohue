//
//  MOLight.h
//  Hue
//
//  Created by Mike Onorato on 4/20/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@class MOLightState;

@interface MOLight : MOModel

@property (nonatomic, strong) MOLightState* state;
@property (nonatomic, strong) NSString* idString;
@property (nonatomic, strong) NSString* name;

- (id)initWithIdString:(NSString*)idString hueDict:(NSDictionary*)hueDict;

@end
