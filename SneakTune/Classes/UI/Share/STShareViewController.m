//
//  STShareViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STShareViewController.h"
#import "STShareView.h"
#import "STAPIEngine.h"

NSString *const STShareViewControllerShareNotification		= @"share";

const NSInteger STShareViewControllerErrorAlertViewTag		= 1;

@interface STShareViewController () <UIAlertViewDelegate> {
	STShareView		*_shareView;
}

@property (nonatomic, retain) NSDictionary		*trackInfo;
@property (nonatomic, retain) NSArray			*selectedUsers;
@property (nonatomic, retain) NSString			*shareURL;

@end

@implementation STShareViewController

#pragma mark - helpers

- (NSString *)notificationName:(NSString *)notf {
	return [NSString stringWithFormat:@"%p_%@", self, notf];
}

#pragma mark - notifications

- (void)didShareNotification:(NSNotification *)notification {
	NSError *error = NTF_ERROR(notification);
	if (nil == error) {
		_shareView.inWaitingMode = NO;		
		self.shareURL = NTF_RESULT(notification);
	} else {
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"Ooops! Can't share right now. Would you like to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
		alertView.tag = STShareViewControllerErrorAlertViewTag;
		[alertView show];
	}
}

#pragma mark - requests

- (void)requestShare {
	[[STAPIEngine defaultEngine] apiShareTrackInfo:self.trackInfo friends:self.selectedUsers notificationName:[self notificationName:STShareViewControllerShareNotification]];
}

#pragma mark -

- (id)initWithTrackInfo:(NSDictionary *)trackInfo selectedUsers:(NSArray *)selectedUsers {
	if (self = [super init]) {
		self.trackInfo = trackInfo;
		self.selectedUsers = selectedUsers;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShareNotification:) name:[self notificationName:STShareViewControllerShareNotification] object:nil];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sneakjam_logo.png"]];
	self.navigationItem.titleView = imageView;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	_shareView = [[STShareView alloc] initWithFrame:self.view.bounds];
	[_shareView.viewURLButton addTarget:self action:@selector(viewShareAction) forControlEvents:UIControlEventTouchUpInside];
	[_shareView.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_shareView];
	
	_shareView.inWaitingMode = YES;
	[self requestShare];
}

#pragma mark - actions

- (void)viewShareAction {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.shareURL]];
}

- (void)doneAction {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDleegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (STShareViewControllerErrorAlertViewTag == alertView.tag) {
		if (buttonIndex == alertView.cancelButtonIndex) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self requestShare];
		}
	}
}

#pragma mark -

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_trackInfo release];
	[_selectedUsers release];
	[_shareView release];
	[_shareURL release];
	[super dealloc];
}

@end
