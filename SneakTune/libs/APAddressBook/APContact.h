//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "APTypes.h"

extern NSString * const APContactSelfKey;
extern NSString * const APContactUpdatedPictureNotificationPrefix;

@interface APContact : NSObject

@property (nonatomic, readonly) APContactField fieldMask;
@property (nonatomic, retain) NSString *contactID;

@property (nonatomic, retain) NSString *prefixName;
@property (nonatomic, retain) NSString *suffixName;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSArray *phones;
@property (nonatomic, retain) NSArray *phonesWithLabels;
@property (nonatomic, retain) NSArray *emails;
//@property (nonatomic, retain) UIImage *photo;
//@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *thumbnailPath;

@property (nonatomic, readonly) NSString *stringValueForSorting;
@property (nonatomic, readonly) NSString *fullName;

@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) BOOL isSelfUser;

- (id)initSelfUser;
- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

- (void)loadImage;//load thumbnail
- (void)cancelLoadImage;//cancel load thumbnail

@end
