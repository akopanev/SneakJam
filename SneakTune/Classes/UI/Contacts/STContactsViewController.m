//
//  STContactsViewController.m
//  SneakTune
//
//  Created by Andrew Kopanev on 4/23/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "STContactsViewController.h"
#import "STContactsView.h"
#import "STContactViewCell.h"
#import "APAddressBook.h"

#import "STAPIEngine.h"

@interface STContactsViewController () <UITableViewDataSource, UITableViewDelegate> {
	STContactsView		*_contactsView;
	APAddressBook		*_addressBook;
	
	NSMutableDictionary	*_trackInfo;
}

@property (nonatomic, retain) NSArray		*contactsList;

@end

@implementation STContactsViewController

#pragma mark -

- (id)initWithTrackModel:(STTrackModel *)trackModel albumModel:(STAlbumModel *)albumModel offset:(NSTimeInterval)offset duration:(NSTimeInterval)duration {
	if (self = [super init]) {
		_trackInfo = [[NSMutableDictionary alloc] init];
		[_trackInfo setValue:trackModel forKey:@"track"];
		[_trackInfo setValue:albumModel forKey:@"album"];
		[_trackInfo setValue:[NSNumber numberWithDouble:offset * 1000] forKey:@"offset"];
		[_trackInfo setValue:[NSNumber numberWithDouble:duration * 1000] forKey:@"duration"];
	}
	return self;
}

#pragma mark -

- (void)parseContacts {
	dispatch_async(dispatch_get_main_queue(), ^{
		if (!_addressBook) {
			_addressBook = [[APAddressBook alloc] init];
		}
        _addressBook.fieldsMask = APContactFieldDefault | APContactFieldCompany | APContactFieldEmails |  APContactFieldPhonesWithLabels;
        _addressBook.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"stringValueForSorting" ascending:YES]
                                         ];
        [_addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            if ([error.domain isEqualToString:APAddressBookEroorDomain]) {
				// TODO: show alert
            } else {
                if (error) {
					// TODO: show alert
                } else {
					// contacts with email only
					NSMutableArray *contactsWithEmail = [NSMutableArray array];
					for (APContact *contact in contacts) {
						if (contact.emails.count > 0) {
							[contactsWithEmail addObject:contact];
						}
					}
					
					// sort them out
					[contactsWithEmail sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"stringValueForSorting" ascending:YES]]];
					self.contactsList = contactsWithEmail;
					[_contactsView.tableView reloadData];
				}
            }
        }];
    });
}

- (NSArray *)selectedUsers {
	NSMutableArray *selectedUsers = [NSMutableArray array];
	for (APContact *contact in self.contactsList) {
		if (contact.isSelected) {
			[selectedUsers addObject:contact];
		}
	}
	return selectedUsers;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sneakjam_logo.png"]];
	self.navigationItem.titleView = imageView;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)] autorelease];
	
	_contactsView = [[STContactsView alloc] initWithFrame:self.view.bounds];
	_contactsView.tableView.delegate = self;
	_contactsView.tableView.dataSource = self;
	[_contactsView.tableView registerClass:[STContactViewCell class] forCellReuseIdentifier:@"STContactViewCell"];
	
	[self.view addSubview:_contactsView];
	
	[self parseContacts];
}

#pragma mark - actions

- (void)shareAction {
	NSArray *selectedUsers = [self selectedUsers];
	if (selectedUsers.count) {
		[[STAPIEngine defaultEngine] apiShareTrackInfo:_trackInfo friends:selectedUsers notificationName:nil];
	} else {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"Select friends for sharing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
	}
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return STContactContentViewHeight + 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.contactsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	STContactViewCell *cell = (STContactViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STContactViewCell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[[STContactViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STContactViewCell"] autorelease];
	}
	
	cell.contactContentView.contact = [self.contactsList objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	APContact *person = [self.contactsList objectAtIndex:indexPath.row];
	person.isSelected = !person.isSelected;
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -

- (void)dealloc {
	[_addressBook release];
	[_contactsView release];
	[_trackInfo release];
	[super dealloc];
}

@end
