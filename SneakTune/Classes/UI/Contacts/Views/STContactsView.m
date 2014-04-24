//
//  STContactsView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactsView.h"

@implementation STContactsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	_tableView.frame = self.bounds;
}

#pragma mark -

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}

@end
