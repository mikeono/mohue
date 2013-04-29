//
//  MOUIUtil.h
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOUIUtil : NSObject

@property (nonatomic, readonly) BOOL iPad;
@property (nonatomic, readonly) BOOL iPhone4Inch;

#pragma mark - Static Methods

+ (MOUIUtil*)sharedInstance;

@end
