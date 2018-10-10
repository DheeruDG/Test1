//
//  MyTableViewController.m
//  UISearchDisplayController
//
//  Created by Phillip Harris on 4/19/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "ChatConversationCreateTableView.h"
#import "UIChatCreateCell.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"

@interface ChatConversationCreateTableView (){
    NSMutableArray *arr;
}

@property(nonatomic, strong) OrderedDictionary *contacts;
@property(nonatomic, strong) NSDictionary *allContacts;
@end

@implementation ChatConversationCreateTableView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.allContacts =
    [[NSDictionary alloc] initWithDictionary:LinphoneManager.instance.fastAddressBook.addressBookMap];
    self.contacts = [[OrderedDictionary alloc]init];//[[NSMutableDictionary alloc] initWithCapacity:_allContacts.count];
   // [_searchBar becomeFirstResponder];
    [_searchBar setText:@""];
    _searchBar.delegate=self;
   // [self searchBar:_searchBar textDidChange:_searchBar.text];
    self.tableView.accessibilityIdentifier = @"Suggested addresses";
    NSLog(@"%@",LinphoneManager.instance.fastAddressBook.addressBookMap);
   // [[Razauser SharedInstance]getFormatedRazaUser];
   // razauser= [[Razauser SharedInstance]getFormatedRazaUser];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        [[Razauser SharedInstance] getformatedrazauser:@"" callback:^(OrderedDictionary *addressBookMap, NSError *error) {
            
            if (addressBookMap) {
                razauser=addressBookMap;
               dispatch_async(dispatch_get_main_queue(), ^(void){
              [self.tableView reloadData];
                 });
               
            }
        }];

    });
   }

- (void)reloadDataWithFilter:(NSString *)filter {
    if (filter.length>0) {
        [self loadSearchedData:filter];
    }else{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            
            [[Razauser SharedInstance] getformatedrazauser:@"" callback:^(OrderedDictionary *addressBookMap, NSError *error) {
                
                if (addressBookMap) {
                    razauser=addressBookMap;
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.tableView reloadData];
                    });
                    
                }
            }];
            
        });
    }
    //getformatedrazauserbyname

    
