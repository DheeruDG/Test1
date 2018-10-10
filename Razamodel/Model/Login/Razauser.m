//
//  Razauser.m
//  linphone
//
//  Created by umenit on 11/30/16.
//
//

#import "Razauser.h"

@implementation Razauser
+(Razauser*)SharedInstance
{
   static Razauser *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[Razauser alloc] init];
    });
    return __instance;
}
-(void)setRazauser:(NSArray*)allrazauser
{
    
    [[NSUserDefaults standardUserDefaults] setObject:allrazauser forKey:RAZAUSER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setRetrymessageuser:(NSArray*)allrazauser
{
    
    [[NSUserDefaults standardUserDefaults] setObject:allrazauser forKey:RAZAMESSAGEUSERRESEND];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray*)getRazauser
{
    
    NSArray *savedValue = [[NSUserDefaults standardUserDefaults]
                            objectForKey:RAZAUSER];
    return savedValue;
}
//-(OrderedDictionary*)getFormatedRazaUser
//{
//    addressBookMap=[[OrderedDictionary alloc]init];
//    [addressBookMap removeAllObjects];
//
//    for (NSString *addr in LinphoneManager.instance.fastAddressBook.addressBookMap) {
//        Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
//        BOOL add = false;
//        
//        // Do not add the contact directly if we set some filter
////        if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
////            add = false;
////        }
////        if ([FastAddressBook contactHasValidSipDomain:contact]) {
////            add = true;
////        }
////        if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
////            add = true;
////        }
//        
//       // if (moderazauserornot.length) {
//            
//            for (NSString *phone in contact.phoneNumbers) {
//                NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
//                if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
//                    add = true;
//                    break;
//                }
//            }
//            
//       // }
//        
////        if (!add && [ContactSelection emailFilterEnabled]) {
////            // Add this contact if it has an email
////            add = (contact.emails.count > 0);
////        }
//        
//        NSMutableString *name = [self displayNameForContact:contact]
//        ? [[NSMutableString alloc] initWithString:[self displayNameForContact:contact]]
//        : nil;
//        if (add && name != nil) {
//            NSString *firstChar = [[name substringToIndex:1] uppercaseString];
//            
//            // Put in correct subAr
//            if ([firstChar characterAtIndex:0] < 'A' || [firstChar characterAtIndex:0] > 'Z') {
//                firstChar = @"#";
//            }
//            NSMutableArray *subAr = [addressBookMap objectForKey:firstChar];
//            if (subAr == nil) {
//                subAr = [[NSMutableArray alloc] init];
//                [addressBookMap insertObject:subAr forKey:firstChar selector:@selector(caseInsensitiveCompare:)];
//            }
//            NSUInteger idx = [subAr indexOfObject:contact
//                                    inSortedRange:(NSRange){0, subAr.count}
//                                          options:NSBinarySearchingInsertionIndex
//                                  usingComparator:^NSComparisonResult(Contact*  _Nonnull obj1, Contact*  _Nonnull obj2) {
//                                      return [[self displayNameForContact:obj1] compare:[self displayNameForContact:obj2]options:NSCaseInsensitiveSearch];
//                                  }];
//            if (![subAr containsObject:contact]) {
//                [subAr insertObject:contact atIndex:idx];
//            }
//        }
//    }
//    return addressBookMap;
//    //NSLog(@"%@",addressBookMap);
//}
- (void)getformatedrazauser:(NSString *)methodname  callback:(void (^)(OrderedDictionary *addressBookMap, NSError *error))callback
{
    addressBookMap=[[OrderedDictionary alloc]init];
    [addressBookMap removeAllObjects];
    
    for (NSString *addr in [LinphoneManager.instance.fastAddressBook.addressBookMap allKeys]) {
        Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
        BOOL add = false;
        
        // Do not add the contact directly if we set some filter
        //        if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
        //            add = false;
        //        }
        //        if ([FastAddressBook contactHasValidSipDomain:contact]) {
        //            add = true;
        //        }
        //        if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
        //            add = true;
        //        }
        
        // if (moderazauserornot.length) {
        
        for (NSString *phone in contact.phoneNumbers) {
            NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
            if ([[[Razauser SharedInstance]getRazauser] containsObject:numberKey]) {
                add = true;
                break;
            }
        }
        
        // }
        
        //        if (!add && [ContactSelection emailFilterEnabled]) {
        //            // Add this contact if it has an email
        //            add = (contact.emails.count > 0);
        //        }
        
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
            if (![subAr containsObject:contact]) {
                [subAr insertObject:contact atIndex:idx];
            }
        }
    }
    callback( addressBookMap,nil);
    //return addressBookMap;
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
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                                   
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
-(NSString*)getusername:(NSString*)byid
{
    NSString *phones;
    if ([byid containsString:@"@"]) {
        NSArray *arr = [byid componentsSeparatedByString:@"@"];
        if (arr.count>1) {
            NSArray *arr1 = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
            if (arr1.count>1) {
                byid=[arr1 objectAtIndex:1];
                phones=byid;
            }
        }
    }
    else
        phones=nil;
    return phones;
    
}
- (MBProgressHUD *)ShowWaiting:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:20.0];
    return hud;
}
- (MBProgressHUD *)ShowWaitingshort:(NSString *)title andtime:(float)timeperiod {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    [hud hide:YES afterDelay:timeperiod];
    return hud;
}
- (void)HideWaiting {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
-(NSDictionary *)getRazauserORnotWithPhonenumber:(LinphoneAddress *)address
{
char *uri = linphone_address_as_string_uri_only(address);
    NSString *str=[NSString stringWithUTF8String:uri];
  NSString  *phoneNumber=[self getusername:str];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:phoneNumber forKey:@"PHONE"];
    NSArray *razauser=[self getRazauser];
    if ([razauser containsObject:phoneNumber])
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"RAZAUSER"];
    else
         [dict setObject:[NSNumber numberWithBool:NO] forKey:@"RAZAUSER"];
   // LinphoneAddress ee=address;
   // NSData *dd=[[NSData alloc]initWithBytes:address length:address->lengh];
  //  [dict setObject:[NSValue valueWithPointer:&address] forKey:@"RAZAADDRESS"];
   // [dict setObject:dd forKey:@"RAZAADDRESS"];
    NSData *elData = [NSData dataWithBytes:&address length:sizeof(address)];
    [dict setObject:elData forKey:@"RAZAADDRESS"];
    return dict;
}

