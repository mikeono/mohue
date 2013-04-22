//
//  MOSettingsTableController.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOSettingsTableController.h"
#import "MOHueServiceManager.h"
#import "MOScheduleService.h"
#import "MOHueBridgeFinder.h"
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
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Init nav bar buttons
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStylePlain target: self action: @selector(doneButtonPressed)];
    self.navigationItem.leftBarButtonItem = doneButton;
    
    // Init table row map
    _rowMap[_rowCount++] = MOSettingsTableRowConnect;
    
    // Event handling
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bridgeStatusChanged) name:kMOHueBridgeFinderStatusChangeNotification object: nil];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch ( _rowMap[section] ) {
    case MOSettingsTableRowConnect:
      if ( [MOHueBridgeFinder sharedInstance].bridgeStatus == MOHueBridgeStatusAuthed ) {
        return [NSString stringWithFormat: @"Connected to bridge at %@", [MOHueService sharedInstance].serverName];
      } else {
        return @"Not Connected";
      }
      break;
    default:
    {
      return @"";
    }
  }
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
      if ( [MOHueBridgeFinder sharedInstance].bridgeStatus == MOHueBridgeStatusAuthed ) {
        cell.textLabel.text = @"Find a New Bridge";
      } else if ( [MOHueBridgeFinder sharedInstance].bridgeStatus == MOHueBridgeStatusUpdating ) {
        cell.textLabel.text = @"Searching...";
      } else {
        cell.textLabel.text = @"Connect to Bridge";
      }
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
      [[MOHueBridgeFinder sharedInstance] reconnect];
      break;
    }
    default:
    {
      break;
    }
  }
}

#pragma mark - Event handling

- (void)doneButtonPressed {
  [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)bridgeStatusChanged{
  [self.tableView reloadData];
}

@end
