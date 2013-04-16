//
//  MOModel.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MOModelDetail {
  MOModelDetailSummary,
  MOModelDetailDefault
} MOModelDetail;

@interface MOModel : NSObject 

@property (nonatomic, assign) MOModelDetail detail;

+ (NSString*)generateUUID;

@end
