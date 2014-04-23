//
//  STTrackContentView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STTrackContentView.h"
#import "UIImageView+AFNetworking.h"

const CGFloat STTrackContentViewHeight			= 50.0;

@interface STTrackContentView () {
	UILabel		*_trackTitleLabel;
	UILabel		*_artistNameLabel;
	UIImageView	*_coverImageView;
	UIView		*_grayCoverView;
}
@end

@implementation STTrackContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_grayCoverView = [[UIView alloc] initWithFrame:CGRectZero];
		_grayCoverView.backgroundColor = [UIColor colorWithWhite:227.0 / 255.0 alpha:1.0];
		[self addSubview:_grayCoverView];
		
		_coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_coverImageView];
		
		_trackTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_trackTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0];
		[self addSubview:_trackTitleLabel];
		
		_artistNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_artistNameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
		[self addSubview:_artistNameLabel];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat offset = 4.0;
	CGFloat offsetY = -1.0;
	_coverImageView.frame = CGRectMake(offset, 0.0, STTrackContentViewHeight, STTrackContentViewHeight);
	_grayCoverView.frame = _coverImageView.frame;
	
	CGFloat labelsX = CGRectGetMaxX(_coverImageView.frame) + offset;
	CGFloat labelsWidth = self.bounds.size.width - CGRectGetMaxX(_coverImageView.frame) - offset * 2.0;
	_trackTitleLabel.frame = CGRectMake(labelsX, floorf(self.bounds.size.height * 0.5f - _trackTitleLabel.font.lineHeight - offsetY), labelsWidth, _trackTitleLabel.font.lineHeight);
	_artistNameLabel.frame = CGRectMake(labelsX, floorf(self.bounds.size.height * 0.5f + offsetY), labelsWidth, _artistNameLabel.font.lineHeight);
}

#pragma mark -

- (void)setTrackModel:(STTrackModel *)trackModel {
	if (_trackModel != trackModel) {
		[_trackModel autorelease];
		_trackModel = [trackModel retain];
		
		_trackTitleLabel.text = trackModel.name ? trackModel.name : @"";
		_artistNameLabel.text = trackModel.artistName ? trackModel.artistName : @"";
	}
}

- (void)setAlbumCoverImageURLString:(NSString *)albumCoverImageURLString {
	///if (albumCoverImageURLString != _albumCoverImageURLString) {
	if (NO == [albumCoverImageURLString isEqualToString:_albumCoverImageURLString]) {
		[_albumCoverImageURLString release];
		_albumCoverImageURLString = [albumCoverImageURLString retain];
		
		if (nil != albumCoverImageURLString) {
			
			[_coverImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:albumCoverImageURLString]]
								   placeholderImage:nil
											success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
												_coverImageView.alpha = 0.0;
												_coverImageView.image = image;
												[UIView animateWithDuration:0.25 animations:^{
													_coverImageView.alpha = 1.0;
												}];
											}
											failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
											}];
		} else {
			_coverImageView.image = nil;
		}
	}
}

#pragma mark -

- (void)dealloc {
	[_trackModel release];
	[_trackTitleLabel release];
	[_artistNameLabel release];
	[_coverImageView release];
	[_albumCoverImageURLString release];
	[super dealloc];
}

@end
