//
//  STAlbumModel.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STAlbumModel.h"

@implementation STAlbumModel

#pragma mark -

- (id)initWithJSONData:(NSDictionary *)jsonData {
	if (self = [super initWithJSONData:jsonData]) {
		self.albumId = [jsonData objectForKey:@"id"];
		self.name = [jsonData objectForKey:@"name"];
		NSDictionary *images = [jsonData objectForKey:@"images"];
		NSDictionary *mediumImage = [images objectForKey:@"MEDIUM"];
		self.coverMediumImageURL = [mediumImage objectForKey:@"image_url"];
		NSDictionary *bigImage = [images objectForKey:@"LARGE"];
		self.coverBigImageURL = [bigImage objectForKey:@"image_url"];
	}
	return self;
}

#pragma mark -

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: id=%@ coverMediumUrl=%@>", [super description], self.albumId, self.coverMediumImageURL];
}

#pragma mark -

- (void)dealloc {
	[_albumId release];
	[_name release];
	[_coverMediumImageURL release];
	[_coverBigImageURL release];
	[super dealloc];
}

@end
