//
//  STContactsViewController.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTrackModel.h"
#import "STAlbumModel.h"

@interface STContactsViewController : UIViewController

- (id)initWithTrackModel:(STTrackModel *)trackModel albumModel:(STAlbumModel *)albumModel offset:(NSTimeInterval)offset duration:(NSTimeInterval)duration;

@end
