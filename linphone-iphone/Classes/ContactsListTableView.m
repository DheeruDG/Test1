/* ContactsTableViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "ContactsListTableView.h"
#import "UIContactCell.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "Utils.h"

@implementation ContactsListTableView

#pragma mark - Lifecycle Functions
{
    NSMutableArray *arr;
}

- (void)initContactsTableViewController {
    addressBookMap = [[OrderedDictionary alloc] init];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(onAddressBookUpdate:)
                                               name:kLinphoneAddressBookUpdate
                                             object:nil];
}

- (void)onAddressBookUpdate:(NSNotification *)k {
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    if (IPAD) {
        if (![self selectFirstRow]) {
            ContactDetailsView *view = VIEW(ContactDetailsView);
            [view setContact:nil];
        }
    }
    //    NSMutableArray *razauserarray=[[NSMutableArray alloc]init];
    //    for (NSString *addr in LinphoneManager.instance.fastAddressBook.addressBookMap)
    //    {
    //
    //        Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
    //        for (NSString *phone in contact.phoneNumbers) {
    //             NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
    //            if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
    //                [razauserarray addObject:contact];
    //            }
    //        }
    //    }
    //    NSLog(@"%@",razauserarray)
}

- (id)init {
    self = [super init];
    if (self) {
        [self initContactsTableViewController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initContactsTableViewController];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllContacts];
}

- (void)removeAllContacts {
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j) {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i) {
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] setContact:nil];
        }
    }
}

#pragma mark -

static int ms_strcmpfuz(const char *fuzzy_word, const char *sentence) {
    if (!fuzzy_word || !sentence) {
        return fuzzy_word == sentence;
    }
    const char *c = fuzzy_word;
    const char *within_sentence = sentence;
    for (; c != NULL && *c != '\0' && within_sentence != NULL; ++c) {
        within_sentence = strchr(within_sentence, *c);
        // Could not find c character in sentence. Abort.
        if (within_sentence == NULL) {
            break;
        }
        // since strchr returns the index of the matched char, move forward
        within_sentence++;
    }
    
    // If the whole fuzzy was found, returns 0. Otherwise returns number of characters left.
    return (int)(within_sentence != NULL ? 0 : fuzzy_word + strlen(fuzzy_word) - c);
}

- (NSString *)displayNameForContact:(Contact *)person {
    NSString *name = [FastAddressBook displayNameForContact:person];
    if (name != nil && [name length] > 0 && ![name isEqualToString:NSLocalizedString(@"Unknown", nil)]) {
        // Add the contact only if it fuzzy match filter too (if any)
        if ([ContactSelection getNameOrEmailFilter] == nil ||
            (ms_strcmpfuz([[[ContactSelection getNameOrEmailFilter] lowercaseString] UTF8String],
                          [[name lowercaseString] UTF8String]) == 0)) {
            
            // Sort contacts by first letter. We need to translate the name to ASCII first, because of UTF-8
            // issues. For instance expected order would be:  Alberta(A tilde) before ASylvano.
            NSData *name2ASCIIdata = [name dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *name2ASCII = [[NSString alloc] initWithData:name2ASCIIdata encoding:NSASCIIStringEncoding];
            return name2ASCII;
        }
    }
    return nil;
}

- (void)loadData {
    
    LOGI(@"Load contact list");
    @synchronized(addressBookMap) {
        //Set all contacts from ContactCell to nil
        //		for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        //		{
        //			for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        //			{
        //				[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] setContact:nil];
        //			}
        //		}
        
        // Reset Address book
        [addressBookMap removeAllObjects];
        addressBookMap=[[OrderedDictionary alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //            //[[Razauser SharedInstance]HideWaiting];
            [super loadData];
            //
        });
        for (NSString *addr in [LinphoneManager.instance.fastAddressBook.addressBookMap allKeys]) {
            Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
            BOOL add = true;
            
            // Do not add the contact directly if we set some filter
            
            if (moderazauserornot.length) {
                add=false;
                for (NSString *phone in contact.phoneNumbers) {
                    NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
                    if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
                        add = true;
                        break;
                    }
                }
                
            }
            else
            {
                if (LC!=NULL) {
                    
                    
                    //                 LinphonePresenceBasicStatus ll=linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend));
                    //                 if (ll) {
                    //
                    //                 }
                    if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
                        add = false;
                    }
                    if ([FastAddressBook contactHasValidSipDomain:contact]) {
                        add = true;
                    }
                    //                 if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
                    //                     add = true;
                    //                 }
                    
                    if (!add && [ContactSelection emailFilterEnabled]) {
                        // Add this contact if it has an email
                        add = (contact.emails.count > 0);
                    }
                }
            }
            
            NSMutableString *name = [self displayNameForContact:contact]
            ? [[NSMutableString alloc] initWithString:[self displayNameForContact:contact]]
            : nil;
            if (add && name != nil) {
                NSString *firstChar = [[name substringToIndex:1] uppercaseString];
                
                // Put in correct subAr
                if ([firstChar characterAtIndex:0] < 'A' || [firstChar characterAtIndex:0] > 'Z') {
                    firstChar = @"#";
                }
                NSMutableArray *subAr = [addressBookMap objectForKey:firstChar];
                if (subAr == nil) {
                    subAr = [[NSMutableArray alloc] init];
                    [addressBookMap insertObject:subAr forKey:firstChar selector:@selector(caseInsensitiveCompare:)];
                }
                NSUInteger idx = [subAr indexOfObject:contact
                                        inSortedRange:(NSRange){0, subAr.count}
                                              options:NSBinarySearchingInsertionIndex
                                      usingComparator:^NSComparisonResult(Contact*  _Nonnull obj1, Contact*  _Nonnull obj2) {
                                          return [[self displayNameForContact:obj1] compare:[self displayNameForContact:obj2]options:NSCaseInsensitiveSearch];
                                      }];
                if ([contact isKindOfClass:[Contact class]]) {
                    
                    
                    if (![subAr containsObject:contact]) {
                        [subAr insertObject:contact atIndex:idx];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[Razauser SharedInstance]HideWaiting];
            [super loadData];
        });
        
        
        // since we refresh the tableview, we must perform this on main thread
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (IPAD) {
                if (!([self totalNumberOfItems] > 0)) {
                    ContactDetailsView *view = VIEW(ContactDetailsView);
                    [view setContact:nil];
                }
            }
        });
    }
}

- (void)loadSearchedData {
    LOGI(@"Load contact list");
    @synchronized(addressBookMap) {
        //Set all contacts from ContactCell to nil
        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
            {
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] setContact:nil];
            }
        }
        
        // Reset Address book
        [addressBookMap removeAllObjects];
        NSMutableArray *subAr = [NSMutableArray new];
        NSMutableArray *subArBegin = [NSMutableArray new];
        NSMutableArray *subArContain = [NSMutableArray new];
        [addressBookMap insertObject:subAr forKey:@"" selector:@selector(caseInsensitiveCompare:)];
        for (NSString *addr in LinphoneManager.instance.fastAddressBook.addressBookMap) {
            Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
            BOOL add = true;
            // Do not add the contact directly if we set some filter
            if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
                add = false;
            }
            NSString* filter = [ContactSelection getNameOrEmailFilter];
            if ([FastAddressBook contactHasValidSipDomain:contact]) {
                add = true;
            }
            //			if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
            //				add = true;
            //			}
            
            
            if (!add && [ContactSelection emailFilterEnabled]) {
                // Add this contact if it has an email
                add = (contact.emails.count > 0);
            }
            if (moderazauserornot.length) {
                
                for (NSString *phone in contact.phoneNumbers) {
                    NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
                    if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
                        add = true;
                        break;
                    }
                }
                
            }
            NSInteger idx_begin = -1;
            NSInteger idx_sort = - 1;
            NSMutableString *name = [self displayNameForContact:contact]
            ? [[NSMutableString alloc] initWithString:[self displayNameForContact:contact]]
            : nil;
            if (add && name != nil) {
                if ([[contact displayName] rangeOfString:filter options:NSCaseInsensitiveSearch].location == 0) {
                    if(![subArBegin containsObject:contact]) {
                        idx_begin = idx_begin + 1;
                        [subArBegin insertObject:contact atIndex:idx_begin];
                    }
                } else if([[contact displayName] rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    if(![subArContain containsObject:contact]) {
                        idx_sort = idx_sort + 1;
                        [subArContain insertObject:contact atIndex:idx_sort];
                    }
                }
            }
        }
        [subArBegin sortUsingComparator:^NSComparisonResult(Contact*  _Nonnull obj1, Contact*  _Nonnull obj2) {
            return [[self displayNameForContact:obj1] compare:[self displayNameForContact:obj2]options:NSCaseInsensitiveSearch];
        }];
        
        [subArContain sortUsingComparator:^NSComparisonResult(Contact*  _Nonnull obj1, Contact*  _Nonnull obj2) {
            return [[self displayNameForContact:obj1] compare:[self displayNameForContact:obj2]options:NSCaseInsensitiveSearch];
        }];
        
        [subAr addObjectsFromArray:subArBegin];
        [subAr addObjectsFromArray:subArContain];
        [super loadData];
        
        // since we refresh the tableview, we must perform this on main thread
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (IPAD) {
                if (!([self totalNumberOfItems] > 0)) {
                    ContactDetailsView *view = VIEW(ContactDetailsView);
                    [view setContact:nil];
                }
            }
        });
    }
}


#pragma mark - UITableViewDataSource Functions

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *arr1=[addressBookMap allKeys];
    arr=[[NSMutableArray alloc]init];
    if (arr1.count<=13) {
        
        
        for (int i=0; i<arr1.count; i++) {
            [arr addObject:[arr1 objectAtIndex:i]];
            [arr addObject:@""];
            if ((iPhone4Or5oriPad!=4) && (iPhone4Or5oriPad!=5))
                [arr addObject:@""];
            
            //   [arr addObject:@""];
            //  [arr addObject:@""];
        }
    }
    else
    {
        arr=[arr1 mutableCopy];
    }
    //    [arr addObject:@"A"];
    //    for (NSString *str in [addressBookMap allKeys]) {
    //        [arr addObject:str];
    //       // [arr addObject:@""];
    //       // [arr addObject:@""];
    //
    //
    //    }
    return arr; //[addressBookMap allKeys];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    if ([title isEqualToString:@""]){
        return -1;
    }
    else
    {
        if ([addressBookMap allKeys].count<=13) {
            
            
            int vv=(int)[arr indexOfObject:title];
            if ((iPhone4Or5oriPad!=4) && (iPhone4Or5oriPad!=5))
                vv=vv/3;
            else
                vv=vv/2;
            return vv;
        }
        else
            return[arr indexOfObject:title];
        
        //[arr indexOfObject:title];
    }
    //return [arr indexOfObject:title];
    //  return 3; //[[addressBookMap allKeys] indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[addressBookMap allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(OrderedDictionary *)[addressBookMap objectForKey:[addressBookMap keyAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kCellId = NSStringFromClass(UIContactCell.class);
    UIContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UIContactCell alloc] initWithIdentifier:kCellId];
    }
    // int aa=(int)indexPath.row;
    // int bb=(int)indexPath.section;
    //NSLog(@"%d---%d",aa,bb);
    NSMutableArray *subAr = [addressBookMap objectForKey:[addressBookMap keyAtIndex:[indexPath section]]];
    if (subAr.count>(int)indexPath.row) {
        Contact *contact = subAr[indexPath.row];
        
        // Cached avatar
        [self setrazauserimage:contact andcell:cell];
        //UIImage *image = [FastAddressBook imageForContact:contact thumbnail:true];
        //[cell.avatarImage setImage:image bordered:NO withRoundedRadius:YES];
        [cell setContact:contact];
        [super accessoryForCell:cell atPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width-20, tableView.sectionHeaderHeight);
//    UIView *tempView = [[UIView alloc] initWithFrame:frame];
//    tempView.backgroundColor = kColorHeader;
//    
//    UILabel *tempLabel = [[UILabel alloc] initWithFrame:frame];
//    tempLabel.backgroundColor = [UIColor clearColor];
//    tempLabel.textColor = [UIColor whiteColor];// colorWithPatternImage:[UIImage imageNamed:@"header_bg.png"]];
//    tempLabel.text = [addressBookMap keyAtIndex:section];
//    //tempLabel.textAlignment = NSTextAlignmentCenter;
//    tempLabel.font = [UIFont boldSystemFontOfSize:15];
//    tempLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [tempView addSubview:tempLabel];
//    
//    return tempView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![self isEditing]) {
        NSMutableArray *subAr = [addressBookMap objectForKey:[addressBookMap keyAtIndex:[indexPath section]]];
        Contact *contact = subAr[indexPath.row];
        [[LinphoneManager instance] lpConfigSetInt:YES forKey:@"animations_preference"];
        // Go to Contact details view
        ContactDetailsView *view = VIEW(ContactDetailsView);
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        if (([ContactSelection getSelectionMode] != ContactSelectionModeEdit) || !([ContactSelection getAddAddress])) {
            [view setContact:contact];
        } else {
            [view editContact:contact address:[ContactSelection getAddAddress]];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        [tableView beginUpdates];
        
        NSString *firstChar = [addressBookMap keyAtIndex:[indexPath section]];
        NSMutableArray *subAr = [addressBookMap objectForKey:firstChar];
        Contact *contact = subAr[indexPath.row];
        [subAr removeObjectAtIndex:indexPath.row];
        if (subAr.count == 0) {
            [addressBookMap removeObjectForKey:firstChar];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationFade];
        }
        UIContactCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setContact:NULL];
        [[LinphoneManager.instance fastAddressBook] removeContact:contact];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onAddressBookUpdate:)
                                                   name:kLinphoneAddressBookUpdate
                                                 object:nil];
        [self loadData];
    }
}

- (void)removeSelectionUsing:(void (^)(NSIndexPath *))remover {
    [super removeSelectionUsing:^(NSIndexPath *indexPath) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        
        NSString *firstChar = [addressBookMap keyAtIndex:[indexPath section]];
        NSMutableArray *subAr = [addressBookMap objectForKey:firstChar];
        Contact *contact = subAr[indexPath.row];
        [subAr removeObjectAtIndex:indexPath.row];
        if (subAr.count == 0) {
            [addressBookMap removeObjectForKey:firstChar];
        }
        UIContactCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setContact:NULL];
        [[LinphoneManager.instance fastAddressBook] removeContact:contact];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onAddressBookUpdate:)
                                                   name:kLinphoneAddressBookUpdate
                                                 object:nil];
    }];
}


-(void)setrazauserimage:(Contact*)razacontact andcell:(UIContactCell*)cellinfo
{
    BOOL contactfound=NO;
    NSString *userphone;
    for (NSString *phonenumber in razacontact.phoneNumbers) {
        NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phonenumber];
        if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
            contactfound=YES;
            userphone=numberKey;
            break;
        }
    }
    
    if (contactfound) {
        
        
        // char *cr_from_string1 = linphone_address_as_string_uri_only(imageadd);
        //  NSString *str=[NSString stringWithUTF8String:cr_from_string1];
        //  NSString *phone=[[Razauser SharedInstance]getusername:userphone];
        
        NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,userphone]];
        [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
            if (image)
            {
                NSData *imageData =[[Razauser SharedInstance] compressImage:image];
                UIImage *img=[UIImage imageWithData:imageData];
                [cellinfo.avatarImage setImage:img bordered:NO withRoundedRadius:YES];
                [self setAvatarforraza:img andcontact:razacontact];
                //  cellinfo.image=image;
            }
            else
                //[cellinfo setImage:[FastAddressBook imageForAddress:razacontact thumbnail:YES] bordered:NO withRoundedRadius:YES];
            {
                ABPersonRemoveImageData(razacontact.person, NULL);
                UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
                
                [self setAvatarforraza:nil andcontact:razacontact];
                [cellinfo.avatarImage setImage:image bordered:NO withRoundedRadius:YES];
                
            }
            
        }];
    }
    else
    {
        UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
        [cellinfo.avatarImage setImage:image bordered:NO withRoundedRadius:YES];
    }
}
- (void)setAvatarforraza:(UIImage *)avatar andcontact:(Contact*)person {
    
    CFErrorRef error = NULL;
    if (!ABPersonRemoveImageData(person.person, &error)) {
        LOGW(@"Can't remove entry: %@", [(__bridge NSError *)error localizedDescription]);
    }
    NSData *dataRef = UIImageJPEGRepresentation(avatar, 0.9f);
    CFDataRef cfdata = CFDataCreate(NULL, [dataRef bytes], [dataRef length]);
    
    if (!ABPersonSetImageData(person.person, cfdata, &error)) {
        LOGW(@"Can't add entry: %@", [(__bridge NSError *)error localizedDescription]);
    }
    
    CFRelease(cfdata);
    
}

/*-----------
 
 
 -(void)setrazauser:(Contact*)razacontact
 {
 BOOL contactfound;
 NSString *userphone;
 for (NSString *phonenumber in razacontact.phoneNumbers) {
 if ([[[Razauser SharedInstance]getRazauser] containsObject:phonenumber]) {
 contactfound=YES;
 userphone=phonenumber;
 break;
 }
 }
 
 if (contactfound) {
 NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,userphone]];
 [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
 if (image)
 {
 
 }
 
 
 
 }];
 }
 }*/




@end
