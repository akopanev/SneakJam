//
//  STSneakSlideView.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat STSneakSlideViewHeight;

@interface STSneakSlideView : UIControl

// returns current offset [0..0.67]
// we can't be more than 0.67 because user has to send clip with length == 10 seconds (10 / 30 == 0.33)
@property (nonatomic, readonly) CGFloat		currentOffset;

@end
