/* FastAddressBook.h
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
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
#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import "FastAddressBook.h"
#import "LinphoneManager.h"
#import "ContactsListView.h"
#import "Utils.h"

@implementation FastAddressBook {
	ABAddressBookRef addressBook;
	CNContactStore* store;
}

static void sync_address_book(ABAddressBookRef addressBook, CFDictionaryRef info, void *context);

+ (UIImage *)imageForContact:(Contact *)contact thumbnail:(BOOL)thumbnail {
   
	UIImage *retImage = [contact avatar:thumbnail];
	if (retImage == nil) {
        UIImage *cnimage;
        if (contact.firstName.length>2)
            cnimage=[UIImage imageNamed:[[[contact.firstName substringToIndex:1] uppercaseString] stringByAppendingString:@".png"]];
        if (cnimage)
            retImage=cnimage;
        else
		retImage = [UIImage imageNamed:@"avatar_male.png"];
	}
	if (retImage.size.width != retImage.size.height) {
		retImage = [retImage squareCrop];
	}
	return retImage;
}

+ (UIImage *)imageForAddress:(const LinphoneAddress *)addr thumbnail:(BOOL)thumbnail {
	if ([LinphoneManager isMyself:addr] && [LinphoneUtils hasSelfAvatar]) {
		return [LinphoneUtils selfAvatar];
	}
	return [FastAddressBook imageForContact:[FastAddressBook getContactWithAddressRaza:addr] thumbnail:thumbnail];//
    //getContactWithAddressRaza getContactWithAddress
}

+ (Contact *)getContact:(NSString *)address {
	if (LinphoneManager.instance.fastAddressBook != nil) {
		@synchronized(LinphoneManager.instance.fastAddressBook.addressBookMap) {
            NSArray *keys=[LinphoneManager.instance.fastAddressBook.addressBookMap allKeys];
           NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] %@",@"4167271966@razasip.voipxonline.com"];
            NSArray *temp = [keys filteredArrayUsingPredicate:resultPredicate];
            NSLog(@"%@",temp);
			return [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:address];
		}
	}
	return nil;
}

+ (Contact *)getContactWithAddress:(const LinphoneAddress *)address {
	Contact *contact = nil;
	if (address) {
		char *uri = linphone_address_as_string_uri_only(address);
		NSString *normalizedSipAddress = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:uri]];
		contact = [FastAddressBook getContact:normalizedSipAddress];
		ms_free(uri);
	}
	return contact;
}

+ (BOOL)isSipURI:(NSString *)address {
	return [address hasPrefix:@"sip:"] || [address hasPrefix:@"sips:"];
}

+ (NSString *)normalizeSipURI:(NSString *)address {
	// replace all whitespaces (non-breakable, utf8 nbsp etc.) by the "classical" whitespace
    if (LC!=NULL) {
        
    
	NSString *normalizedSipAddress = [[address
		componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@" "];
	LinphoneAddress *addr = linphone_core_interpret_url(LC, [address UTF8String]);
	if (addr != NULL) {
		linphone_address_clean(addr);
		char *tmp = linphone_address_as_string(addr);
		normalizedSipAddress = [NSString stringWithUTF8String:tmp];
		ms_free(tmp);
		linphone_address_destroy(addr);
	}
	return normalizedSipAddress;
        }
    else
        return nil;
}

+ (BOOL)isAuthorized {
	return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
}

- (FastAddressBook *)init {
	if ((self = [super init]) != nil) {
		_addressBookMap = [NSMutableDictionary dictionary];
		addressBook = nil;
		[self reload];
	}
	self.needToUpdate = FALSE;
	if ([CNContactStore class]) {
		//ios9 or later
		CNEntityType entityType = CNEntityTypeContacts;
		if([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined) {
			CNContactStore * contactStore = [[CNContactStore alloc] init];
			[contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
				if(granted){
					NSError* contactError;
					store = [[CNContactStore alloc]init];
					[store containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[store.defaultContainerIdentifier]] error:&contactError];
					NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
					CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
					BOOL success = [store enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){}];
					if(success) {
						LOGD(@"CNContactStore successfully synchronized");
					}
				}
			}];
		} else if([CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized) {
			NSError* contactError;
			store = [[CNContactStore alloc]init];
			[store containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[store.defaultContainerIdentifier]] error:&contactError];
			NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
			CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
			BOOL success = [store enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){}];
			if(success) {
				LOGD(@"CNContactStore successfully synchronized");
			}
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAddressBook:) name:CNContactStoreDidChangeNotification object:nil];
	}
	
	return self;
}

- (void)saveAddressBook {
	if (addressBook != nil) {
		if (!ABAddressBookSave(addressBook, nil)) {
			LOGW(@"Couldn't save Address Book");
		}
	}
}

- (void)reload {
	CFErrorRef error;

	// create if it doesn't exist
	if (addressBook == nil) {
		addressBook = ABAddressBookCreateWithOptions(NULL, &error);
	}

	if (addressBook != nil) {
		__weak FastAddressBook *weakSelf = self;
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
			if (!granted) {
				LOGE(@"Permission for address book acces was denied: %@", [(__bridge NSError *)error description]);
				return;
			}

			ABAddressBookRegisterExternalChangeCallback(addressBook, sync_address_book, (__bridge void *)(weakSelf));
			[weakSelf loadData];

		});
	} else {
		LOGE(@"Create AddressBook failed, reason: %@", [(__bridge NSError *)error localizedDescription]);
	}
}

-(void) updateAddressBook:(NSNotification*) notif {
	LOGD(@"address book has changed");
	self.needToUpdate = TRUE;
}

- (void)registerAddrsFor:(Contact *)contact {
     if (LC!=NULL) {
	for (NSString *phone in contact.phoneNumbers) {
       
        NSLog(@"%@",[RAZA_USERDEFAULTS objectForKey:@"logininfo"]);
        
        
		char *normalizedPhone =
			linphone_proxy_config_normalize_phone_number(linphone_core_get_default_proxy_config(LC), phone.UTF8String);
		NSString *name =
			[FastAddressBook normalizeSipURI:normalizedPhone ? [NSString stringWithUTF8String:normalizedPhone] : phone];
		if (phone != NULL) {
			[_addressBookMap setObject:contact forKey:(name ?: [FastAddressBook localizedLabel:phone])];
           
		}
		if (normalizedPhone)
			ms_free(normalizedPhone);
	}
	for (NSString *sip in contact.sipAddresses) {
        
		[_addressBookMap setObject:contact forKey:([FastAddressBook normalizeSipURI:sip] ?: sip)];
	}
    }
}
static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}
- (void)loadData {
	@synchronized(_addressBookMap) {
		ABAddressBookRevert(addressBook);
		[_addressBookMap removeAllObjects];

		// load native contacts
		CFArrayRef lContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
		CFIndex count = CFArrayGetCount(lContacts);
		for (CFIndex idx = 0; idx < count; idx++) {
			ABRecordRef lPerson = CFArrayGetValueAtIndex(lContacts, idx);
			Contact *contact = [[Contact alloc] initWithPerson:lPerson];
//            if (contact.phoneNumbers) {
//                
//            }
//            NSMutableArray *srr=[[NSMutableArray alloc]init];
//            for (NSString *str in contact.phoneNumbers) {
//                
//                if (str.length<=10) {
//                    NSString *cc;
//                    cc=[NSString stringWithFormat:@"+1%@",str];
//                    [srr addObject:cc];
//                }
//                else
//                    [srr addObject:str];
//            }
//            contact.phoneNumbers=srr;
			[self registerAddrsFor:contact];
            
		}
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
        NSDictionary *oldpushraza=[[Razauser SharedInstance] getContactForPushRaza];
        if ([oldpushraza allKeys]<[_addressBookMap allKeys]) {
            for (NSString* key in [_addressBookMap allKeys]) {
                Contact *value = [_addressBookMap objectForKey:key];
                // do stuff
                
                
                NSDictionary *dd=[[NSDictionary alloc]initWithObjectsAndKeys:[self getname:value.firstName andsecondname:value.lastName andphone:@""],key,nil];
                //  [dict setObject:contact.firstName forKey:@"firstname"]
                [[Razauser SharedInstance] setContactForPushraza:dd];
            }
        }
        
        });
        
//       NSDictionary *dd= [[Razauser SharedInstance]getContactForPushRaza];
//        if (dd.allKeys<_addressBookMap.allKeys) {
//            NSArray *keys=_addressBookMap.allKeys;
//            for (int i=0; i<keys.count; i++) {
//                Contact *razacontact=[_addressBookMap objectForKey:i];
//            }
           // [[Razauser SharedInstance] setContactForPushraza:_addressBookMap];
        //}
		CFRelease(lContacts);
        if (LC!=NULL) {
            
        
		// load Linphone friends
		const MSList *lists = linphone_core_get_friends_lists(LC);
		while (lists) {
			LinphoneFriendList *fl = lists->data;
			const MSList *friends = linphone_friend_list_get_friends(fl);
			while (friends) {
				LinphoneFriend *f = friends->data;
				// only append friends that are not native contacts (already added above)
				if (linphone_friend_get_ref_key(f) == NULL) {
					Contact *contact = [[Contact alloc] initWithFriend:f];
					[self registerAddrsFor:contact];
				}
				friends = friends->next;
			}
			linphone_friend_list_update_subscriptions(fl);
			lists = lists->next;
		}
            }
	}
	[NSNotificationCenter.defaultCenter postNotificationName:kLinphoneAddressBookUpdate object:self];
}

void sync_address_book(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
	FastAddressBook *fastAddressBook = (__bridge FastAddressBook *)context;
	[fastAddressBook loadData];
}

- (void)dealloc {
	ABAddressBookUnregisterExternalChangeCallback(addressBook, sync_address_book, (__bridge void *)(self));
	CFRelease(addressBook);
}

#pragma mark - Tools

+ (NSString *)localizedLabel:(NSString *)label {
	if (label != nil) {
		return CFBridgingRelease(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(label)));
	}
	return @"";
}

+ (BOOL)contactHasValidSipDomain:(Contact *)contact {
	if (contact == nil)
		return NO;

	// Check if one of the contact' sip URI matches the expected SIP filter
	NSString *domain = LinphoneManager.instance.contactFilter;

	for (NSString *sip in contact.sipAddresses) {
		// check domain
		LinphoneAddress *address = linphone_core_interpret_url(LC, sip.UTF8String);
		if (address) {
			const char *dom = linphone_address_get_domain(address);
			BOOL match = false;
			if (dom != NULL) {
				NSString *contactDomain = [NSString stringWithCString:dom encoding:[NSString defaultCStringEncoding]];
				match = (([domain compare:@"*" options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
						 ([domain compare:contactDomain options:NSCaseInsensitiveSearch] == NSOrderedSame));
			}
			linphone_address_destroy(address);
			if (match)
				return YES;
		}
	}
	return NO;
}

+ (BOOL) isSipURIValid:(NSString*)addr {
	NSString *domain = LinphoneManager.instance.contactFilter;
	LinphoneAddress* address = linphone_core_interpret_url(LC, addr.UTF8String);
	if (address) {
		const char *dom = linphone_address_get_domain(address);
		BOOL match = false;
		if (dom != NULL) {
			NSString *contactDomain = [NSString stringWithCString:dom encoding:[NSString defaultCStringEncoding]];
			match = (([domain compare:@"*" options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
					 ([domain compare:contactDomain options:NSCaseInsensitiveSearch] == NSOrderedSame));
		}
		linphone_address_destroy(address);
		if (match) {
			return YES;
		}
	}
	return NO;
}

+ (NSString *)displayNameForContact:(Contact *)contact {
	return contact.displayName;
}

+ (NSString *)displayNameForAddress:(const LinphoneAddress *)addr {
	NSString *ret = NSLocalizedString(@"Unknown", nil);
	Contact *contact = [FastAddressBook getContactWithAddress:addr];
	if (contact) {
		ret = [FastAddressBook displayNameForContact:contact];
	} else {
		const char *lDisplayName = linphone_address_get_display_name(addr);
		const char *lUserName = linphone_address_get_username(addr);
		if (lDisplayName) {
			ret = [NSString stringWithUTF8String:lDisplayName];
		} else if (lUserName) {
			ret = [NSString stringWithUTF8String:lUserName];
		}
	}
	return ret;
}

- (int)removeContact:(Contact *)contact {
	// Remove contact from book
	if (contact.person && ABRecordGetRecordID(contact.person) != kABRecordInvalidID) {
		CFErrorRef error = NULL;
		ABAddressBookRemoveRecord(addressBook, contact.person, (CFErrorRef *)&error);
		if (error != NULL) {
			LOGE(@"Remove contact %p: Fail(%@)", contact, [(__bridge NSError *)error localizedDescription]);
		} else {
			LOGI(@"Remove contact %p: Success!", contact);
		}
		contact = NULL;
		// Save address book
		error = NULL;
		ABAddressBookSave(addressBook, (CFErrorRef *)&error);

		// TODO: stop reloading the whole address book but just clear the removed entries!
		[self loadData];

		if (error != NULL) {
			LOGE(@"Save AddressBook: Fail(%@)", [(__bridge NSError *)error localizedDescription]);
		} else {
			LOGI(@"Save AddressBook: Success!");
		}
		return error ? -1 : 0;
	}
	return -2;
}

- (BOOL)saveContact:(Contact *)contact {
	CFErrorRef error = NULL;
	if (ABRecordGetRecordID(contact.person) == kABRecordInvalidID) {
		if (ABAddressBookAddRecord(addressBook, contact.person, (CFErrorRef *)&error)) {
			LOGI(@"Add contact %p: Success!", contact.person);
		} else {
			LOGE(@"Add contact %p: Fail(%@)", contact.person, [(__bridge NSError *)error localizedDescription]);
			return FALSE;
		}
	}

	// Save address book
	error = NULL;
	if (ABAddressBookSave(addressBook, &error)) {
		LOGI(@"Save AddressBook: Success!");
	} else {
		LOGE(@"Save AddressBook: Fail(%@)", [(__bridge NSError *)error localizedDescription]);
		return FALSE;
	}
	[self reload];

	return error == NULL;
}
+ (Contact *)getContactRaza:(NSString *)address {
    if (LinphoneManager.instance.fastAddressBook != nil) {
        @synchronized(LinphoneManager.instance.fastAddressBook.addressBookMap) {
            address = [address stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            NSArray *keys=[LinphoneManager.instance.fastAddressBook.addressBookMap allKeys];
            //sip:6304791564@razasip.voipxonline.com
//            NSString *numberStr=[address stringByReplacingOccurrencesOfString:@"sip:" withString:@""];
//            numberStr=[numberStr stringByReplacingOccurrencesOfString:@"@razasip.voipxonline.com" withString:@""];
//            for (NSString *numStr in keys) {
//                if ([numStr containsString:numberStr]) {
//                    address=numStr;
//                }
//            }
       
        Contact *second= [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:address];
            
            if (!second) {
                NSArray *arr = [address componentsSeparatedByString:@"sip:"];
                NSString *mainaddr;
                if (arr) {
                    mainaddr=[arr objectAtIndex:1];
                }
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] %@",mainaddr];
                NSArray *temp = [keys filteredArrayUsingPredicate:resultPredicate];
                if (temp.count) {
                    second=  [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:[temp objectAtIndex:0]];
                }
                else
                {
                    NSArray *arr = [address componentsSeparatedByString:@"@"];
                    NSArray *arr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@"sip:"];
                    NSString *str = [arr2 objectAtIndex:1];
                    if (str.length>=10) {
                        NSString *newStr =[str substringFromIndex: [str length] - 10];
                        NSLog(@"%@",newStr);
                        NSString *searchstring=[NSString stringWithFormat:@"%@%@",newStr,MAINRAZASIPURL];
                        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] %@",searchstring];
                        NSArray *temp = [keys filteredArrayUsingPredicate:resultPredicate];
                        if (temp.count) {
                            second=  [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:[temp objectAtIndex:0]];
                        }
                        NSLog(@"%@",temp);
                    }
                    
                }
              
            }
            
            return second;
            //return [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:[temp objectAtIndex:0]];
        }
    }
    return nil;
}
+ (Contact *)getContactWithAddressRaza:(const LinphoneAddress *)address {
    Contact *contact = nil;
    if (address) {
        char *uri = linphone_address_as_string_uri_only(address);
        NSString *normalizedSipAddress = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:uri]];
        //normalizedSipAddress=[RazaHelper getValidPhoneNumberWithString:normalizedSipAddress];
        contact = [FastAddressBook getContactRaza:normalizedSipAddress];
        ms_free(uri);
    }
    return contact;
}

-(NSString*)getname:(NSString *)firstname andsecondname:(NSString*)secondname andphone:(NSString*)phone
{
    NSString *callednumber;
    if (firstname&&secondname)
        callednumber=[NSString stringWithFormat:@"%@ %@",firstname,secondname];
    else if (firstname)
        callednumber=firstname;
    else if (secondname)
        callednumber=secondname;
    else
        callednumber= @"NA";
    return callednumber;
}
@end
