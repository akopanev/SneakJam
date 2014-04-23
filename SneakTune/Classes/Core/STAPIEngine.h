//
//  STAPIEngine.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNotificationCenter+MAKeys.h"
#import "STModels.h"

@interface STAPIEngine : NSObject

// singleton
+ (instancetype)defaultEngine;

// APIs
// search
// result is an array of tracks (NSArray)
// userInfo is trackTitle (NSString)
- (void)apiSearchTrack:(NSString *)trackTitle notificationName:(NSString *)notificationName;

// album
- (void)apiAlbumById:(NSString *)albumId notificationName:(NSString *)notificationName;

@end
