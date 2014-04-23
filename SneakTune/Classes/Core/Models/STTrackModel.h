//
//  STTrackModel.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STBaseModel.h"

@interface STTrackModel : STBaseModel

@property (nonatomic, retain) NSString		*trackId;
@property (nonatomic, retain) NSString		*name;
@property (nonatomic, retain) NSString		*previewURL;
@property (nonatomic, retain) NSString		*spotifyURL;
@property (nonatomic, retain) NSNumber		*duration;		// ms
@property (nonatomic, retain) NSString		*albumId;
@property (nonatomic, retain) NSString		*artistName;

@property (nonatomic, retain) NSArray		*availbaleMarkets;

@end
