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
#import "MOScheduleService.h"
#import "MOSettingsTableController.h"
#import "MOStyles.h"
#import "MOScheduleOccurrenceService.h"
#import "MOHueBridgeFinder.h"

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
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle: @"Edit" style:UIBarButtonItemStyleBordered target: self action: @selector(editButtonPressed)];
    editButton.possibleTitles = [NSSet setWithObjects: @"Edit", @"Done", nil];
    self.navigationItem.leftBarButtonItem = editButton;
    
    // Init refresh control
    if ( NO && [self respondsToSelector: @selector(setRefreshControl:)] ) {
      UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
      refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString: @"Pull to Sync With Hue"];
      [refreshControl addTarget: self action: @selector(refreshControlValueChanged) forControlEvents: UIControlEventValueChanged];
      [self setRefreshControl: refreshControl];
    }
    
    // Init event handling
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedScheduleFromHue) name: kMOReceivedScheduleFromHue object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bridgeStatusChanged) name:kMOHueBridgeFinderStatusChangeNotification object: nil];
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [MOStyles brownDark];
  
  // Configure bottom toolbar
  self.navigationController.toolbarHidden = NO;
  UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle: @"\u2699" style: UIBarButtonItemStylePlain target: self action: @selector(settingsButtonPressed)];
  
  UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil];
  [settingsButton setTitleTextAttributes: dict forState: UIControlStateNormal];
  
  self.toolbarItems = @[flexibleSpace, settingsButton];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear: animated];
  
  // Reload schedules into table from cache
  self.scheduleList = [MOCache sharedInstance].scheduleList;
  
  // Sync schedules down from server
  [MOScheduleService syncDownSchedules];
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

#pragma mark - Table view editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    MOSchedule* schedule = [self.scheduleList.schedules objectAtIndex: indexPath.row];
  
    // Send delete request to server
    [MOScheduleOccurrenceService deleteAllOccurrencesOfUUID: schedule.UUID withCompletion: ^(BOOL success) {
      if ( success ) {
        [[[MOCache sharedInstance] scheduleList] removeScheduleWithUUID: schedule.UUID];
        [tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
      } else {
        NSString* message = @"The schedule couldn't be deleted at this time.";
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
        [alertView show];
      }
      [MOScheduleService syncDownSchedules];
    }];
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MOSchedule* schedule = [self.scheduleList.schedules objectAtIndex: indexPath.row];
  [self pushScheduleEditControllerForSchedule: schedule];
}

#pragma mark - Event Handling

- (void)receivedScheduleFromHue {
  self.scheduleList = [MOCache sharedInstance].scheduleList;
}

- (void)bridgeStatusChanged {
  if ( [MOHueBridgeFinder sharedInstance].bridgeStatus == MOHueBridgeStatusAuthed ) {
    [MOScheduleService syncDownSchedules];
  }
}

- (void)addButtonPressed {
  [self pushScheduleEditControllerForSchedule: nil];
}

- (void)editButtonPressed {
  [self.tableView setEditing: ! self.tableView.editing animated: YES];
  self.navigationItem.leftBarButtonItem.title = self.tableView.editing ? @"Done" : @"Edit";
}

- (void)pushScheduleEditControllerForSchedule:(MOSchedule*)schedule {
  MOScheduleEditController* scheduleController = [[MOScheduleEditController alloc] initWithSchedule: schedule];
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: scheduleController];
  [self presentViewController: navController animated: YES completion: nil];
}

- (void)settingsButtonPressed {
  MOSettingsTableController* settingsController = [[MOSettingsTableController alloc] init];
  UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: settingsController];
  [self presentViewController: navController animated: YES completion: nil];
}



@end
