//
//  STContactsView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactsView.h"
#import "TPKeyboardAvoidingTableView.h"

const CGFloat STContactsViewSearchFieldHeight		= 40.0;

@interface STContactsView () {
	UIImageView			*_glassIconView;
}

@end

@implementation STContactsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, STContactsViewSearchFieldHeight)];
		_glassIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_find.png"]];
		[headerView addSubview:_glassIconView];
		
		_searchField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, STContactsViewSearchFieldHeight)];
		_searchField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
		_searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_searchField.placeholder = @"Search contacts";
		_searchField.backgroundColor = [UIColor whiteColor];
		_searchField.returnKeyType = UIReturnKeySearch;
		[headerView addSubview:_searchField];
		
		_tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.tableHeaderView = headerView;
		[self addSubview:_tableView];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	_tableView.tableHeaderView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, STContactsViewSearchFieldHeight);
	_tableView.frame = self.bounds;
	
	const CGFloat searchFieldHorizontalMArgin = 4.0f + 4.0f;
	
	CGFloat statusBarOffset = 0.0; // 20.0f; //[[UIApplication sharedApplication] statusBarFrame].size.height;
	_glassIconView.frame = CGRectMake(searchFieldHorizontalMArgin, floorf(STContactsViewSearchFieldHeight * 0.5 - _glassIconView.image.size.height * 0.5), _glassIconView.image.size.width, _glassIconView.image.size.width);
	
	CGFloat searchWidth = self.bounds.size.width - searchFieldHorizontalMArgin - CGRectGetMaxX(_glassIconView.frame) - searchFieldHorizontalMArgin;
	_searchField.frame = CGRectMake(CGRectGetMaxX(_glassIconView.frame) + searchFieldHorizontalMArgin, statusBarOffset, searchWidth, STContactsViewSearchFieldHeight);
	
}

#pragma mark -

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}

@end
