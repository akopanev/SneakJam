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
	
	// remove separator
	[[UINavigationBar appearance] setShadowImage:[[[UIImage alloc] init] autorelease]];
	[[UINavigationBar appearance] setBackgroundImage:[[[UIImage alloc] init] autorelease] forBarMetrics:UIBarMetricsDefault];
	// change default font and color
	NSDictionary *buttonItemTextTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
	[[UIBarButtonItem appearance] setTitleTextAttributes:buttonItemTextTitleOptions forState:UIControlStateNormal];
	NSDictionary *buttonDisabledItemTextTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17.0f], NSFontAttributeName, nil];
	[[UIBarButtonItem appearance] setTitleTextAttributes:buttonDisabledItemTextTitleOptions forState:UIControlStateDisabled];
		
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:[[[STSearchViewController alloc] init] autorelease]] autorelease];
	navigationController.navigationBar.tintColor = [UIColor grayColor];
	navigationController.navigationBar.translucent = NO;
	self.window.rootViewController = navigationController;
    return YES;
}

@end
