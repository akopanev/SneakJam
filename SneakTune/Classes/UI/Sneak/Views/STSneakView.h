//
//  STSneakView.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSneakSlideView.h"

@interface STSneakView : UIView

@property (nonatomic, readonly) UIImageView				*coverImageView;
@property (nonatomic, readonly) UILabel					*trackTitleLabel;
@property (nonatomic, readonly) UILabel					*artistNameLabel;
@property (nonatomic, readonly) STSneakSlideView		*slideView;

@property (nonatomic, assign) BOOL						showsLoadingLabel;
@property (nonatomic, assign) BOOL						showsPlayButton;

// hehe, it's hackaton, I have no time...
@property (nonatomic, assign) BOOL						playButtonIsPlayButton;

@property (nonatomic, readonly) UIButton				*playButton;

@end
