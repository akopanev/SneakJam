//
//  STTrackModel.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STTrackModel.h"

@implementation STTrackModel

#pragma mark -

- (id)initWithJSONData:(NSDictionary *)jsonData {
	if (self = [super initWithJSONData:jsonData]) {
		self.trackId = [jsonData objectForKey:@"id"];
		self.name = [jsonData objectForKey:@"name"];
		self.availbaleMarkets = [jsonData objectForKey:@"available_markets"];
		self.previewURL = [jsonData objectForKey:@"preview_url"];
		self.spotifyURL = [jsonData objectForKey:@"spotify_uri"];
		
		NSDictionary *albumDictionary = [jsonData objectForKey:@"album"];
		if ([albumDictionary isKindOfClass:[NSDictionary class]]) {
			self.albumId = [albumDictionary objectForKey:@"id"];
		}
		
		NSArray *artists = [jsonData objectForKey:@"artists"];
		if ([artists isKindOfClass:[NSArray class]]) {
			NSDictionary *artist = [artists firstObject];
			self.artistName = [artist objectForKey:@"name"];
		}
	}
	return self;
}

#pragma mark -

- (void)dealloc {
	[_trackId release];
	[_name release];
	[_previewURL release];
	[_spotifyURL release];
	[_duration release];
	[_availbaleMarkets release];
	[_albumId release];
	[_artistName release];
	[super dealloc];
}

@end
