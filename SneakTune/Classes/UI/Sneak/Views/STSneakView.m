//
//  STSneakView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakView.h"
#import "STSneakIndicatorView.h"
#import "UIImageView+AFNetworking.h"

@interface STSneakView () {
	UIImageView		*_coverImageView;
}

@end

@implementation STSneakView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_slideView = [[STSneakSlideView alloc] initWithFrame:CGRectZero];
		[self addSubview:_slideView];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat slideWidth = 250.0;
	_slideView.frame = CGRectMake(floorf(self.bounds.size.width * 0.5f - slideWidth * 0.5f), 200.0, slideWidth, STSneakSlideViewHeight);
}

#pragma mark -

- (void)dealloc {
	[_coverImageView release];
	[_slideView release];
	[super dealloc];
}

@end
