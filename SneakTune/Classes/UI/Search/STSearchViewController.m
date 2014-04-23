//
//  STSearchViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSearchViewController.h"
#import "STSearchView.h"
#import "STTrackViewCell.h"

#import "STAPIEngine.h"

// const
NSString *const STSearchViewControllerSearchAPINotification			= @"STSearchViewControllerSearchAPINotification";
NSString *const STSearchViewControllerAlbumIdNotification			= @"STSearchViewControllerAlbumIdNotification";

@interface STSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	NSMutableDictionary		*_albumsDictionary;
}

@property (nonatomic, retain) NSArray				*tracksList;
@property (nonatomic, readonly) STSearchView		*searchView;
@property (nonatomic, retain) NSIndexPath			*selectedIndexPath;

@end

@implementation STSearchViewController

#pragma mark - notifications

- (void)didSearchTrackNotification:(NSNotification *)notification {
	NSLog(@"%s ui == %@", __PRETTY_FUNCTION__, notification);
	if (nil == NTF_ERROR(notification)) {
		self.tracksList = NTF_RESULT(notification);
		[self reloadDataWithError:nil];
	} else {
		// show an error
	}
}

- (void)albumNotification:(NSNotification *)notification {
	if (nil == NTF_ERROR(notification)) {
		[_albumsDictionary setValue:NTF_RESULT(notification) forKey:NTF_USERINFO(notification)];
		[self reloadCellWithAlbum:NTF_RESULT(notification)];
	}
}

#pragma mark - requests

- (void)requestAlbumInfo:(NSString *)albumId {
	[[STAPIEngine defaultEngine] apiAlbumById:albumId notificationName:STSearchViewControllerAlbumIdNotification];
}

- (void)requestSearchTrack:(NSString *)trackTitle {
	[[STAPIEngine defaultEngine] apiSearchTrack:trackTitle notificationName:STSearchViewControllerSearchAPINotification];
}

#pragma mark - initialization

- (id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSearchTrackNotification:) name:STSearchViewControllerSearchAPINotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumNotification:) name:STSearchViewControllerAlbumIdNotification object:nil];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	// create views
	_searchView = [[STSearchView alloc] initWithFrame:self.view.bounds];
	_searchView.searchField.delegate = self;
	_searchView.tableView.delegate = self;
	_searchView.tableView.dataSource = self;
	[self.view addSubview:_searchView];
	
	[_searchView.tableView registerClass:[STTrackViewCell class] forCellReuseIdentifier:@"STTrackViewCell"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (self.tracksList.count == 0) {
		[self.searchView.searchField becomeFirstResponder];
	}
}

#pragma mark - ui

- (void)reloadDataWithError:(NSError *)error {
	[self.searchView.tableView reloadData];
}

- (void)reloadCellWithAlbum:(STAlbumModel *)albumModel {
	for (STTrackViewCell *cell in [self.searchView.tableView visibleCells]) {
		if ([cell.trackContentView.trackModel.albumId isEqualToString:albumModel.albumId]) {
			cell.trackContentView.albumCoverImageURLString = albumModel.coverMediumImageURL;
		}
	}
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return STTrackContentViewHeight + 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tracksList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	STTrackViewCell *cell = (STTrackViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STTrackViewCell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[[STTrackViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STTrackViewCell"] autorelease];
	}
	
	STTrackModel *trackModel = [self.tracksList objectAtIndex:indexPath.row];
	STAlbumModel *albumModel = [_albumsDictionary objectForKey:trackModel.albumId];
	
	cell.trackContentView.trackModel = [self.tracksList objectAtIndex:indexPath.row];
	cell.trackContentView.albumCoverImageURLString = albumModel.coverMediumImageURL;
	
	// is there information about this album?
	// we need cover image
	if (nil == albumModel) {
		[self requestAlbumInfo:trackModel.albumId];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIndexPath = indexPath;
	
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length > 0) {
		[self requestSearchTrack:textField.text];
	}
	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_searchView release];
	[_tracksList release];
	[_selectedIndexPath release];
	[_albumsDictionary release];
	[super dealloc];
}

@end
