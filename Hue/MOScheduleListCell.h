//
//  MOScheduleListCell.h
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOSchedule;

@interface MOScheduleListCell : UITableViewCell

@property (nonatomic, strong) MOSchedule* schedule;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
