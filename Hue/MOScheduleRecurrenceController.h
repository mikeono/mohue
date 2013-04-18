//
//  MOScheduleRecurrenceController.h
//  Hue
//
//  Created by Mike Onorato on 4/18/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSchedule.h"

@class MOScheduleRecurrenceController;

@protocol MOScheduleRecurrenceControllerDelegate

- (void)recurrenceController:(MOScheduleRecurrenceController*)recurrenceController didChangeDayOfWeekMask:(MODayOfWeek)dayOfWeekMask;

@end

@interface MOScheduleRecurrenceController : UITableViewController

@property (nonatomic, weak) id<MOScheduleRecurrenceControllerDelegate> delegate;
@property (nonatomic, assign) MODayOfWeek dayOfWeekMask;

@end
