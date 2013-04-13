//
//  MOScheduleEditController.h
//  Hue
//
//  Created by Mike Onorato on 4/7/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MOScheduleEditSection {
  MOScheduleEditSectionTime,
  MOScheduleEditSectionMode,
  MOScheduleEditSectionModeDetails,
  MOScheduleEditSectionTimerDetails,
  MOScheduleEditSectionCount
} MOScheduleEditSection;

@class MOSchedule;

@interface MOScheduleEditController : UITableViewController

- (id)initWithSchedule:(MOSchedule*)schedule;

@end

