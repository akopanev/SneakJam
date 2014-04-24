//
//  STContactContentView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactContentView.h"

const CGFloat STContactContentViewHeight			= 50.0;

@interface STContactContentView () {
	UIView			*_grayCoverView;
	UIImageView		*_contactImageView;
	UILabel			*_contactNameLabel;
	UIImageView		*_checkmarkImageView;
}

@end

@implementation STContactContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_grayCoverView = [[UIView alloc] initWithFrame:CGRectZero];
		_grayCoverView.backgroundColor = [UIColor colorWithWhite:227.0 / 255.0 alpha:1.0];
		[self addSubview:_grayCoverView];
		
		_contactImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_contactImageView];
		
		_contactNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_contactNameLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
		[self addSubview:_contactNameLabel];
		
		_checkmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unchecked.png"]];
		[self addSubview:_checkmarkImageView];
    }
    return self;
}

#pragma mark -

- (void)setContact:(APContact *)contact {
	if (_contact != contact) {
		[_contact autorelease];
		_contact = [contact retain];
	}
	
	NSString *fullName = [_contact fullName];
	if (!fullName.length) {
		fullName = [_contact.emails firstObject];
	}
	if (!fullName.length) {
		fullName = @"";
	}
	
	// holy....
	NSData  *imgData = (NSData *)ABPersonCopyImageData(contact.recordRef);
	UIImage  *img = [UIImage imageWithData:imgData];
	_contactImageView.image = img;
	_contactNameLabel.text = fullName;
	
	_checkmarkImageView.image = [UIImage imageNamed: _contact.isSelected ? @"icon_check.png" : @"icon_unchecked.png"];
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat offset = 4.0;
	_contactImageView.frame = CGRectMake(offset, 0.0, STContactContentViewHeight, STContactContentViewHeight);
	_grayCoverView.frame = _contactImageView.frame;
	
	_checkmarkImageView.frame = CGRectMake( self.bounds.size.width - _checkmarkImageView.bounds.size.width - offset * 2.0, floor(self.bounds.size.height * 0.5f - _checkmarkImageView.bounds.size.height * 0.5f), _checkmarkImageView.bounds.size.width, _checkmarkImageView.bounds.size.height);
	
	CGFloat labelsX = CGRectGetMaxX(_contactImageView.frame) + offset * 2.0;
	CGFloat labelsWidth = CGRectGetMinX(_checkmarkImageView.frame) - CGRectGetMaxX(_contactImageView.frame) - offset * 4.0;
	_contactNameLabel.frame = CGRectMake(labelsX, 0.0, labelsWidth, self.bounds.size.height);
}

#pragma mark -

- (void)dealloc {
	[_contact release];
	[_contactImageView release];
	[_contactNameLabel release];
	[_checkmarkImageView release];
	[super dealloc];
}

@end
