//
//  STShareView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STShareView.h"

@interface STShareView () {
	UILabel		*_progressLabel;
	UILabel		*_noteLabel;
}

@end

@implementation STShareView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor whiteColor];
		
		_viewURLButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[_viewURLButton setTitle:@"View Share" forState:UIControlStateNormal];

		_doneButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[_doneButton setTitle:@"New Share" forState:UIControlStateNormal];
		
		_progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_progressLabel.textAlignment = NSTextAlignmentCenter;
		_progressLabel.text = @"Sharing...";
		_progressLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
		[self addSubview:_progressLabel];
		
		_noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_noteLabel.textAlignment = NSTextAlignmentCenter;
		_noteLabel.text = @"Yeah!\nYour friends will hear your tune now!";
		_noteLabel.numberOfLines = 0;
		_noteLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
		[self addSubview:_noteLabel];
    }
    return self;
}

#pragma mark -

- (void)setInWaitingMode:(BOOL)inWaitingMode {
	_inWaitingMode = inWaitingMode;
	if (_inWaitingMode) {
		[self addSubview:_progressLabel];
		[_viewURLButton removeFromSuperview];
		[_doneButton removeFromSuperview];
		[_noteLabel removeFromSuperview];
	} else {
		[_progressLabel removeFromSuperview];
		[self addSubview:_viewURLButton];
		[self addSubview:_doneButton];
		[self addSubview:_noteLabel];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_progressLabel.frame = self.bounds;
	
	CGFloat noteY = 80.0;
	CGFloat noteHeight = 60.0;
	_noteLabel.frame = CGRectMake(0.0, noteY, self.bounds.size.width, noteHeight);
	
	CGFloat buttonsHeight = 30.0;
	_viewURLButton.frame = CGRectMake(0.0, CGRectGetMaxY(_noteLabel.frame) + 50, self.bounds.size.width, buttonsHeight);
	_doneButton.frame = CGRectMake(0.0, CGRectGetMaxY(_viewURLButton.frame) + 5.0, self.bounds.size.width, buttonsHeight);
}

#pragma mark -

- (void)dealloc {
	[_viewURLButton release];
	[_doneButton release];
	[super dealloc];
}

@end
