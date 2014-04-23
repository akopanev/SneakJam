//
//  STBaseModel.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STBaseModel.h"

@implementation STBaseModel

- (id)initWithJSONData:(NSDictionary *)jsonData {
	if (![jsonData isKindOfClass:[NSDictionary class]]) {
		[self autorelease];
		return nil;
	} else {
		return [super init];
	}
}

@end
