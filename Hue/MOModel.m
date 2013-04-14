//
//  MOModel.m
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOModel.h"

@implementation MOModel

+ (NSString*)generateUUID {
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef cfString = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  NSString* nsString = (__bridge_transfer NSString *) cfString;
  nsString = [nsString stringByReplacingOccurrencesOfString: @"-" withString: @""];
  return [nsString substringToIndex: 18];
}

@end
