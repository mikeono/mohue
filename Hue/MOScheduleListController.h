//
//  MOScheduleListController.h
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOScheduleList;

@interface MOScheduleListController : UITableViewController {
  MOScheduleList* _scheduleList;
}

@property (nonatomic, strong) MOScheduleList* scheduleList;

- (id)init;

@end
