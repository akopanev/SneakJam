//
//  APContact.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APContact.h"
#import "APPhoneWithLabel.h"
#import "UIImage+RoundedCorner.h"
#import "MDImageView.h"

NSString * const APContactSelfKey = @"self";

NSString * const APContactUpdatedPictureNotificationPrefix = @"APContactUpdatedPictureNotification";

@interface APContact () {
    NSString *_thumbnailPath;
    NSOperation *_operation;
//    NSOperationQueue * _queue;
}

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@end

@implementation APContact

#pragma mark - life cycle

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    self = [super init];
    if (self)
    {
         _contactID = [self stringRecordIDfromRecord:recordRef];
        _fieldMask = fieldMask;
        if (fieldMask & APContactFieldFirstName)
        {
            _firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldLastName)
        {
            _lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldCompany)
        {
            _company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhones)
        {
            _phones = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhonesWithLabels)
        {
            _phonesWithLabels = [self arrayOfPhonesWithLabelsFromRecord:recordRef];
        }
        if (fieldMask & APContactFieldEmails)
        {
            _emails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPrefix) {
            _prefixName = [self stringProperty:kABPersonPrefixProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldSuffix) {
            _suffixName = [self stringProperty:kABPersonSuffixProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldMiddleName) {
            _middleName = [self stringProperty:kABPersonMiddleNameProperty fromRecord:recordRef];
        }
    }
    return self;
}

- (id)initSelfUser{
    self = [super init];
    if (self)
    {
        _contactID = APContactSelfKey;
        _fieldMask = APContactFieldAll;
        _firstName = NSLS(@"SELF_TITLE");
        _lastName = nil;
        _company = nil;
        _phones = [NSArray array];
        _phonesWithLabels = nil;
        _emails = [NSArray array];

        NSString *contactID = [self contactID];
        NSString *path = [[MDImageModel imagesDirectory] stringByAppendingPathComponent:contactID];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            UIImage *image = [UIImage imageNamed:@"my_avatar.png"];
            [UIImageJPEGRepresentation(image, 1.f) writeToFile:path atomically:YES];
        }
        self.thumbnailPath = path;
    }
    return self;
}

#pragma mark - private

- (NSString *)stringProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:property fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *string = (__bridge_transfer NSString *)value;
        if (string)
        {
            [array addObject:string];
        }
    }];
    return array.copy;
}

- (NSArray *)arrayOfPhonesWithLabelsFromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:kABPersonPhoneProperty fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
    {
        CFTypeRef rawPhone = ABMultiValueCopyValueAtIndex(multiValue, index);
        NSString *phone = (__bridge_transfer NSString *)rawPhone;
        if (phone)
        {
            NSString *label = [self localizedLabelFromMultiValue:multiValue index:index];
            APPhoneWithLabel *phoneWithLabel = [[APPhoneWithLabel alloc] initWithPhone:phone
                                                                                 label:label];
            [array addObject:phoneWithLabel];
        }
    }];
    return array.copy;
}

- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize fromRecord:(ABRecordRef)recordRef
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    CFDataRef dataRef = ABPersonCopyImageDataWithFormat(recordRef, format);
    NSData *data = (__bridge_transfer NSData*)dataRef;
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (NSString *)localizedLabelFromMultiValue:(ABMultiValueRef)multiValue index:(NSUInteger)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    if (rawLabel)
    {
        CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(rawLabel);
        if (localizedLabel)
        {
            label = (__bridge_transfer NSString *)localizedLabel;
        }
        CFRelease(rawLabel);
    }
    return label;
}

