//
//  STSneakIndicatorView.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STSneakIndicatorView.h"

const CGFloat STSneakIndicatorViewLineHeight		= 2.0;

@implementation STSneakIndicatorView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
	
	CGFloat circleSize = self.bounds.size.height;
	CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, circleSize, circleSize));
	CGContextAddEllipseInRect(ctx, CGRectMake(self.bounds.size.width - circleSize, 0.0, circleSize, circleSize));
	CGContextFillPath(ctx);
	
	CGContextSetLineWidth(ctx, STSneakIndicatorViewLineHeight);
	CGFloat linePosition = ceilf( self.bounds.size.height * 0.5 );
	CGContextMoveToPoint(ctx, 1.0, linePosition);
	CGContextAddLineToPoint(ctx, self.bounds.size.width - 1.0, linePosition);
	CGContextStrokePath(ctx);
}

@end
