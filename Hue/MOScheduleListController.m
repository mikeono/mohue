//
//  MOScheduleListController.m
//  Hue
//
//  Created by Mike Onorato on 4/6/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOScheduleListController.h"
#import "MOScheduleList.h"
#import "MOSchedule.h"
#import "MOScheduleEditController.h"
#import "MOScheduleListCell.h"
#import "MOCache.h"

@interface MOScheduleListController ()

@end

@implementation MOScheduleListController

- (id)init {
  if ( self = [super initWithStyle: UITableViewStylePlain] ) {
    // Init nav item
    self.navigationItem.title = @"Schedules";
    self.title = @"Schedules";
    
    // Init nav bar buttons
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target: self action: @selector(editButtonPressed)];
    self.navigationItem.leftBarButtonItem = editButton;
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear: animated];
  
  self.scheduleList = [MOCache sharedInstance].scheduleList;
}

#pragma mark - Getters and Setters

- (void)setScheduleList:(MOScheduleList *)scheduleList {
  _scheduleList = scheduleList;
  
  [self.tableView reloadData];
}

- (MOScheduleList*)scheduleList {
  if ( _scheduleList == nil ) {
    _scheduleList = [[MOScheduleList alloc] init];
  }
  return _scheduleList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.scheduleList.schedules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* CellIdentifier = @"Schedule_List_Cell";
  MOScheduleListCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
  if ( cell == nil ) {
    cell = [[MOScheduleListCell alloc] initWithReuseIdentifier: CellIdentifier];
  }
  
  cell.schedule = [self.scheduleList.schedules objectAtIndex: indexPath.row];
    
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MOSchedule* schedule = [self.scheduleList.schedules objectAtIndex: indexPath.row];
  [self pushScheduleEditControllerForSchedule: schedule];
}

#pragma mark - Event Handling

- (void)addButtonPressed {
  [self pushScheduleEditControllerForSchedule: nil];
}

- (void)editButtonPressed {

}

- (void)pushScheduleEditControllerForSchedule:(MOSchedule*)schedule {
  MOScheduleEditController* scheduleController = [[MOScheduleEditController alloc] initWithSchedule: schedule];
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: scheduleController];
  [self presentViewController: navController animated: YES completion: nil];
}

@end