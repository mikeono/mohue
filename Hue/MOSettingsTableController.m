//
//  MOSettingsTableController.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOSettingsTableController.h"
#import "MOHueService.h"

@interface MOSettingsTableController ()

@end

@implementation MOSettingsTableController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle: UITableViewStyleGrouped];
  if ( self ) {
    // Init nav item
    self.navigationItem.title = @"Settings";
    self.title = @"Settings";
    
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
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api" body: requestBody method: @"POST" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowAllOn:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"none", @"ct":@300, @"bri":@255};
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowAllOff:
    {
      NSDictionary* requestBody = @{@"on":@NO};
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
      
      DBG(@"requestbody %@", requestBody);
      break;
    }
    case MOSettingsTableRowLightRed:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"hue":@30};
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/lights/2/state" body: requestBody method: @"PUT" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowPartay:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"colorloop"};
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowAddTestSchedule:
    {
      
      NSDate* time = [NSDate dateWithTimeIntervalSinceNow: 30];
      
      // Format time
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
      NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
      [dateFormatter setTimeZone:gmt];
      [dateFormatter  setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
      NSString* timeString = [dateFormatter stringFromDate: time];
      
      NSDictionary* commandBody = @{@"hue":@30};
      NSDictionary* command = @{@"address":@"/api/1234567890/lights/2/state", @"method":@"PUT", @"body":commandBody};
      NSDictionary* requestBody = @{@"name":@"schedule-2-1", @"description":@"schedule-2-1", @"command": command, @"time": timeString};
      
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: requestBody method: @"POST" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowRemoveTestSchedule:
    {
      NSDictionary* requestBody = @{@"on":@YES, @"effect":@"colorloop"};
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: requestBody method: @"GET" userCompletionHandler: nil];
      break;
    }
    case MOSettingsTableRowGetSchedules:
    {
      [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/schedules" body: nil method: @"GET" userCompletionHandler: ^(NSURLResponse* response, id resultObject, NSError* error) {
        NSDictionary* schedulesDict;
        
      }];
      break;
    }
    default:
    {
      break;
    }
  }
}

@end
