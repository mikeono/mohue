//
//  MOAppDelegate.m
//  Hue
//
//  Created by Mike Onorato on 3/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOAppDelegate.h"
#import "MOSettingsTableController.h"
#import "MOScheduleListController.h"
#import "MOStyles.h"
#import "MOHueBridgeFinder.h"
#import "MOUIUtil.h"

BOOL iPad;
BOOL iPhone;
BOOL iPhone4Inch;

@implementation MOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [MOStyles applyStylesToAppearance];
  
  iPad = [MOUIUtil sharedInstance].iPad;
  iPhone = !iPad;
  iPhone4Inch = [MOUIUtil sharedInstance].iPhone4Inch;
  
  // Override point for customization after application launch.
  MOScheduleListController* scheduleListController = [[MOScheduleListController alloc] init];
  _navController = [[UINavigationController alloc] initWithRootViewController: scheduleListController];
  self.window.rootViewController = _navController;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  [[MOAlertManager sharedInstance] clearState];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  [[MOHueBridgeFinder sharedInstance] updateBridgeStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
