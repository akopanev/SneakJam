//
//  STSearchView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSearchView.h"
#import "TPKeyboardAvoidingTableView.h"

const CGFloat STSearchViewSearchFieldHeight		= 40.0;

@interface STSearchView () <TPKeyboardAvoidingTableViewDelegate>

@end

@implementation STSearchView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor whiteColor];
		
		_searchField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, STSearchViewSearchFieldHeight)];
		_searchField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
		_searchField.placeholder = @"Search";
		_searchField.backgroundColor = [UIColor whiteColor];
		_searchField.returnKeyType = UIReturnKeySearch;
		[self addSubview:_searchField];
		
		_tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero];
		_tableView.backgroundColor = [UIColor whiteColor];
		((TPKeyboardAvoidingTableView *)_tableView).avoidingDelegate = self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat horizontalMargin = 4.0;
	const CGFloat searchFieldHorizontalMArgin = 4.0f + 4.0f;
	
	CGFloat statusBarOffset = 20.0f; //[[UIApplication sharedApplication] statusBarFrame].size.height;
	_searchField.frame = CGRectMake(searchFieldHorizontalMArgin, statusBarOffset, self.bounds.size.width - searchFieldHorizontalMArgin * 2.0, STSearchViewSearchFieldHeight);
	_tableView.frame = CGRectMake(horizontalMargin, CGRectGetMaxY(_searchField.frame), self.bounds.size.width - horizontalMargin * 2.0, self.bounds.size.height - CGRectGetMaxY(_searchField.frame));
}

#pragma mark - TPKeyboardAvoidingTableViewDelegate

- (UIView *)viewToSearchForFirstResponder:(TPKeyboardAvoidingTableView *)tableView {
	return self;
}

#pragma mark -

- (void)dealloc {
	[_searchField release];
	[_tableView release];
	[super dealloc];
}

@end
