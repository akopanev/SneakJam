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
	UILabel		*_loadingLabel;
}

@end

@implementation STSneakView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
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
		
		_loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_loadingLabel.alpha = 1.0;
		_loadingLabel.textAlignment = NSTextAlignmentCenter;
		_loadingLabel.text = @"Loading...";
		_loadingLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
		[self addSubview:_loadingLabel];
		
		_playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_playButton.alpha = 0.0;
		[_playButton setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
		[self addSubview:_playButton];
    }
    return self;
}

#pragma mark -

- (void)setPlayButtonIsPlayButton:(BOOL)playButtonIsPlayButton {
	_playButtonIsPlayButton = playButtonIsPlayButton;
	if (YES == _playButtonIsPlayButton) {
		[_playButton setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
	} else {
		[_playButton setImage:[UIImage imageNamed:@"icon_pause.png"] forState:UIControlStateNormal];
	}
}

- (void)setShowsLoadingLabel:(BOOL)showsLoadingLabel {
	_showsLoadingLabel = showsLoadingLabel;
	if (YES == showsLoadingLabel) {
		
		
		[UIView animateWithDuration:0.15 animations:^{
			_slideView.alpha = 0.0;
			_loadingLabel.alpha = 1.0;
		}];
	} else {
		[UIView animateWithDuration:0.15 animations:^{
			_slideView.alpha = 1.0;
			_loadingLabel.alpha = 0.0;
		}];
	}
}

- (void)setShowsPlayButton:(BOOL)showsPlayButton {
	_showsPlayButton = showsPlayButton;
	if (YES == _showsPlayButton) {
		[UIView animateWithDuration:0.25 animations:^{
			_playButton.alpha = 1.0;
		}];
	} else {
		[UIView animateWithDuration:0.15 animations:^{
			_playButton.alpha = 0.0;
		}];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat statusBarOffset = 0.0; // 20.0;
	
	const CGFloat verticalMargin = 15.0;
	const CGFloat horizontalMargin = 15.0;
	
	CGFloat coverSize = self.bounds.size.width - horizontalMargin * 2.0;
	_coverImageView.frame = CGRectMake(horizontalMargin, verticalMargin + statusBarOffset, coverSize, coverSize);
	_grayCoverView.frame = _coverImageView.frame;
	_playButton.frame = _coverImageView.frame;
	
	_trackTitleLabel.frame = CGRectMake(horizontalMargin, CGRectGetMaxY(_coverImageView.frame) + verticalMargin + 10.0, self.bounds.size.width - horizontalMargin * 2.0, _trackTitleLabel.font.lineHeight);
	_artistNameLabel.frame = CGRectMake(horizontalMargin, CGRectGetMaxY(_trackTitleLabel.frame), self.bounds.size.width - horizontalMargin * 2.0, _artistNameLabel.font.lineHeight);
	
	CGFloat remainingHeight = self.bounds.size.height - CGRectGetMaxY(_artistNameLabel.frame) - verticalMargin;
	const CGFloat slideWidth = 250.0;
	_slideView.frame = CGRectMake(floorf(self.bounds.size.width * 0.5f - slideWidth * 0.5f), floorf(CGRectGetMaxY(_artistNameLabel.frame) + remainingHeight * 0.5f - STSneakSlideViewHeight * 0.5), slideWidth, STSneakSlideViewHeight);
	_loadingLabel.frame = CGRectMake( horizontalMargin, CGRectGetMaxY(_artistNameLabel.frame), self.bounds.size.width - horizontalMargin * 2.0, remainingHeight);
}

#pragma mark -

- (void)dealloc {
	[_grayCoverView release];
	[_coverImageView release];
	[_slideView release];
	[_trackTitleLabel release];
	[_artistNameLabel release];
	[_loadingLabel release];
	[_playButton release];
	[super dealloc];
}

@end
