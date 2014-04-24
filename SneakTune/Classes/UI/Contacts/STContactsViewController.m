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

#import "STShareViewController.h"

@interface STContactsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	STContactsView		*_contactsView;
	APAddressBook		*_addressBook;
	NSOperationQueue	*_filteringContactsQueue;
	NSMutableDictionary	*_trackInfo;
}

@property (nonatomic, retain) NSArray		*filteredContactsList;
@property (nonatomic, retain) NSArray		*contactsList;

@end

@implementation STContactsViewController

#pragma mark -

- (id)initWithTrackModel:(STTrackModel *)trackModel albumModel:(STAlbumModel *)albumModel offset:(NSTimeInterval)offset duration:(NSTimeInterval)duration {
	if (self = [super init]) {
		_trackInfo = [[NSMutableDictionary alloc] init];
		[_trackInfo setValue:trackModel forKey:@"track"];
		[_trackInfo setValue:albumModel forKey:@"album"];
		[_trackInfo setValue:[NSNumber numberWithInt:offset * 1000] forKey:@"offset"];
		[_trackInfo setValue:[NSNumber numberWithInt:duration * 1000] forKey:@"duration"];
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
					[self filterContacts:_contactsView.searchField.text];
				}
            }
        }];
    });
}

- (void)filterContacts:(NSString *)keyword {
	if (keyword.length > 0) {
        [_filteringContactsQueue cancelAllOperations];
        [_filteringContactsQueue addOperationWithBlock:^{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((firstName != $DATE) AND (firstName != nil) AND (firstName CONTAINS[c] %@)) OR ((lastName != $DATE) AND (lastName != nil) AND (lastName CONTAINS[c] %@)) OR ((company != $DATE) AND (company != nil) AND (company CONTAINS[c] %@)) OR (ANY emails CONTAINS[c] %@)", keyword, keyword, keyword, keyword];
            predicate = [predicate predicateWithSubstitutionVariables:@{@"DATE": [NSNull null] }];
            NSArray *localFilteredArray = [self.contactsList filteredArrayUsingPredicate:predicate];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
				self.filteredContactsList = [NSMutableArray arrayWithArray:localFilteredArray];
				[_contactsView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
	} else {
		self.filteredContactsList = self.contactsList;
		[_contactsView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	}
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
	
	_filteringContactsQueue = [[NSOperationQueue alloc] init];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sneakjam_logo.png"]];
	self.navigationItem.titleView = imageView;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)] autorelease];
	
	_contactsView = [[STContactsView alloc] initWithFrame:self.view.bounds];
	_contactsView.searchField.delegate = self;
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
		
		STShareViewController *shareViewController = [[[STShareViewController alloc] initWithTrackInfo:_trackInfo selectedUsers:selectedUsers] autorelease];
		[self.navigationController pushViewController:shareViewController animated:YES];
	} else {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"Select friends for sharing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
	}
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return STContactContentViewHeight + 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.filteredContactsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	STContactViewCell *cell = (STContactViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STContactViewCell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[[STContactViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STContactViewCell"] autorelease];
	}
	
	cell.contactContentView.contact = [self.filteredContactsList objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	APContact *person = [self.filteredContactsList objectAtIndex:indexPath.row];
	person.isSelected = !person.isSelected;
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	[self filterContacts:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	[self filterContacts:@""];
	return YES;
}

#pragma mark -

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_addressBook release];
	[_contactsView release];
	[_trackInfo release];
	[_filteringContactsQueue release];
	[super dealloc];
}

@end
