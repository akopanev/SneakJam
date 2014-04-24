//
//  STShareView.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShareView : UIView

@property (nonatomic, assign) BOOL		inWaitingMode;

@property (nonatomic, readonly) UIButton	*viewURLButton;
@property (nonatomic, readonly) UIButton	*doneButton;

@end
