//
//  STSneakSlideView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakSlideView.h"
#import "STSneakIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

CGFloat STSneakSlideViewHeight				= 30.0;
CGFloat STSneakSlideIndicatorViewHeight		= 15.0;

@interface STSneakSlideView () {
	UIView					*_grayView;
	STSneakIndicatorView	*_indicatorView;
}

@end

@implementation STSneakSlideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		
		_grayView = [[UIView alloc] initWithFrame:CGRectZero];
		_grayView.backgroundColor = [UIColor colorWithWhite:200.0 / 255.0 alpha:1.0];
		_grayView.layer.cornerRadius = STSneakIndicatorViewLineHeight * 0.5;
		[self addSubview:_grayView];
		
		_indicatorView = [[STSneakIndicatorView alloc] initWithFrame:CGRectZero];
		[_indicatorView addTarget:self action:@selector(draggingAction:event:) forControlEvents:UIControlEventTouchDragEnter | UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[self addSubview:_indicatorView];
		[_indicatorView setNeedsDisplay];
    }
    return self;
}

#pragma mark -

- (CGFloat)sliderWidth {
	return self.bounds.size.width;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat sliderWidth = [self sliderWidth];
	CGFloat indicatorWidth = floorf(sliderWidth * 0.33f);
	
	_grayView.frame = CGRectMake( 0.0, floorf(self.bounds.size.height * 0.5 - STSneakIndicatorViewLineHeight * 0.5f), sliderWidth, STSneakIndicatorViewLineHeight);
	_indicatorView.frame = CGRectMake(0.0, floorf(self.bounds.size.height * 0.5f - STSneakSlideIndicatorViewHeight * 0.5f), indicatorWidth, STSneakSlideIndicatorViewHeight);
	[_indicatorView setNeedsDisplay];
}

#pragma mark -

- (void)draggingAction:(UIControl *)sender event:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	CGPoint point2 = [touch previousLocationInView:self];
	
	CGRect frame = _indicatorView.frame;
	frame.origin.x -= (point2.x - point.x);
	if (frame.origin.x < 0) {
		frame.origin.x = 0;
	}
	if (frame.origin.x > [self sliderWidth] - frame.size.width) {
		frame.origin.x = [self sliderWidth] - frame.size.width;
	}
	_indicatorView.frame = frame;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -

- (void)dealloc {
	[_indicatorView release];
	[super dealloc];
}

@end
