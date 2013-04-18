//
//  MOScheduleRecurrenceController.m
//  Hue
//
//  Created by Mike Onorato on 4/18/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleRecurrenceController.h"

@interface MOScheduleRecurrenceController () {
  MODayOfWeek _daysOfTheWeek[kMODaysPerWeek];
  MODayOfWeek _dayOfWeekMask;
}

@end

@implementation MOScheduleRecurrenceController

- (id)init {
  self = [super initWithStyle: UITableViewStyleGrouped];
  if ( self ) {
    self.title = @"Recurrence";
    
    [self configureSections];
  }
  return self;
}

#pragma mark - Getters and Setters

- (void)setDayOfWeekMask:(MODayOfWeek)dayOfWeekMask {
  _dayOfWeekMask = dayOfWeekMask;
  
  [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)configureSections {
  for ( int i = 0; i < kMODaysPerWeek; i++ ) {
    NSNumber* dayOfWeek = [[MOSchedule daysOfTheWeek] objectAtIndex: i];
    _daysOfTheWeek[i] = dayOfWeek.integerValue;
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return kMODaysPerWeek;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
  
  MODayOfWeek dayOfWeekForRow = _daysOfTheWeek[indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat: @"Every %@", [MOSchedule stringForDayOfWeek: dayOfWeekForRow]];
  
  if ( _dayOfWeekMask & dayOfWeekForRow ) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Update view
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
  UITableViewCell *theCell = [tableView cellForRowAtIndexPath: indexPath];
  if (theCell.accessoryType == UITableViewCellAccessoryNone) {
    theCell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    theCell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Save Data
  MODayOfWeek dayOfWeekForRow = _daysOfTheWeek[indexPath.row];
  // If day of week is on, turn it off
  if ( _dayOfWeekMask & dayOfWeekForRow ) {
    _dayOfWeekMask = _dayOfWeekMask & ~dayOfWeekForRow;
  }
  // Otherwise, turn it on
  else {
    _dayOfWeekMask = _dayOfWeekMask | dayOfWeekForRow;
  }
  
  // Message delegate
  [_delegate recurrenceController: self didChangeDayOfWeekMask: self.dayOfWeekMask];
}

@end