- (void)getformatedrazauserbyname:(NSString *)methodname  callback:(void (^)(NSDictionary *addressBookMap, NSError *error))callback
{
    NSMutableDictionary *basedict=[[NSMutableDictionary alloc]init];
    for (NSString *addr in [LinphoneManager.instance.fastAddressBook.addressBookMap allKeys]) {
        Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
        BOOL add = false;
        
        // Do not add the contact directly if we set some filter
        //        if ([ContactSelection getSipFilter] || [ContactSelection emailFilterEnabled]) {
        //            add = false;
        //        }
        //        if ([FastAddressBook contactHasValidSipDomain:contact]) {
        //            add = true;
        //        }
        //        if (contact.friend && linphone_presence_model_get_basic_status(linphone_friend_get_presence_model(contact.friend)) == LinphonePresenceBasicStatusOpen){
        //            add = true;
        //        }
        
        // if (moderazauserornot.length) {
        NSString *ph;
        for (NSString *phone in contact.phoneNumbers) {
            NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
            if ([[[Razauser SharedInstance]getRazauser] containsObject:@"7736190191"]) {
                add = true;
                ph=numberKey;
                break;
            }
        }
        
        // }
        
                if (add  ) {
                    // Add this contact if it has an email
                   [basedict setObject:contact forKey:ph];
                }
        
        }
    callback( basedict,nil);
    //return addressBookMap;
}
-(void)setrazauserbyname
{
    [self getformatedrazauserbyname:nil callback:^(NSDictionary *addressBookMap1, NSError *error) {
        if (addressBookMap1) {
            [self setRazauserbyname:addressBookMap1];
        }
    }];
}
-(void)setRazauserbyname:(NSDictionary*)allrazauser
{
    
    [[NSUserDefaults standardUserDefaults] setObject:allrazauser forKey:@"RAZAUSERBYNAM"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary*)getRazauserbyname
{
    
    NSDictionary *savedValue = [[NSUserDefaults standardUserDefaults]
                           objectForKey:@"RAZAUSERBYNAM"];
    return savedValue;
}

-(NSData *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
   // NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
   // NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
    //return [UIImage imageWithData:imageData];
    return imageData;
}
-(NSData*)compresstest:(UIImage *)image
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}
-(void)setContactForPushraza:(NSDictionary*)allrazauser
{
    //NSMutableDictionary *dd=[NSMutableDictionary alloc]ini
    NSDictionary *olddict=[self getContactForPushRaza];
    NSMutableDictionary *newdict;
    if ([olddict allKeys])
    newdict=[[NSMutableDictionary alloc]initWithDictionary:olddict];
    else
    newdict=[[NSMutableDictionary alloc]init];
    [newdict addEntriesFromDictionary:allrazauser];
    [[NSUserDefaults standardUserDefaults] setObject:newdict forKey:RAZAPUSHCONTACT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary*)getContactForPushRaza
{
    
    NSDictionary *savedValue = [[NSUserDefaults standardUserDefaults]
                           objectForKey:RAZAPUSHCONTACT];
    return savedValue;
}
- (NSString *)getContactRazaPush:(NSString *)address {
    NSDictionary *Razapushcontact=[self getContactForPushRaza];
     //address=[NSString stringWithFormat:@"sip:%@@%@",address,MAINRAZASIPURL];
    if (Razapushcontact != nil) {
        @synchronized(Razapushcontact) {
            NSArray *keys=[Razapushcontact allKeys];
            NSString *second= [Razapushcontact objectForKey:address];
            if (!second) {
//                NSArray *arr = [address componentsSeparatedByString:@"sip:"];
//                NSString *mainaddr;
//                if (arr) {
//                    mainaddr=[arr objectAtIndex:1];
//                }
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd]  %@",address];
                //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] %@",mainaddr];
                NSArray *temp = [keys filteredArrayUsingPredicate:resultPredicate];
                if (temp.count) {
                    second=  [Razapushcontact objectForKey:[temp objectAtIndex:0]];
                }
                
            }
            return second;
            //return [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:[temp objectAtIndex:0]];
        }
    }
    return nil;
}
-(void)setPushrazaCounter:(NSString*)senderurl and:(NSString*)addorremove
{
   // NSMutableDictionary *dd=[[NSMutableDictionary alloc]init];
    NSDictionary *olddict=[self getPushrazaCounter];
    NSMutableDictionary *newdict;
    if ([olddict allKeys])
        newdict=[[NSMutableDictionary alloc]initWithDictionary:olddict];
    else
        newdict=[[NSMutableDictionary alloc]init];
    //int counter;
    if (([[newdict objectForKey:senderurl]intValue]>0)&&(addorremove.length)) {
        int newNum = [[newdict objectForKey:senderurl] intValue]+1;
        [newdict setObject:[NSNumber numberWithInt:newNum] forKey:senderurl];
    }
   else if (addorremove.length) {
        int newNum = [[newdict objectForKey:senderurl] intValue]+1;
        [newdict setObject:[NSNumber numberWithInt:newNum] forKey:senderurl];
    }
    else if (!addorremove.length) {
            //int newNum = [[newdict objectForKey:senderurl] intValue]+1;
           // [newdict setObject:[NSNumber numberWithInt:newNum] forKey:senderurl];
        [newdict removeObjectForKey:senderurl];
        }
   // [newdict addEntriesFromDictionary:allrazauser];
    [[NSUserDefaults standardUserDefaults] setObject:newdict forKey:RAZAPUSHCOunter];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSDictionary *dd=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:0],senderurl, nil];
}
-(void)setmissed:(BOOL)yes
{
    if (yes) {
   NSInteger highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"missedcounterpush"] intValue];
        highScore=highScore+1;
        int number = (int)highScore;
   [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:number] forKey:@"missedcounterpush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"missedcounterpush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(int)getmissed
{
    NSInteger highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"missedcounterpush"] intValue];
    //highScore=highScore+1;
    int number = (int)highScore;
    return number;
}
-(NSDictionary*)getPushrazaCounter
{
    
    NSDictionary *savedValue = [[NSUserDefaults standardUserDefaults]
                                objectForKey:RAZAPUSHCOunter];
    return savedValue;
}

