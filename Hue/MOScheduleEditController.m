//
//  MOScheduleEditController.m
//  Hue
//
//  Created by Mike Onorato on 4/7/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleEditController.h"
#import "MOSchedule.h"
#import "MOScheduleList.h"
#import "MOCache.h"
#import "MOLightOnSettingControl.h"
#import "MOLightModeControl.h"

#define kMOScheduleEditTimePickerHeight 200.0f

@interface MOScheduleEditController () {
  MOScheduleEditSection _sections[MOScheduleEditSectionCount];
  int _sectionCount;
}

@property (nonatomic, strong) MOSchedule* schedule;
@property (nonatomic, assign) BOOL isScheduleNew;
@property (nonatomic, strong) UIDatePicker* timePicker;
@property (nonatomic, strong) MOLightOnSettingControl* lightOnSettingControl;
@property (nonatomic, strong) MOLightModeControl* lightModeControl;

@end

@implementation MOScheduleEditController

- (id)initWithSchedule:(MOSchedule*)schedule {
  if ( self = [super initWithStyle: UITableViewStyleGrouped] ) {
    // Init iVars
    _schedule = schedule;
    _isScheduleNew = schedule ? NO : YES;
    
    [self configureSections];
    
    // Init navigation
    self.title = _isScheduleNew ? @"Edit Schedule" : @"Add Schedule";
    
    // Init nav bar buttons
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  float pickerHeight = kMOScheduleEditTimePickerHeight;
  float pickerPercentOfSuperviewWidth = 0.8;
  float pickerWidth = self.timePicker.superview.frame.size.width * pickerPercentOfSuperviewWidth;
  self.timePicker.frame = CGRectMake(0, 0, pickerWidth, pickerHeight);
  self.timePicker.center = self.timePicker.superview.center;
}

#pragma mark - Getters and Setters

- (MOSchedule*)schedule {
  if ( _schedule == nil ) {
    _schedule = [[MOSchedule alloc] init];
  }
  return _schedule;
}

- (UIDatePicker*)timePicker {
  if ( _timePicker == nil ) {
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.datePickerMode = UIDatePickerModeTime;
  }
  return _timePicker;
}

- (MOLightOnSettingControl*)lightOnSettingControl {
  if ( _lightOnSettingControl == nil ) {
    _lightOnSettingControl = [[MOLightOnSettingControl alloc] init];
  }
  return _lightOnSettingControl;
}

- (MOLightModeControl*)lightModeControl {
  if ( _lightModeControl == nil ) {
    _lightModeControl = [[MOLightModeControl alloc] init];
  }
  return _lightModeControl;
}

#pragma mark - Event Handling

- (void)saveButtonPressed {
  
  // Save the choices into the schedule
  self.schedule.timeOfDay = self.timePicker.date;
  
  // If in add mode, add the schedule to the list 
  if ( _isScheduleNew ) {
    [[MOCache sharedInstance].scheduleList addSchedule: self.schedule];
  }
  
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)cancelButtonPressed {
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Private methods 

- (void)configureSections {
  _sectionCount = 0;
  _sections[_sectionCount++] = MOScheduleEditSectionTime;
  _sections[_sectionCount++] = MOScheduleEditSectionTimerDetails;
  _sections[_sectionCount++] = MOScheduleEditSectionMode;
  _sections[_sectionCount++] = MOScheduleEditSectionModeDetails;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch ( _sections[section] ) {
    case MOScheduleEditSectionTimerDetails:
      return 2;
    default:
      return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
  switch ( _sections[indexPath.section] ) {
    case MOScheduleEditSectionTimerDetails:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: nil];
      
      return cell;
    }
    case MOScheduleEditSectionTime:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      [cell.contentView addSubview: self.timePicker];
      return cell;
    }
    case MOScheduleEditSectionModeDetails:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      [cell.contentView addSubview: self.lightOnSettingControl];
      self.lightOnSettingControl.frame = CGRectMake(0, 0, [self cellWidth], self.lightOnSettingControl.frame.size.height);
      return cell;
    }
    case MOScheduleEditSectionMode:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      [cell.contentView addSubview: self.lightModeControl];
      self.lightModeControl.frame = CGRectMake(0, 0, [self cellWidth], self.lightModeControl.frame.size.height);
      return cell;
    }
    default: {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      return cell;
    }
  }

}

- (float)cellWidth {
  // TODO(MO): Make this properly calculate for widths other than 320px
  return self.tableView.frame.size.width - 20.0f;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch ( _sections[indexPath.section] ) {
    case MOScheduleEditSectionTime:
    {
      return kMOScheduleEditTimePickerHeight;
    }
    case MOScheduleEditSectionModeDetails:
    {
      return self.lightOnSettingControl.frame.size.height;
    }
    case MOScheduleEditSectionMode:
    {
      return self.lightModeControl.frame.size.height;
    }
    default:
    {
      return [super tableView: tableView heightForRowAtIndexPath: indexPath];
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark - Event Handling

- (void)addButtonPressed {
  [self pushScheduleEditControllerForSchedule: nil];
}

- (void)pushScheduleEditControllerForSchedule:(MOSchedule*)schedule {
  MOScheduleEditController* scheduleController = [[MOScheduleEditController alloc] initWithSchedule: nil];
  [self.navigationController pushViewController: scheduleController animated: YES];
  
}

@end
