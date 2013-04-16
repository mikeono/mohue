//
//  MOModel.h
//  Hue
//
//  Created by Mike Onorato on 3/16/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MOModelDetail {
  MOModelDetailDefault = 0,
  MOModelDetailSummary
} MOModelDetail;

@interface MOModel : NSObject {
  MOModelDetail _levelOfDetail;
}

@property (nonatomic, assign) MOModelDetail levelOfDetail;

+ (NSString*)generateUUID;

@end