-(void)deletepushfromchat:(LinphoneChatRoom *)chatRoom
{
    const LinphoneAddress *addr = linphone_chat_room_get_peer_address(chatRoom);
    char *uri = linphone_address_as_string_uri_only(addr);
    NSString  *userchat=  [NSString stringWithUTF8String:uri];
    [self setPushrazaCounter:userchat and:nil];
}
-(void)addCallToDatabase:(NSString*)modeofcall  andsender:(NSString*)senderurl
{
    sqlite3 *newDb;
   // char *errMsg;
  //NSString *senderurlfornmrmal=senderurl;
    NSString *newDbPath = [LinphoneManager documentFile:@"linphone_chats.db"];
    if (sqlite3_open([newDbPath UTF8String], &newDb) != SQLITE_OK) {
        LOGE(@"Can't open \"%@\" sqlite3 database.", newDbPath);
        //   return FALSE;
    }
    else
    {
        //NSString *from =senderurl;// [notification.userInfo objectForKey:@"from_addr"];
//        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
//        if (room)
//        {
//            linphone_chat_room_mark_as_read(room);
//            
//        }
        NSString *phoneNumber;
        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
        if (default_proxy != NULL)
                        // const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
                        phoneNumber = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
                    if (phoneNumber.length) {
        /*----*/
        senderurl=[NSString stringWithFormat:@"sip:%@@%@",senderurl,MAINRAZASIPURL];
           senderurl = [NSString stringWithFormat:@"\"%@\" <%@>", @"", senderurl];
        //        senderurl = [NSString stringWithFormat:@"%@", senderurlfornmrmal];//senderurl
        //NSString *str = @"some characters \" and \'";
        static const char* sqlStatement = "INSERT INTO call_history(caller,callee,direction,duration,start_time,connected_time,status,videoEnabled,quality,call_id) VALUES(?,?,?,?,?,?,?,?,?,?)";
        sqlite3_stmt *stmt;
        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
        if (sqlite3_prepare_v2(newDb, sqlStatement, -1, &stmt, NULL) == SQLITE_OK) {
            if (modeofcall.length) {
                sqlite3_bind_text(stmt, 1, [phoneNumber UTF8String], -1, SQLITE_TRANSIENT);//phoneNumber-outgoing
                sqlite3_bind_text(stmt, 2, [senderurl UTF8String], -1, SQLITE_TRANSIENT);//senderurl-outgoing
                sqlite3_bind_int(stmt, 3, 0);// 0 outgoing 1 missed
                sqlite3_bind_text(stmt, 7, [@"1" UTF8String], -1, SQLITE_TRANSIENT);// 1 dial 2 missed
            }
            else
            {
            sqlite3_bind_text(stmt, 1, [senderurl UTF8String], -1, SQLITE_TRANSIENT);//phoneNumber-outgoing
            sqlite3_bind_text(stmt, 2, [phoneNumber UTF8String], -1, SQLITE_TRANSIENT);//senderurl-outgoing
            sqlite3_bind_int(stmt, 3, 1);// 0 outgoing 1 missed
            sqlite3_bind_text(stmt, 7, [@"2" UTF8String], -1, SQLITE_TRANSIENT);// 1 dial 2 missed
            }
            sqlite3_bind_text(stmt, 4, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int64(stmt, 5, unixTime);
            sqlite3_bind_text(stmt, 6, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
           // sqlite3_bind_text(stmt, 7, [@"2" UTF8String], -1, SQLITE_TRANSIENT);// 1 dial 2 missed
            sqlite3_bind_int(stmt, 8, 0);
             sqlite3_bind_text(stmt, 9, [@"-1" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 10, [[self randomStringWithLength:10] UTF8String], -1, SQLITE_TRANSIENT);//@"o-zA2cPyXl"
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(newDb));
            }
        } else {
            NSLog(@"SQL prepare failed: %s", sqlite3_errmsg(newDb));
        }
        /*-=*/
        
//        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
//        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
//        NSString *phoneNumber;
//        senderurl=[NSString stringWithFormat:@"sip:%@@%@",senderurl,MAINRAZASIPURL];
//        //senderurl = [NSString stringWithFormat:@"\"%@\" <%@>", senderurlfornmrmal, senderurl];
//        senderurl = [NSString stringWithFormat:@"%@", senderurlfornmrmal];//senderurl
//        // [[Razauser SharedInstance]setPushrazaCounter:senderurl and:@"yes"];
//        if (default_proxy != NULL)
//            // const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
//            phoneNumber = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
//        if (phoneNumber.length) {
//            const char *migration_statement ;
//            
//            migration_statement = [[NSString stringWithFormat: @"INSERT INTO call_history (caller,callee,direction,duration,start_time,connected_time,status,quality,call_id) VALUES (\"%@\",\"\"%@\"\",\"%@\",\"%@\",\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\")", phoneNumber,senderurl,@"0",@"0",unixTime,@"0",@"1",@"-1",@"iAn34Adj5"]UTF8String];
//            
//            //            migration_statement= "INSERT INTO history (localContact,remoteContact,direction,message,utc,read,status,time) VALUES ('sip:6308156160@razasip.voipxonline.com','sip:6304791564@razasip.voipxonline.com','0','willwork','1483455389','1','2','-1')";
//            if (sqlite3_exec(newDb, migration_statement, NULL, NULL, &errMsg) != SQLITE_OK) {
//                LOGE(@"DB migration failed, error[%s] ", errMsg);
//                sqlite3_free(errMsg);
//                
//            }
       }
        sqlite3_close(newDb);
    }
}
-(BOOL)chkforsimGlobal
{
    BOOL chksim=YES;
    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = info.subscriberCellularProvider;
    
    if(carrier.mobileNetworkCode == nil || [carrier.mobileNetworkCode isEqualToString:@""])
    {
       // chkforsimcard=@"not found";
        chksim=NO;
    }
    
    return chksim;
}


-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}
-(void)setRazaimageforimage:(UIRoundedImageView*)imgview andstringname:(NSString*)str andthumbornot:(NSString*)param
{
    NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",param,str]];
    [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
        if (image)
        {
            NSData *imageData =[[Razauser SharedInstance] compressImage:image];
            UIImage *img=[UIImage imageWithData:imageData];
           // imgview.image=img;
           [imgview setImage:img bordered:NO withRoundedRadius:YES];
            // [self setAvatarforraza:img andcontact:razacontact];
            //  cellinfo.image=image;
        }
        else
        {
            UIImage *img=[UIImage imageNamed:@"avatar_male.png"];
            [imgview setImage:img bordered:NO withRoundedRadius:YES];
            //avatar_male.png
        }
     }];
}

