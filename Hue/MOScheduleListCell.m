//
//  MOScheduleListCell.m
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleListCell.h"
#import "MOSchedule.h"

@implementation MOScheduleListCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: reuseIdentifier];
  if ( self ) {
    
  }
  return self;
}

#pragma mark - Getters and Setters

- (void)setSchedule:(MOSchedule *)schedule {
  _schedule = schedule;
  
  self.textLabel.text = _schedule.timeString;
  self.detailTextLabel.text = _schedule.dayOfWeekString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected: selected animated: animated];
}

@end
