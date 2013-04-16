//
//  MOModelService.h
//  Hue
//
//  Created by Mike Onorato on 4/15/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MOHueServiceResponseCode {
  MOHueServiceResponseUnspecified = 0,
  MOHueServiceResponseSuccess,
  MOHueServiceResponseFailure
} MOHueServiceResponseCode;

@interface MOModelService : NSObject

+ (MOHueServiceResponseCode)parseHueServiceResponseFromResponseObject:(id)responseObject;

@end