-(void)setsidebar:(NSString*)length
{
    
    if (length.length) {
        [[NSUserDefaults standardUserDefaults] setObject:length forKey:RAZASIDEBARLENGTH];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:RAZASIDEBARLENGTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(NSString*)getsidebar
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:RAZASIDEBARLENGTH];
    return str;
}
//getRazaUserBySearch   getformatedrazauserbyname
- (void)getRazaUserBySearch:(NSString *)name  callback:(void (^)(OrderedDictionary *addressBookMap, NSError *error))callback
{
    addressBookMap=[[OrderedDictionary alloc]init];
    [addressBookMap removeAllObjects];
    for (NSString *addr in [LinphoneManager.instance.fastAddressBook.addressBookMap allKeys]) {
        Contact *contact = [LinphoneManager.instance.fastAddressBook.addressBookMap objectForKey:addr];
        BOOL add = false;
        
        NSString *ph;
        for (NSString *phone in contact.phoneNumbers) {
            NSString *numberKey = [RazaHelper getValidPhoneNumberWithString:phone];
            if ([[[Razauser SharedInstance]getRazauser] containsObject:name]) {
                add = true;
                ph=numberKey;
                break;
            }
        }
        
        if (add  ) {
            [addressBookMap setObject:contact forKey:ph];
        }
        
    }
    callback( addressBookMap,nil);
    //return addressBookMap;
}

@end
