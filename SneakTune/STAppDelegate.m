//
//  STAppDelegate.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STAppDelegate.h"
#import "STSearchViewController.h"
#import "STSneakViewController.h"

@implementation STAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:[[[STSearchViewController alloc] init] autorelease]] autorelease];
	navigationController.interactivePopGestureRecognizer.enabled = YES;
//	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:[[[STSneakViewController alloc] init] autorelease]] autorelease];
	navigationController.navigationBarHidden = YES;
	self.window.rootViewController = navigationController;
    return YES;
}

@end
