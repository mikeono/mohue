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
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  DBG(@"Oh haai");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
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
  switch ( indexPath.section ) {
    case 0:
      cell.textLabel.text = @"Connect";
      break;
    case 1:
      cell.textLabel.text = @"Lights On";
      break;
    case 2:
      cell.textLabel.text = @"Lights Off";
      break;
    case 3:
      cell.textLabel.text = @"Partay";
      break;
    default:
      break;
  }
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
  
  if ( indexPath.section == 0 ) {
    NSDictionary* requestBody = @{@"devicetype":@"iPhone", @"username":@"1234567890"};
    [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api" body: requestBody method: @"POST" userCompletionHandler: nil];
  } else if ( indexPath.section == 1 ) {
    NSDictionary* requestBody = @{@"on":@YES, @"effect":@"none"};
    [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
  } else if ( indexPath.section == 2 ) {
    NSDictionary* requestBody = @{@"on":@NO};
    [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
  } else if ( indexPath.section == 3 ) {
    NSDictionary* requestBody = @{@"on":@YES, @"effect":@"colorloop"};
    [[MOHueService sharedInstance] startAsyncRequestWithPath: @"api/1234567890/groups/0/action" body: requestBody method: @"PUT" userCompletionHandler: nil];
  }
}

@end
