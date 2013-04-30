//
//  MOHueServiceOperationQueue.h
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

@class MOHueServiceOperation;

@interface MOHueServiceOperationQueue : NSObject 

- (void)enqueueOperation:(MOHueServiceOperation*)operation;

- (MOHueServiceOperation*)dequeueOperation;

@end
