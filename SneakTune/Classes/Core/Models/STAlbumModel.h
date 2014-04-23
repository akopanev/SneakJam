//
//  STAlbumModel.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STBaseModel.h"

@interface STAlbumModel : STBaseModel

@property (nonatomic, retain) NSString		*albumId;
@property (nonatomic, retain) NSString		*name;
@property (nonatomic, retain) NSString		*coverMediumImageURL;
@property (nonatomic, retain) NSString		*coverBigImageURL;

@end
