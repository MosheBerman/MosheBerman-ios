//
//  MBAppDelegate.m
//  Moshe
//
//  Created by Moshe Berman on 4/25/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBAppDelegate.h"

#import "MBViewController.h"

@interface MBAppDelegate ()

/**
 *  The root view controller.
 */
@property (strong, nonatomic) MBViewController *viewController;

/**
 *  The root navigation controller.
 */

@property (strong, nonatomic) UINavigationController *navigationController;

@end
@implementation MBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIColor *tint = [UIColor colorWithRed:0.73 green:0.00 blue:0.07 alpha:1.00];
    [[UIView appearance] setTintColor:tint];


    self.viewController = [[MBViewController alloc] initWithNibName:@"MBViewController" bundle:nil];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:[self viewController]];
    
    self.window.rootViewController = [self navigationController];
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
