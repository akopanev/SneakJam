//
//  STContactViewCell.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/24/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactViewCell.h"

@implementation STContactViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_contactContentView = [[STContactContentView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_contactContentView];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	_contactContentView.frame = self.contentView.bounds;
}

#pragma mark -

- (void)dealloc {
	[_contactContentView release];
	[super dealloc];
}

@end
