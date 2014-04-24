//
//  STContactsViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactsViewController.h"
#import "STContactsView.h"

@interface STContactsViewController () {
	STContactsView		*_contactsView;
}

@end

@implementation STContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sneakjam_logo.png"]];
	self.navigationItem.titleView = imageView;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	_contactsView = [[STContactsView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_contactsView];
}

#pragma mark -

- (void)dealloc {
	[_contactsView release];
	[super dealloc];
}

@end
