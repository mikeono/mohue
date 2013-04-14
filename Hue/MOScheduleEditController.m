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
#import "MOLightState.h"
#import "MOHueScheduleService.h"

#define kMOScheduleEditTimePickerHeight 200

#define kMOScheduleEditTimerDetailsRowDays 0
#define kMOScheduleEditTimerDetailsRowName 1
#define kMOScheduleEditTimerDetailsRowCount 2

typedef enum MOScheduleEditSection {
  MOScheduleEditSectionTime,
  MOScheduleEditSectionMode,
  MOScheduleEditSectionModeDetails,
  MOScheduleEditSectionTimerDetails,
  MOScheduleEditSectionCount
} MOScheduleEditSection;

@interface MOScheduleEditController () {
  MOScheduleEditSection _sections[MOScheduleEditSectionCount];
  int _sectionCount;
  MOSchedule* _schedule;
}

@property (nonatomic, strong) MOSchedule* schedule;
@property (nonatomic, assign) BOOL isScheduleNew;
@property (nonatomic, strong) UIDatePicker* timePicker;
@property (nonatomic, strong) MOLightOnSettingControl* lightOnSettingControl;
@property (nonatomic, strong) MOLightModeControl* lightModeControl;
@property (nonatomic, strong) UITextField* nameField;

@end

@implementation MOScheduleEditController

- (id)initWithSchedule:(MOSchedule*)schedule {
  if ( self = [super initWithStyle: UITableViewStyleGrouped] ) {
    // Init iVars
    _isScheduleNew = schedule ? NO : YES;
    _schedule = schedule;
    
    [self configureSections];
    [self reloadData];
    
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

- (void)reloadData {
  if ( self.schedule.timeOfDay ) {
    self.timePicker.date = self.schedule.timeOfDay;
  }
  self.lightModeControl.lightMode = self.schedule.lightState.on ? MOLightModeOn : MOLightModeOff;
  self.lightOnSettingControl.brightness = self.schedule.lightState.bri;
  self.lightOnSettingControl.ct = self.schedule.lightState.ct;
  self.nameField.text = self.schedule.name;
  
  [self.tableView reloadData];
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

- (UITextField*)nameField {
  if ( _nameField == nil ) {
    _nameField = [[UITextField alloc] init];
    _nameField.placeholder = @"Label";
    _nameField.textAlignment = UITextAlignmentRight;
  }
  return _nameField;
}

#pragma mark - Event Handling

- (void)saveButtonPressed {
  
  // Save the choices into the schedule
  self.schedule.timeOfDay = self.timePicker.date;
  self.schedule.lightState.on = (self.lightModeControl.lightMode == MOLightModeOn);
  self.schedule.lightState.bri = self.lightOnSettingControl.brightness;
  self.schedule.lightState.ct = self.lightOnSettingControl.ct;
  self.schedule.name = self.nameField.text;
  
  // Save the schedule to the server
  [MOHueScheduleService saveSchedule: self.schedule];
  
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
      switch ( indexPath.row ) {
        case kMOScheduleEditTimerDetailsRowDays:
        {
          cell.textLabel.text = @"Recurrence";
          cell.detailTextLabel.text = _schedule.dayOfWeekString;
          cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          break;
        }
        case kMOScheduleEditTimerDetailsRowName:
        {
          cell.textLabel.text = @"Label";
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          [cell.contentView addSubview: self.nameField];
          float leftIndent = 85.0f;
          float xPadding = 10.0f;
          float yPadding = 10.0f;
          float cellHeight = [self tableView: tableView heightForRowAtIndexPath: indexPath];
          self.nameField.frame = CGRectMake(leftIndent + xPadding,
                                            yPadding,
                                            [self cellWidth] - leftIndent - 2 * xPadding,
                                            cellHeight - 2 * yPadding);
          break;
        }
        default:
          break;
      }
      return cell;
    }
    case MOScheduleEditSectionTime:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell.contentView addSubview: self.timePicker];
      return cell;
    }
    case MOScheduleEditSectionModeDetails:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [cell.contentView addSubview: self.lightOnSettingControl];
      self.lightOnSettingControl.frame = CGRectMake(0, 0, [self cellWidth], self.lightOnSettingControl.frame.size.height);
      return cell;
    }
    case MOScheduleEditSectionMode:
    {
      UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