//    [_contacts removeAllObjects];
//    
//        [razauser enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
//          NSString *address = (NSString *)key;
//          NSString *name = [FastAddressBook displayNameForContact:value];
//          if ((filter.length == 0) || ([name.lowercaseString containsSubstring:filter.lowercaseString]) ||
//              ([address.lowercaseString containsSubstring:filter.lowercaseString])) {
//              _contacts[address] = name;
//          }
//    
//        }];
//        // also add current entry, if not listed
//        NSString *nsuri = filter.lowercaseString;
//        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:nsuri];
//        if (addr) {
//            char *uri = linphone_address_as_string(addr);
//            nsuri = [NSString stringWithUTF8String:uri];
//            ms_free(uri);
//            linphone_address_destroy(addr);
//        }
//        if (nsuri.length > 0 && [_contacts valueForKey:nsuri] == nil) {
//            _contacts[nsuri] = filter;
//        }
    
   // [self.tableView reloadData];
}
- (void)loadSearchedData:(NSString*)name {
    LOGI(@"Load contact list");
    @synchronized(razauser) {
        //Set all contacts from ContactCell to nil
//        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
//        {
//            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
//            {
//                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] setContact:nil];
//            }
//        }
        
        // Reset Address book
        [razauser removeAllObjects];
        NSMutableArray *subAr = [NSMutableArray new];
        NSMutableArray *subArBegin = [NSMutableArray new];
        NSMutableArray *subArContain = [NSMutableArray new];
        [razauser insertObject:subAr forKey:@"" selector:@selector(caseInsensitiveCompare:)];
        for (NSString *addr in LinphoneManager.instance.fastAddressBook.addressBookMap) {
            Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
            BOOL add = true;
            // Do not add the contact directly if we set some filter
            if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
                add = false;
            }
            NSString* filter = name;
            if ([FastAddressBook contactHasValidSipDomain:contact]) {
                add = true;
            }
            //            if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
            //                add = true;
            //            }
            
            
            if (!add && [ContactSelection emailFilterEnabled]) {
                // Add this contact if it has an email
                add = (contact.emails.count > 0);
            }
            for (NSString *phone in contact.phoneNumbers) {
                    NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
                    if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
                        add = true;
                        break;
                    }else{
                        add=false;
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
       
    }
     [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[razauser allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(OrderedDictionary *)[razauser objectForKey:[razauser keyAtIndex:section]] count];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight);
//    UIView *tempView = [[UIView alloc] initWithFrame:frame];
//    tempView.backgroundColor = kColorHeader;//[UIColor whiteColor];
//
//    UILabel *tempLabel = [[UILabel alloc] initWithFrame:frame];
//    tempLabel.backgroundColor = [UIColor clearColor];
//    tempLabel.textColor =[UIColor whiteColor]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"color_A.png"]];
//    tempLabel.text = [razauser keyAtIndex:section];
//    tempLabel.textAlignment = NSTextAlignmentCenter;
//    tempLabel.font = [UIFont boldSystemFontOfSize:17];
//    tempLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [tempView addSubview:tempLabel];
//
//    return tempView;
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *arr1=[razauser allKeys];
    arr=[[NSMutableArray alloc]init];
    if (arr1.count<=13) {
        for (int i=0; i<arr1.count; i++) {
            [arr addObject:[arr1 objectAtIndex:i]];
            [arr addObject:@""];
            if ((iPhone4Or5oriPad!=4) && (iPhone4Or5oriPad!=5))
                [arr addObject:@""];
        }
    }
    else{
        arr=[arr1 mutableCopy];
    }
    return arr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if ([title isEqualToString:@""]){
        
        return -1;
    }else{
        if ([razauser allKeys].count<=13) {

            int vv=(int)[arr indexOfObject:title];
            if ((iPhone4Or5oriPad!=4) && (iPhone4Or5oriPad!=5))
                vv=vv/3;
            else
                vv=vv/2;
            return vv;
        }
        else
            return[arr indexOfObject:title];
    }
   // return [[razauser allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kCellId = NSStringFromClass(UIChatCreateCell.class);
    UIChatCreateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UIChatCreateCell alloc] initWithIdentifier:kCellId];
    }
    //cell.displayNameLabel.text = [_contacts.allValues objectAtIndex:indexPath.row];
    //cell.addressLabel.text = [_contacts.allKeys objectAtIndex:indexPath.row];
    NSMutableArray *subAr = [razauser objectForKey:[razauser keyAtIndex:[indexPath section]]];
    Contact *contact = subAr[indexPath.row];
    cell.displayNameLabel.text = contact.firstName;
    if (contact.phoneNumbers.count>1)
        cell.addressLabel.text = [contact.phoneNumbers objectAtIndex:0];
    else if (contact.phoneNumbers.count==1)
        cell.addressLabel.text = [contact.phoneNumbers objectAtIndex:0];
    else
        cell.addressLabel.text = @"";
    
    [self setrazauserimage:contact andcell:cell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //	LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
    //		LC, ((NSString *)[_contacts.allKeys objectAtIndex:indexPath.row]).UTF8String);
    //	if (!room) {
    //		[PhoneMainView.instance popCurrentView];
    //		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid address", nil)
    //																		 message:NSLocalizedString(@"Please specify the entire SIP address for the chat",
    //																									   nil)
    //																  preferredStyle:UIAlertControllerStyleAlert];
    //
    //		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
    //																style:UIAlertActionStyleDefault
    //																handler:^(UIAlertAction * action) {}];
    //
    //		[errView addAction:defaultAction];
    //		[self presentViewController:errView animated:YES completion:nil];
    //	} else {
    //		ChatConversationView *view = VIEW(ChatConversationView);
    //		[view setChatRoom:room];
    //		[PhoneMainView.instance popCurrentView];
    //		[PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    //		// refresh list of chatrooms if we are using fragment
    //		if (IPAD) {
    //			ChatsListView *listView = VIEW(ChatsListView);
    //			[listView.tableController loadData];
    //		}
    //	}
    
    /*--------------*/
    NSMutableArray *subAr = [razauser objectForKey:[razauser keyAtIndex:[indexPath section]]];
    Contact *contact = subAr[indexPath.row];
    NSString *callno;
    if (contact.phoneNumbers.count) {
        callno= [contact.phoneNumbers objectAtIndex:0];
       callno = [RazaHelper getValidPhoneNumberWithString:callno];
        callno=[NSString stringWithFormat:@"sip:%@@%@",callno,MAINRAZASIPURL];
    }
    //callno=[NSString stringWithFormat:@"sip:@%@",callno];
   /* LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
                                                                  LC, ((NSString *)[_contacts.allKeys objectAtIndex:indexPath.row]).UTF8String);*/
    
    LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
                                                                  LC, ((NSString *)callno).UTF8String);
    if (!room) {
        [PhoneMainView.instance popCurrentView];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid address", nil)
                                                                         message:NSLocalizedString(@"Please specify the entire SIP address for the chat",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
    } else {
        ChatConversationView *view = VIEW(ChatConversationView);
        [view setChatRoom:room];
        [PhoneMainView.instance popCurrentView];
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        // refresh list of chatrooms if we are using fragment
        if (IPAD) {
            ChatsListView *listView = VIEW(ChatsListView);
            [listView.tableController loadData];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchBar.showsCancelButton = (searchText.length > 0);
    [self reloadDataWithFilter:searchText];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:FALSE animated:TRUE];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:(searchBar.text.length > 0) animated:TRUE];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//-(void)setrazauser:(Contact*)razacontact
//{
//    BOOL contactfound;
//    NSString *userphone;
//    for (NSString *phonenumber in razacontact.phoneNumbers) {
//        if ([[[Razauser SharedInstance]getRazauser] containsObject:phonenumber]) {
//            contactfound=YES;
//            userphone=phonenumber;
//            break;
//        }
//    }
//    
//    if (contactfound) {
//        NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,userphone]];
//        [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (image)
//            {
//                
//            }
//            
//            
//            
//        }];
//    }
//}

-(void)setrazauserimage:(Contact*)razacontact andcell:(UIChatCreateCell*)cellinfo
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
                [cellinfo.avatarImgView setImage:img bordered:NO withRoundedRadius:YES];
                [self setAvatarforraza:img andcontact:razacontact];
                //  cellinfo.image=image;
            }
            else
                //[cellinfo setImage:[FastAddressBook imageForAddress:razacontact thumbnail:YES] bordered:NO withRoundedRadius:YES];
            {
                ABPersonRemoveImageData(razacontact.person, NULL);
                UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
                
                [self setAvatarforraza:nil andcontact:razacontact];
                [cellinfo.avatarImgView setImage:image bordered:NO withRoundedRadius:YES];
                
            }
            
        }];
    }
    else
    {
        UIImage *image = [FastAddressBook imageForContact:razacontact thumbnail:true];
        [cellinfo.avatarImgView setImage:image bordered:NO withRoundedRadius:YES];
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

@end
