//
//  STSneakView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakView.h"
#import "STSneakIndicatorView.h"

@interface STSneakView () {
	UIView		*_grayCoverView;
}

@end

@implementation STSneakView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		
		_grayCoverView = [[UIView alloc] initWithFrame:CGRectZero];
		_grayCoverView.backgroundColor = [UIColor colorWithWhite:227.0 / 255.0 alpha:1.0];
		[self addSubview:_grayCoverView];		
		
		_coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_coverImageView];
		
		_slideView = [[STSneakSlideView alloc] initWithFrame:CGRectZero];
		[self addSubview:_slideView];
		
		_trackTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_trackTitleLabel.textAlignment = NSTextAlignmentCenter;
		_trackTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0];
		[self addSubview:_trackTitleLabel];
		
		_artistNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_artistNameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
		_artistNameLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_artistNameLabel];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat statusBarOffset = 20.0;
	
	const CGFloat verticalMargin = 15.0;
	const CGFloat horizontalMargin = 15.0;
	
	CGFloat coverSize = self.bounds.size.width - horizontalMargin * 2.0;
	_coverImageView.frame = CGRectMake(horizontalMargin, verticalMargin + statusBarOffset, coverSize, coverSize);
	_grayCoverView.frame = _coverImageView.frame;
	
	_trackTitleLabel.frame = CGRectMake(horizontalMargin, CGRectGetMaxY(_coverImageView.frame) + verticalMargin, self.bounds.size.width - horizontalMargin * 2.0, _trackTitleLabel.font.lineHeight);
	_artistNameLabel.frame = CGRectMake(horizontalMargin, CGRectGetMaxY(_trackTitleLabel.frame), self.bounds.size.width - horizontalMargin * 2.0, _artistNameLabel.font.lineHeight);
	
	const CGFloat slideWidth = 250.0;
//	_slideView.frame = CGRectMake(floorf(self.bounds.size.width * 0.5f - slideWidth * 0.5f), 200.0, slideWidth, STSneakSlideViewHeight);
}

#pragma mark -

- (void)dealloc {
	[_grayCoverView release];
	[_coverImageView release];
	[_slideView release];
	[_trackTitleLabel release];
	[_artistNameLabel release];
	[super dealloc];
}

@end
