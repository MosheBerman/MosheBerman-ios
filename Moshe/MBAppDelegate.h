//
//  MBAppDelegate.h
//  Moshe
//
//  Created by Moshe Berman on 4/25/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;

@class MBViewController;

@interface MBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MBViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