- (void)enumerateMultiValueOfProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
                            withBlock:(void (^)(ABMultiValueRef multiValue, NSUInteger index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
    for (NSUInteger i = 0; i < count; i++)
    {
        block(multiValue, i);
    }
    CFRelease(multiValue);
}

#pragma mark - Methods

- (NSString *)stringRecordIDfromRecord:(ABRecordRef)recordRef
{
    ABRecordID valueRef = (ABRecordGetRecordID(recordRef));
    NSString *label;
    label = [NSString stringWithFormat:@"%d",valueRef];
    return label;
}

- (NSString *)stringValueForSorting{
    NSMutableString *sortKeyString = [NSMutableString string];
    if ([self lastName]) {
        if ([sortKeyString length] > 0) {
            [sortKeyString appendString:@"!"];
        }
        [sortKeyString appendString:[self lastName]];
    }
    if ([self firstName]) {
        if ([sortKeyString length] > 0) {
            [sortKeyString appendString:@"!"];
        }
        [sortKeyString appendString:[self firstName]];
    }
    if ([self company]) {
        if ([sortKeyString length] > 0) {
            [sortKeyString appendString:@"!"];
        }
        [sortKeyString appendString:[self company]];
    }
    if ([[[self phones] firstObject] isKindOfClass:[NSString class]]) {
        if ([sortKeyString length] > 0) {
            [sortKeyString appendString:@"!"];
        }
        [sortKeyString appendString:[[self phones] firstObject]];
    }
    return [sortKeyString uppercaseString];
}

- (NSString *)fullName{
    NSMutableString *fullNameString = [NSMutableString string];
    
    NSString *lastNameStr = [self lastName];
    if (!lastNameStr) {
        lastNameStr = @"";
    }
    
    NSString *firstNameStr = [self firstName];
    if (!firstNameStr) {
        firstNameStr = @"";
    }
    
    NSString *suffixName = [self suffixName];
    if (!suffixName) {
        suffixName = @"";
    }
    NSString *middleName = [self middleName];
    if (!middleName) {
        middleName = @"";
    }
    NSString *prefixName = [self prefixName];
    if (!prefixName) {
        prefixName = @"";
    }

    NSString *companyNameStr = [self company];
    if (!companyNameStr) {
        companyNameStr = @"";
    }
    
    [fullNameString appendString:prefixName];
    if ([fullNameString length] > 0) {
        [fullNameString appendString:@" "];
    }
    [fullNameString appendString:firstNameStr];
    if ([fullNameString length] > 0) {
        fullNameString = [NSMutableString stringWithString:[fullNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [fullNameString appendString:@" "];
    }
    [fullNameString appendString:middleName];
    if ([fullNameString length] > 0) {
        fullNameString = [NSMutableString stringWithString:[fullNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [fullNameString appendString:@" "];
    }
    [fullNameString appendString:lastNameStr];
    if ([fullNameString length] > 0) {
        fullNameString = [NSMutableString stringWithString:[fullNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [fullNameString appendString:@" "];
    }
    [fullNameString appendString:suffixName];
    if (NSNotFound == [fullNameString rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]].location) {
        [fullNameString appendString:companyNameStr];
    }
    if (NSNotFound == [fullNameString rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]].location) {
        if (_phones.count > 0) {
            [fullNameString appendString:[_phones firstObject]];
        }
    }
    return [NSString stringWithString:fullNameString];
}

- (UIColor *)color{
    if ([_contactID isEqualToString:APContactSelfKey]) {
        return [UIColor intColorWithRed:67 green:202 blue:159 alpha:255];
    } else {
        return [UIColor spPastelColorForInt:[_contactID intValue]];
    }
    return [UIColor blackColor];
}

- (BOOL)isSelfUser{
    if ([_contactID isEqualToString:APContactSelfKey]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadImage {
    if (_loading || _thumbnailPath) return;
    
    _loading = YES;
    
    static dispatch_once_t once;
    static NSOperationQueue* sharedQueue;
    dispatch_once(&once, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setName:@"thumbnail_load_queue_md"];
    });
    __weak typeof(self) selfWeak = self;
    [self cancelLoadImage];
    _operation = [NSBlockOperation blockOperationWithBlock:^{
        @autoreleasepool {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABRecordID recordID = (ABRecordID)[[self contactID] integerValue];
            ABRecordRef aRecordRef = ABAddressBookGetPersonWithRecordID(addressBook, recordID);
            UIImage *quardImage = [selfWeak imagePropertyFullSize:NO fromRecord:aRecordRef];
            CFRelease(addressBook);
            UIImage *rounded = [quardImage roundedCornerImage:quardImage.size.width * 0.5f borderSize:0.0f];
            NSString *contactID = [selfWeak contactID];
            NSString *path = [[MDImageModel imagesDirectory] stringByAppendingPathComponent:contactID];
            NSData * data = UIImageJPEGRepresentation(rounded, 1.f);
            [data writeToFile:path atomically:YES];
            dispatch_async( dispatch_get_main_queue(), ^{
                selfWeak.thumbnailPath = path;
                selfWeak.loading = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:[APContactUpdatedPictureNotificationPrefix stringByAppendingString:contactID] object:selfWeak];
            });
        }
    }];
    [sharedQueue addOperation:_operation];
}

- (void)cancelLoadImage {
    if (_operation) {
        [_operation cancel];
        _operation = nil;
        _loading = NO;
    }
}

- (NSString *)thumbnailPath {
    if (!_thumbnailPath) {
        [self loadImage];
    }
    return _thumbnailPath;
}

- (void)setThumbnailPath:(NSString *)thumbnailPath {
    if (_thumbnailPath != thumbnailPath) {
        _thumbnailPath = thumbnailPath;
    }
}

#pragma mark - Save & Load

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _contactID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"contact_id"];
        _firstName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"first_name"];
        _lastName = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"last_name"];
        _company = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"company"];
        _thumbnailPath = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"thumbnail_path"];
        _emails = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"emails"];
        _phones = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"phones"];
        _phonesWithLabels = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"phonesWithLabels"];
//        _photo = [UIImage imageWithData:[aDecoder decodeObjectOfClass:[NSData class] forKey:@"photo"]];
//        _thumbnail = [UIImage imageWithData:[aDecoder decodeObjectOfClass:[NSData class] forKey:@"thumbnail"]];
        _fieldMask = [aDecoder decodeIntegerForKey:@"field_mask"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_fieldMask forKey:@"field_mask"];
    if (_firstName) {
        [aCoder encodeObject:_firstName forKey:@"first_name"];
    }
    if (_lastName) {
        [aCoder encodeObject:_lastName forKey:@"last_name"];
    }
    if (_company) {
        [aCoder encodeObject:_company forKey:@"company"];
    }
    if (_emails) {
        [aCoder encodeObject:_emails forKey:@"emails"];
    }
    if (_phones) {
        [aCoder encodeObject:_phones forKey:@"phones"];
    }
    if (_phonesWithLabels) {
        [aCoder encodeObject:_phonesWithLabels forKey:@"phonesWithLabels"];
    }
    if (_thumbnailPath) {
        [aCoder encodeObject:_thumbnailPath forKey:@"thumbnail_path"];
    }
//    NSData *imageData = UIImagePNGRepresentation(_photo);
//    if (imageData) {
//        [aCoder encodeObject:imageData forKey:@"photo"];
//    }
//    NSData *imageData = UIImagePNGRepresentation(_thumbnail);
//    if (imageData) {
//        [aCoder encodeObject:imageData forKey:@"thumbnail"];
//    }
    [aCoder encodeObject:_contactID forKey:@"contact_id"];
}

@end
