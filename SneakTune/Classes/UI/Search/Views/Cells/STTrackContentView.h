//
//  STTrackContentView.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTrackModel.h"

extern const CGFloat STTrackContentViewHeight;

@interface STTrackContentView : UIView

@property (nonatomic, retain) STTrackModel		*trackModel;
@property (nonatomic, retain) NSString			*albumCoverImageURLString;

@end
