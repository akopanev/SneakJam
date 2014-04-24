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

#import "APContact.h"

// consts
NSString *const STSpotifyAPIURL				= @"https://api.spotify.com/v1/";
NSString *const STBackendAPIURL				= @"http://tune.milytia.org/share.php";

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

#pragma mark - Spotify

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

#pragma mark - Backend

- (void)apiShareTrackInfo:(NSDictionary *)trackInfo friends:(NSArray *)friends notificationName:(NSString *)notificationName {
	/*
	 url - превью (required)
	 offset - начало в ms (required)
	 duration - длина в ms (required)
	 page_url - страница на spotify
	 title - название песни
	 artist - исполнитель
	 cover_image - url картинки
	 */
	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params setValue:[[trackInfo objectForKey:@"track"] previewURL] forKey:@"url"];
	[params setValue:[[trackInfo objectForKey:@"track"] artistName] forKey:@"artist"];
	[params setValue:[[trackInfo objectForKey:@"track"] name] forKey:@"title"];
	[params setValue:[trackInfo objectForKey:@"offset"] forKey:@"offset"];
	[params setValue:[trackInfo objectForKey:@"duration"] forKey:@"duration"];
	[params setValue:[[trackInfo objectForKey:@"album"] coverBigImageURL] forKey:@"cover_image"];
	
	// https://play.spotify.com/track/0S2qXOyCf7MJlpxvsmZJVa
	NSString *spotifyURL = [NSString stringWithFormat:@"https://play.spotify.com/track/%@", [[trackInfo objectForKey:@"track"] trackId]];
	[params setValue:spotifyURL forKey:@"page_url"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:STBackendAPIURL]];
	[request setHTTPMethod:@"POST"];
	NSMutableString *string = [NSMutableString string];
	NSArray *allKeys = [params allKeys];
	for (int i = 0; i < allKeys.count; i++) {
		NSString *key = [allKeys objectAtIndex:i];
		[string appendFormat:@"%@=%@%@", key, [params objectForKey:key], i < allKeys.count - 1 ? @"&" : @""];
	}
	
	NSMutableArray *emails = [NSMutableArray array];
	for (APContact *contact in friends) {
		[emails addObject:[contact.emails firstObject]];
	}
	[string appendFormat:@"&emails=%@", [emails componentsJoinedByString:@","]];
	NSLog(@"%s string == %@", __PRETTY_FUNCTION__, string);
	
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFJSONResponseSerializer serializer];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		/*
		 status = success;
		 url = "http://tune.milytia.org/8";
		 */
		NSString *status = [responseObject objectForKey:@"status"];
		if ([@"success" isEqualToString:status]) {
			NSString *url = [responseObject objectForKey:@"url"];
			[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:url error:nil userInfo:trackInfo];
		} else {
			[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:nil error:[NSError errorWithDomain:@"STErrorDomain" code:1 userInfo:nil] userInfo:trackInfo];
		}		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[[NSNotificationCenter defaultCenter] maSendNotificationNamed:notificationName object:self result:nil error:error userInfo:trackInfo];
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
	
}

@end
