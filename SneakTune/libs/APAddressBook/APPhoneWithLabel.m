//
//  APPhoneWithLabel.m
//  APAddressBook
//
//  Created by John Hobbs on 2/7/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APPhoneWithLabel.h"

@implementation APPhoneWithLabel

- (id)initWithPhone:(NSString *)phone label:(NSString *)label {
    self = [super init];
    if(self)
    {
        _phone = phone;
        _label = label;
    }
    return self;
}

#pragma mark - Save & Load

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _phone = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"phone"];
        _label = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"label"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_label forKey:@"label"];
}

@end
