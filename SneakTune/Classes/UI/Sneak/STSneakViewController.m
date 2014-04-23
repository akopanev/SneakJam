//
//  STSneakViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakViewController.h"
#import "STSneakView.h"
#import "UIImageView+AFNetworking.h"

@interface STSneakViewController ()

@property (nonatomic, retain) STTrackModel		*trackModel;
@property (nonatomic, retain) STAlbumModel		*albumModel;

@property (nonatomic, readonly) STSneakView		*sneakView;

@end

@implementation STSneakViewController

- (id)initWithTrackModel:(STTrackModel *)trackModel albumModel:(STAlbumModel *)albumModel {
	if (self = [super init]) {
		self.trackModel = trackModel;
		self.albumModel = albumModel;
	}
	return self;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_sneakView = [[STSneakView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_sneakView];
	
	_sneakView.trackTitleLabel.text = self.trackModel.name ? self.trackModel.name : @"Track";
	_sneakView.artistNameLabel.text = self.trackModel.artistName ? self.trackModel.artistName : @"Track";
	
	NSLog(@"%s album url == %@", __PRETTY_FUNCTION__, self.albumModel.coverBigImageURL);
	// TODO: download cover URL
	[_sneakView.coverImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.albumModel.coverBigImageURL ? self.albumModel.coverBigImageURL : self.albumModel.coverMediumImageURL]]
						   placeholderImage:nil
									success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
										_sneakView.coverImageView.alpha = 0.0;
										_sneakView.coverImageView.image = image;
										[UIView animateWithDuration:0.25 animations:^{
											_sneakView.coverImageView.alpha = 1.0;
										}];
									}
									failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
									}];
	
}

#pragma mark -

- (void)dealloc {
	[_trackModel release];
	[_albumModel release];
	[_sneakView release];
	[super dealloc];
}

@end
