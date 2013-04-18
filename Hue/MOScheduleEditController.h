//
//  MOScheduleEditController.h
//  Hue
//
//  Created by Mike Onorato on 4/7/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOScheduleRecurrenceController.h"

@class MOSchedule;

@interface MOScheduleEditController : UITableViewController <MOScheduleRecurrenceControllerDelegate>

- (id)initWithSchedule:(MOSchedule*)schedule;

@end

