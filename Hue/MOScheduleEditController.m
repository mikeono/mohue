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
#import "MOScheduleService.h"
#import "MOLightService.h"
#import "MOLight.h"

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
  NSTimer* _exitPreviewTimer;
  BOOL _transitioningFromPreview;
  BOOL _transitioningIntoPreview;
  NSTimer* _previewTimer;
}

@property (nonatomic, strong) MOSchedule* schedule;
@property (nonatomic, assign) BOOL isScheduleNew;
@property (nonatomic, strong) UIDatePicker* timePicker;
@property (nonatomic, strong) MOLightOnSettingControl* lightOnSettingControl;
@property (nonatomic, strong) MOLightModeControl* lightModeControl;
@property (nonatomic, strong) UITextField* nameField;
@property (nonatomic, strong) MOScheduleRecurrenceController* recurrenceController;
@property (nonatomic, assign) BOOL previewing;

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
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style:UIBarButtonItemStyleDone target: self action: @selector(saveButtonPressed)];
    saveButton.tintColor = [MOStyles blueBright];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.backgroundView = nil;
  self.tableView.backgroundColor = [MOStyles blueLightBackground];
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
  self.nameField.text = self.schedule.label;
  
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
    [_lightOnSettingControl.brightnessSlider addTarget: self action: @selector(startUpdatingPreview) forControlEvents: UIControlEventTouchDown];
    [_lightOnSettingControl.ctSlider addTarget: self action: @selector(startUpdatingPreview) forControlEvents: UIControlEventTouchDown];
    [_lightOnSettingControl.brightnessSlider addTarget: self action: @selector(updatePreviewAndExitWithDelay) forControlEvents: UIControlEventTouchUpInside];
    [_lightOnSettingControl.ctSlider addTarget: self action: @selector(updatePreviewAndExitWithDelay) forControlEvents: UIControlEventTouchUpInside];
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

- (MOScheduleRecurrenceController*)recurrenceController {
  if ( _recurrenceController == nil ) {
    _recurrenceController = [[MOScheduleRecurrenceController alloc] init];
    _recurrenceController.delegate = self;
    _recurrenceController.dayOfWeekMask = _schedule.dayOfWeekMask;
  }
  return _recurrenceController;
}

#pragma mark - Event Handling

- (void)saveButtonPressed {
  
  // Save the choices into the schedule
  self.schedule.timeOfDay = self.timePicker.date;
  self.schedule.lightState.on = (self.lightModeControl.lightMode == MOLightModeOn);
  self.schedule.lightState.bri = self.lightOnSettingControl.brightness;
  self.schedule.lightState.ct = self.lightOnSettingControl.ct;
  self.schedule.label = self.nameField.text;
  self.schedule.dayOfWeekMask = self.recurrenceController.dayOfWeekMask;
  
  // Save the schedule to the server
  [MOScheduleService saveSchedule: self.schedule];
  
  // If in add mode, add the schedule to the list
  if ( _isScheduleNew ) {
    [[MOCache sharedInstance].scheduleList addSchedule: self.schedule];
  }
  
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)cancelButtonPressed {
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)startUpdatingPreview {
  [self updatePreview];
  _previewTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(updatePreview) userInfo: nil repeats: YES];
}

- (void)updatePreview {
  // Sync down the light state if not in preview mode
  if ( ! self.previewing && ! _transitioningFromPreview  ) {
    _transitioningIntoPreview = YES;
    [MOLightService syncDownLightsWithCompletion: ^(BOOL success) {
      dispatch_sync(dispatch_get_main_queue(), ^(){
        _transitioningIntoPreview = NO;
        self.previewing = YES;
      });
    }];
  } else if ( ! _transitioningIntoPreview ) {
    self.previewing = YES;
  }
}

- (void)updatePreviewAndExitWithDelay {

  [_previewTimer invalidate];
  [self updatePreview];
  _exitPreviewTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(turnOffPreview) userInfo: nil repeats: NO];
}


- (void)setPreviewing:(BOOL)previewing {
  _previewing = previewing;

  // If turning on preview
  if ( _previewing ) {
    // Set light state
    MOLightState* state = [[MOLightState alloc] init];
    state.bri = self.lightOnSettingControl.brightness;
    state.ct = self.lightOnSettingControl.ct;
    state.colorMode = kMOLightColorModeCT;
    state.on = YES;
    [MOLightService putStateForAllLights: state];
    
    // Stop timer
    [_exitPreviewTimer invalidate];
  }
  
  // If exiting preview mode, put state for each light
  if ( ! _previewing ) {
    _transitioningFromPreview = YES;
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
      for ( MOLight* light in [MOCache sharedInstance].lights ) {
        DBG(@"lights %d", [MOCache sharedInstance].lights.count);
        [MOLightService putState: light.state forLightIdString: light.idString];
        dispatch_sync(dispatch_get_main_queue(), ^(){
          _transitioningFromPreview = NO;
        });
      }
    });
  }
}

- (void)turnOffPreview {
  self.previewing = NO;
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
          cell.textLabel.text = @"Repeat";
          MODayOfWeek dayOfWeekMask;
          if ( _recurrenceController ) {
            dayOfWeekMask = _recurrenceController.dayOfWeekMask;
          } else {
            dayOfWeekMask = _schedule.dayOfWeekMask;
          }
          cell.detailTextLabel.text = [MOSchedule stringForDayOfWeekMask: dayOfWeekMask];
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
      static NSString* cellIdentifier = @"TimeCell";
      UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
      if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview: self.timePicker];
      }
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
  if ( _sections[indexPath.section] == MOScheduleEditSectionTimerDetails && indexPath.row == kMOScheduleEditTimerDetailsRowDays ) {
    [self.navigationController pushViewController: self.recurrenceController animated: YES];
  }
}

#pragma mark - MOScheduleRecurrenceControllerDelegate

- (void)recurrenceController:(MOScheduleRecurrenceController*)recurrenceController didChangeDayOfWeekMask:(MODayOfWeek)dayOfWeekMask {
  [self.tableView reloadData];
}

@end
