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

@interface STSearchView () <TPKeyboardAvoidingTableViewDelegate> {
	UIImageView			*_glassIconView;
}

@end

@implementation STSearchView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor whiteColor];
		
		_glassIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_find.png"]];
		[self addSubview:_glassIconView];
		
		_searchField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, STSearchViewSearchFieldHeight)];
		_searchField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
		_searchField.placeholder = @"Search by song";
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
	
	CGFloat statusBarOffset = 0.0; // 20.0f; //[[UIApplication sharedApplication] statusBarFrame].size.height;
	_glassIconView.frame = CGRectMake(searchFieldHorizontalMArgin, floorf(STSearchViewSearchFieldHeight * 0.5 - _glassIconView.image.size.height * 0.5), _glassIconView.image.size.width, _glassIconView.image.size.width);
	
	CGFloat searchWidth = self.bounds.size.width - searchFieldHorizontalMArgin - CGRectGetMaxX(_glassIconView.frame) - searchFieldHorizontalMArgin;
	_searchField.frame = CGRectMake(CGRectGetMaxX(_glassIconView.frame) + searchFieldHorizontalMArgin, statusBarOffset, searchWidth, STSearchViewSearchFieldHeight);
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
	[_glassIconView release];
	[super dealloc];
}

@end
