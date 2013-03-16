//
//  MOSettingsTableController.h
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MOSettingsTableRow {
  MOSettingsTableRowConnect,
  MOSettingsTableRowAllOn,
  MOSettingsTableRowAllOff,
  MOSettingsTableRowLightRed,
  MOSettingsTableRowPartay,
  MOSettingsTableRowAddTestSchedule,
  MOSettingsTableRowRemoveTestSchedule,
  MOSettingsTableRowGetSchedules,
  MOSettingsTableRowCount
} MOSettingsTableRow;

@interface MOSettingsTableController : UITableViewController {
  MOSettingsTableRow _rowMap[MOSettingsTableRowCount];
  int _rowCount;
}


@end
