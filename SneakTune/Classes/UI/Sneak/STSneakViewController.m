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

#import "AFNetworking.h"
#import "AFURLSessionManager.h"
#import "NSFileManager+MATools.h"
#import <AVFoundation/AVFoundation.h>
#import "STContactsViewController.h"

// consts
NSString *const STSneakViewControllerMP3FileName			= @"preview.mp3";

const NSInteger STSneakViewControllerErrorAlertViewTag		= 1;
const NSTimeInterval STSneakViewControllerPlayDuration		= 10;

@interface STSneakViewController () <UIAlertViewDelegate> {
	AFURLSessionManager		*_sessionManager;
	NSTimer					*_tenSecondsTimer;
}

@property (nonatomic, retain) STTrackModel		*trackModel;
@property (nonatomic, retain) STAlbumModel		*albumModel;
@property (nonatomic, retain) AVAudioPlayer		*audioPlayer;
@property (nonatomic, readonly) STSneakView		*sneakView;
@property (nonatomic, retain) NSNumber			*initialOffset;

@end

@implementation STSneakViewController

#pragma mark - helpers

- (NSString *)mp3FilePath {
	return [[[NSFileManager defaultManager] maCachesDirectory] stringByAppendingPathComponent:STSneakViewControllerMP3FileName];
}

- (NSURL *)mp3FileURL {
	return [NSURL fileURLWithPath:[self mp3FilePath]];
}

#pragma mark - notifications

#pragma mark - requests

- (void)requestMP3:(NSString *)mp3URL {
	_sneakView.showsLoadingLabel = YES;
	NSURL *URL = [NSURL URLWithString:mp3URL];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
		[[NSFileManager defaultManager] removeItemAtPath:[self mp3FilePath] error:nil];
		return [self mp3FileURL];
	} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
		if (nil == error) {
			// [self playMP3WithCurrentOffset];
			self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[self mp3FileURL] error:nil] autorelease];
			self.initialOffset = [NSNumber numberWithDouble:0.0];
			[self.audioPlayer prepareToPlay];
			_sneakView.showsLoadingLabel = NO;
			_sneakView.showsPlayButton = YES;
		} else {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"Failed to download preview. Would you like to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
			alertView.tag = STSneakViewControllerErrorAlertViewTag;
			[alertView show];
		}
		
	}];
	[downloadTask resume];
}

#pragma mark - initialization

- (id)initWithTrackModel:(STTrackModel *)trackModel albumModel:(STAlbumModel *)albumModel {
	if (self = [super init]) {
		self.trackModel = trackModel;
		self.albumModel = albumModel;
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		configuration.URLCache = nil;
		configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		_sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	}
	return self;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sneakjam_logo.png"]];
	self.navigationItem.titleView = imageView;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)] autorelease];
	
	_sneakView = [[STSneakView alloc] initWithFrame:self.view.bounds];
	[_sneakView.playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_sneakView];
	
	_sneakView.trackTitleLabel.text = self.trackModel.name ? self.trackModel.name : @"Track";
	_sneakView.artistNameLabel.text = self.trackModel.artistName ? self.trackModel.artistName : @"Track";
	[_sneakView.slideView addTarget:self action:@selector(offsetChangedAction) forControlEvents:UIControlEventValueChanged];
	
	if (self.albumModel) {
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
	
	[self requestMP3:self.trackModel.previewURL];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self killTimer];
}

#pragma mark - timer stuff

- (void)killTimer {
	@synchronized(self) {
		if ([_tenSecondsTimer isValid]) {
			[_tenSecondsTimer invalidate];
			_tenSecondsTimer = nil;
		}
	}
}

- (void)launchTenSecondsTimer {
	[self killTimer];
	_tenSecondsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark - actions

- (void)timerAction {
	NSTimeInterval initialOffset = _sneakView.slideView.currentOffset * self.audioPlayer.duration;
	if (self.audioPlayer.currentTime - initialOffset > STSneakViewControllerPlayDuration) {
		[self pauseAction];
	}
}

- (void)pauseAction {
	[self killTimer];
	_sneakView.playButtonIsPlayButton = YES;;
	[self.audioPlayer pause];
}

- (void)playAction {
	if (self.audioPlayer.isPlaying) {
		[self pauseAction];
	} else {
		[self playMP3WithCurrentOffset];
	}
}

- (void)offsetChangedAction {
	if (self.audioPlayer.isPlaying) {
		[self playMP3WithCurrentOffset];
	}
}

- (void)nextAction {
	STContactsViewController *contactsViewController = [[[STContactsViewController alloc] init] autorelease];
	[self.navigationController pushViewController:contactsViewController animated:YES];
}

#pragma mark - audio

- (void)playMP3WithCurrentOffset {
	_sneakView.playButtonIsPlayButton = NO;
	NSTimeInterval offset = _sneakView.slideView.currentOffset * self.audioPlayer.duration;
	NSLog(@"%s %.2f", __PRETTY_FUNCTION__, _sneakView.slideView.currentOffset);
	self.audioPlayer.currentTime = offset;
	[self.audioPlayer play];
	[self launchTenSecondsTimer];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (STSneakViewControllerErrorAlertViewTag == alertView.tag) {
		if (buttonIndex == alertView.cancelButtonIndex) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self requestMP3:self.trackModel.previewURL];
		}
	}
}

#pragma mark -

- (void)dealloc {
	[_trackModel release];
	[_albumModel release];
	[_sneakView release];
	[_sessionManager release];
	[_audioPlayer release];
	[super dealloc];
}

@end
