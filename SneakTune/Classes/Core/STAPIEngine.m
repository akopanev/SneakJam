//
//  STAPIEngine.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STAPIEngine.h"
#import "AFHTTPRequestOperation.h"
#import "NSError+MAErrorDescription.h"
#import "NSMutableArray+MaTools.h"

// consts
NSString *const STSpotifyAPIURL				= @"https://api.spotify.com/v1/";

@implementation STAPIEngine

// singleton
+ (instancetype)defaultEngine {
	static id instanceObject = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		instanceObject = [[self alloc] init];
	});
	return instanceObject;
}

#pragma mark - helpers

- (NSURL *)spotifyURLForAPI:(NSString *)apiName queryParams:(NSDictionary *)queryParams {
	assert( apiName != nil );
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", STSpotifyAPIURL, apiName];
	if (queryParams.allKeys.count) {
		[urlString appendString:@"?"];
		for (NSString *key in [queryParams allKeys]) {
			[urlString appendString: [NSString stringWithFormat:@"%@=%@", key, [[queryParams objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ];
		}
	}
	return [NSURL URLWithString:urlString];
}

#pragma mark - APIs

#pragma mark * search

- (void)apiSearchTrack:(NSString *)trackTitle notificationName:(NSString *)notificationName {
	assert( trackTitle.length > 0 );
	NSURL *searchAPIURL = [self spotifyURLForAPI:@"search" queryParams:@{@"q" : trackTitle ? trackTitle : @""}];
	NSURLRequest *request = [NSURLRequest requestWithURL:searchAPIURL];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSArray *tracks = [responseObject objectForKey:@"tracks"];
		NSMutableArray *models = [NSMutableArray array];
		for (NSDictionary *d in tracks) {
			[models maAddObject:[[[STTrackModel alloc] initWithJSONData:d] autorelease]];
		}
		
		[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:models error:nil userInfo:trackTitle];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:nil error:error userInfo:trackTitle];
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark * album

- (void)apiAlbumById:(NSString *)albumId notificationName:(NSString *)notificationName {
	assert( albumId.length > 0 );
	NSURL *searchAPIURL = [self spotifyURLForAPI:[NSString stringWithFormat:@"albums/%@", albumId] queryParams:nil];
	NSURLRequest *request = [NSURLRequest requestWithURL:searchAPIURL];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		STAlbumModel *albumModel = [[[STAlbumModel alloc] initWithJSONData:responseObject] autorelease];
		[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:albumModel error:nil userInfo:albumId];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:nil error:error userInfo:albumId];
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
}

@end
