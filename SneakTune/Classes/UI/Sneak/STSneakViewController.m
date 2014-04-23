//
//  STSneakViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakViewController.h"
#import "STSneakView.h"

@interface STSneakViewController ()

@property (nonatomic, readonly) STSneakView		*sneakView;

@end

@implementation STSneakViewController

- (id)initWithTrackModel:(STTrackModel *)trackModel {
	if (self = [super init]) {
		
	}
	return self;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_sneakView = [[STSneakView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_sneakView];
}

#pragma mark -

- (void)dealloc {
	[_sneakView release];
	[super dealloc];
}

@end
