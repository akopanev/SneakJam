//
//  STContactContentView.h
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APContact.h"

extern const CGFloat STContactContentViewHeight;

@interface STContactContentView : UIView

@property (nonatomic, retain) APContact		*contact;

@end
