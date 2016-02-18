//
//  MWAppDelegate.m
//  me2wave
//
//  Created by kgn on 12. 11. 1..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWAppDelegate.h"
#import "MWViewController.h"

@implementation MWAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MWViewController *controller = [[MWViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"me2wave-titlebar.png"] forBarMetrics:UIBarMetricsDefault];
    navController.navigationBar.tintColor = [UIColor colorWithRed:90.0/255 green:50.0/255 blue:180.0/255 alpha:0];
    
   // UIBarButtonItem *left = [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:<#(id)#> action:<#(SEL)#>
    [self.window setRootViewController:navController];
    [self.window addSubview:navController.view];
    [controller release];
    [navController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
