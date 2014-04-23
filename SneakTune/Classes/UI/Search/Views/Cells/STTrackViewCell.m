//
//  STTrackViewCell.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STTrackViewCell.h"

@implementation STTrackViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_trackContentView = [[STTrackContentView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_trackContentView];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_trackContentView.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[_trackContentView release];
	[super dealloc];
}

@end
