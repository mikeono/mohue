//
//  MOSettingsTableController.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOSettingsTableController.h"
#import "MOHueServiceManager.h"
#import "MOHueScheduleService.h"

@interface MOSettingsTableController ()

@end

@implementation MOSettingsTableController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle: UITableViewStyleGrouped];
  if ( self ) {
    // Init nav item
    self.navigationItem.title = @"Settings";
    self.title = @"Settings";
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Init nav bar buttons
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStylePlain target: self action: @selector(doneButtonPressed)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    // Init table row map
    _rowMap[_rowCount++] = MOSettingsTableRowConnect;
    _rowMap[_rowCount++] = MOSettingsTableRowAllOn;
    _rowMap[_rowCount++] = MOSettingsTableRowAllOff;
    _rowMap[_rowCount++] = MOSettingsTableRowLightRed;
    _rowMap[_rowCount++] = MOSettingsTableRowPartay;
    _rowMap[_rowCount++] = MOSettingsTableRowAddTestSchedule;
    _rowMap[_rowCount++] = MOSettingsTableRowRemoveTestSchedule;
    _rowMap[_rowCount++] = MOSettingsTableRowGetSchedules;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return MOSettingsTableRowCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"SettingsCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if ( ! cell ) {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  
  // Configure the cell
  switch ( _rowMap[indexPath.section] ) {
    case MOSettingsTableRowConnect:
      cell.textLabel.text = @"Connect";
      break;
    case MOSettingsTableRowAllOn:
      cell.textLabel.text = @"Lights On";
      break;
    case MOSettingsTableRowAllOff:
      cell.textLabel.text = @"Lights Off";
      break;
    case MOSettingsTableRowLightRed:
      cell.textLabel.text = @"Light Red";
      break;
    case MOSettingsTableRowPartay:
      cell.textLabel.text = @"Partay";
      break;
    case MOSettingsTableRowAddTestSchedule:
      cell.textLabel.text = @"Add Test Schedule";
      break;
    case MOSettingsTableRowRemoveTestSchedule:
      cell.textLabel.text = @"Remove Test Schedule";
      break;
    case MOSettingsTableRowGetSchedules:
      cell.textLabel.text = @"Get Schedules";
      break;
    default:
      break;
  }
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
  
  switch ( _rowMap[indexPath.section] ) {
    case MOSettingsTableRowConnect:
    {
      NSDictionary* requestBody = @{@"devicetype":@"iPhone", @"username":@"1234567890"};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api" body: requestBody method: @"POST" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowAllOn:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"none", @"ct":@300, @"bri":@255};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowAllOff:
    {
      NSDictionary* requestBody = @{@"on":@NO};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" completionHandler: nil];
      
      DBG(@"requestbody %@", requestBody);
      break;
    }
    case MOSettingsTableRowLightRed:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"hue":@30};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowPartay:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"colorloop"};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowAddTestSchedule:
    {
      
      NSDate* time = [NSDate dateWithTimeIntervalSinceNow: 10];
      
      // Format time
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
      NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
      [dateFormatter setTimeZone:gmt];
      [dateFormatter  setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
      NSString* timeString = [dateFormatter stringFromDate: time];
      
      NSDictionary* commandBody = @{@"hue":@30};
      NSDictionary* command = @{@"address":@"/api/1234567890/lights/1/state", @"method":@"PUT", @"body":commandBody};
      NSDictionary* requestBody = @{@"name":@"schedule-2-1", @"description":@"schedule-2-1", @"command": command, @"time": timeString};
      
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: requestBody method: @"POST" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowRemoveTestSchedule:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"colorloop"};
      [[MOHueServiceManager sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: requestBody method: @"GET" completionHandler: nil];
      break;
    }
    case MOSettingsTableRowGetSchedules:
    {
      [MOHueScheduleService getAllSchedules];
      break;
    }
    default:
    {
      break;
    }
  }
}

- (void)doneButtonPressed {
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

@end
