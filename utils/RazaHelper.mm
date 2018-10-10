//
//  RazaHelper.m
//  Raza
//
//  Created by Kongsberg on 13/03/14.
//  Copyright (c) 2014 Raza. All rights reserved.
//

#import "RazaHelper.h"

//#import "iOSNgnStack.h"

static RazaHelper *sharedInstance = nil;

@implementation RazaHelper

+(void)initialize {
    sharedInstance = [[RazaHelper alloc]init];
}

+(RazaHelper *)sharedInstance {
    return sharedInstance;
}

-(id)init {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

+ (NSString *)sliceString:(NSString*)inputString toLength:(NSInteger)sliceLength
{
    if (IS_EMPTY(inputString)) {
        return inputString;
    }
    
    if ([inputString length] <= sliceLength)
        return inputString;
    
    return [inputString substringToIndex:sliceLength];
    
    //    NSMutableString* outputString = [[NSMutableString alloc] initWithString:inputString];
    //    int extraChars = outputString.length - maxLength;
    //    
    //    [outputString replaceCharactersInRange:NSMakeRange((inputString.length - extraChars)/2, extraChars) withString:@""];
    
}

+ (NSString *)sliceString:(NSString *)targetStr withLengthOfWords:(NSInteger)lenOfWords fromStart:(NSInteger)noOfCharFromStart fromEnd:(NSInteger)noOfCharFromEnd
{
    if (targetStr && noOfCharFromStart > 1) {
        if ([targetStr length]>lenOfWords) {
            NSString *firstStr = [targetStr substringWithRange:NSMakeRange(0, noOfCharFromStart)];
            NSString *lastStr = [targetStr substringWithRange:NSMakeRange([targetStr length]-noOfCharFromEnd, 2)];
            targetStr = [NSString stringWithFormat:@"%@ %@",firstStr, lastStr];
        }
    }
    
    
    return targetStr;
}

-(void)presentCallMediaTypeAlertViewWithMessage:(NSString *)message
                                      withTitle:(NSString *)title
                                   withDelegate:(id <RazaHelperDelegate>)delegate {
    
    self.delegate = delegate;
    
    if (callMediaTypeAlertView)
        callMediaTypeAlertView = nil;
    
    callMediaTypeAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Carrier", @"Landline", nil];
    
    [callMediaTypeAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case CARRIER:
            //
            [[self delegate] callMadeViaCarrier];
            
            break;
            
        case VOIP:
            //
            
            //--- enable this for VOIP functionality
            [[self delegate] callMadeViaVOIP];
            // ----
            
            //            NSString *errorMessage = @"Coming Soon!!";
            //            NSString *alertTitle = @"VOIP Calling";
            //            [RAZA_APPDELEGATE showAlertWithMessage:errorMessage withTitle:alertTitle withCancelTitle:@"OK"];
            
            break;
            
            //default:
            //  break;
    }
}

//-(BOOL)isFavoriteAlreadySetForContact:(NSString *)contact {
//    
//    NSDictionary *favoriteContact = [self getFavoriteContactForParticular:contact];
//    
//    return favoriteContact ? YES : NO;
//}

//-(NSArray *)getAllFavContactsRecordsData {
//    
//    if (!contacts) {
//        contacts = [NSMutableDictionary dictionary];
//    }
//    
//	@synchronized(contacts){
//        
//		[contacts removeAllObjects];
//        
//		/*NgnContactMutableArray* contacts_ = (NSMutableArray *) [[NgnEngine sharedInstance].contactService contacts];
//        
//        return [self getOrderedSectionsOfContacts:contacts_ withSearchString:@""];*/
//        
//        NgnContactMutableArray* favorites_ = (NSMutableArray *) [[[[NgnEngine sharedInstance].storageService favorites] allValues] sortedArrayUsingSelector:@selector(compareFavoriteByDisplayName:)];
//        
//        return [self getOrderedSectionsOfContacts:favorites_];
//	}
//}

//-(NSDictionary *)getFavoriteContactForParticular:(NSString *)favcontactName {
//    
////    if (!contacts) {
////        contacts = [NSMutableDictionary dictionary];
////    }
//    
//    NgnContactMutableArray* favorites_ = (NSMutableArray *) [[[[NgnEngine sharedInstance].storageService favorites] allValues] sortedArrayUsingSelector:@selector(compareFavoriteByDisplayName:)];
//    
//    //NSArray *favContacts = [self getOrderedSectionsOfContacts:favorites_];
//    
//    for (NgnFavorite* contact in favorites_) {
//        
//        if (contact && [contact.displayName isEqualToString:favcontactName]) {
//            return [NSDictionary dictionaryWithObject:contact forKey:@"FavoriteContact"];
//        }
////        
////        if(!contact || [NgnStringUtils isNullOrEmpty: contact.displayName] || (![NgnStringUtils isNullOrEmpty:favcontactName] && [contact.displayName rangeOfString:favcontactName  options:NSCaseInsensitiveSearch].location == NSNotFound)){
////            return NO;
////        }
////        else {
////            return YES;
////        }
//    }
//    
//    return nil;
//}

//-(NSArray *)getOrderedSectionsOfContacts:(NgnContactMutableArray *)contacts_  {
//    
//    if (!contacts_ || ![contacts_ count]) {
//        return [NSMutableArray array];
//    }
//    else {
//        
//        NSString *lastGroup = @"$", *group;
//		NSMutableArray* lastArray = nil;
//		for (NgnContact* contact in contacts_) {
//			if(!contact || [NgnStringUtils isNullOrEmpty: contact.displayName] || (![NgnStringUtils isNullOrEmpty: @""] && [contact.displayName rangeOfString:@""  options:NSCaseInsensitiveSearch].location == NSNotFound)){
//				continue;
//			}
//			// filter: FIXME
//			if(filterGroup != FilterAllFav){
//				continue;
//			}
//			
//			group = [contact.displayName substringToIndex: 1];
//			if([group caseInsensitiveCompare: lastGroup] != NSOrderedSame){
//				lastGroup = group;
//				// NSLog(@"group=%@", group);
//				lastArray = [[NSMutableArray alloc] init];
//				[contacts setObject: lastArray forKey: lastGroup];
//			}
//			[lastArray addObject: contact];
//		}
//		
//        NSArray *contactsInOrder = [[contacts allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        return contactsInOrder;
//        
//    }
//    
//    return nil;
//    
//}


+(NSDictionary *)getStateInfoForStateKey:(NSString *)key withCountry:(NSString *)country {
    
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"StateList" ofType:@"plist"];
    
    if (pListPath && [pListPath length]) {
        
        NSDictionary *statePlistInfo = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
        
        NSDictionary *stateInfo = [statePlistInfo objectForKey:country];
        
        NSString *stateValue = [stateInfo objectForKey:key];
        
        stateInfo = [NSDictionary dictionaryWithObjectsAndKeys:stateValue, key, nil];
        
        return stateInfo;
    }
    return nil;
}

+(NSString *)getCountryIDForCountryName:(NSString *)countryname {
    
    NSString *countryId = @"1";
    
    if ([countryname isEqualToString:@"CANADA"]) {
        countryId = @"2";
    }
    return countryId;
}

+(void)registerAccountToSIPServerWithEmail:(NSString *)email withPassword:(NSString *)password withPhoneNumber:(NSString *)phonenumber {
    
    //    NSString *reqUrlStr = @"http://216.178.227.66/jsonWS/AddSipUser.php";
    //
    //    NSURL *url = [NSURL URLWithString:[reqUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //
    //    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    //self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //
    //    NSError *error;
    //
    //    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    //
    //    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: nil];
    //
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
    //                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
    //                                                       timeoutInterval:60.0];
    //
    //    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    //    [request setHTTPMethod:@"POST"];
    //    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:@"TEST IOS", @"email_address",
    //                             @"IOS TYPE", @"password", @"", @"phone_number", nil];
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    [request setHTTPBody:postData];
    //
    //
    //    NSURLSessionDataTask *postDataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //
    //    }];
    //
    //    [postDataTask resume];
    
    
    //  NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //    NSString *sipAddress = [RazaHelper formValidURL:DEFAULT_SIP_ADDRESS];
    //    
    //    NSString *params = [NSString stringWithFormat:@"?email_address=%@&password=%@&phone_number=%@&device_token=%@",email, password, phonenumber, RAZA_APPDELEGATE.deviceID];
    //    
    //    NSString *urlStringAddSipUser = [[sipAddress stringByAppendingString:API_SIPUSER_WITH_DEVICE] stringByAppendingString:params];
    //    
    //    NSURL *url = [NSURL URLWithString:urlStringAddSipUser];
    //    
    ////    NSString *urlString = [NSString stringWithFormat:@"http://216.178.227.66/jsonWS/AddSipUser.php?email_address=%@&password=%@&phone_number=%@", email, password, phonenumber];
    //    
    //    
    //    
    //    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
    //                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //                                                        if(error == nil)
    //                                                        {
    //                                                            //implementation goes here
    //                                                            NSString * reponseString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //                                                            NSLog(@"Data = %@",reponseString);
    //                                                        }
    //                                                        else {
    //                                                            NSLog(@"ERROR in registerAccountWithSIPServer %@", [error localizedDescription]);
    //                                                        }
    //                                                        
    //                                                    }];
    //    
    //    [dataTask resume];
}

#pragma mark -
#pragma mark Utility methods

+(NSString *)formValidURL:(NSString *)urlStringValue
{
    // Replace invalid characters to their respective percent encoding.
    NSString *urlString = [urlStringValue stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    if (!urlString)
        return @"";
    
    // Validate url regex and separate components
    NSRegularExpression* urlRegex = [NSRegularExpression
                                     regularExpressionWithPattern:@"(https?)?(://)?([a-zA-Z0-9\\.]+[a-zA-Z0-9\\.-]+[a-zA-Z0-9\\.]+)(/)?(.+)?"
                                     options:0 error:NULL];
    NSRange urlRange = NSMakeRange(0, [urlString length]);
    NSTextCheckingResult* urlMatch = [urlRegex firstMatchInString:urlString options:0 range:urlRange];
    
    NSRange schemeRange = [urlMatch rangeAtIndex:1];
    NSRange hostRange = [urlMatch rangeAtIndex:3];
    //NSRange pathRange = [urlMatch rangeAtIndex:5];
    
    NSString *schemeStr = (schemeRange.location != NSNotFound && schemeRange.length != 0) ? [urlString substringWithRange:schemeRange] : DEFAULT_HTTP_SCHEME;
    NSString *hostStr = (hostRange.location != NSNotFound && hostRange.length != 0) ? [urlString substringWithRange:hostRange] : nil;
    //pathStr = (pathRange.location != NSNotFound && pathRange.length != 0) ? [urlString substringWithRange:pathRange] : nil;
    
    //schemeStr = schemeStr ? schemeStr : @"https";
    //    NSString *defaultPath = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DefaultServicePath"];
    //    pathStr = pathStr ? pathStr : defaultPath;
    
    NSString *finalURL = hostStr ? [NSString stringWithFormat:@"%@://%@/", schemeStr, hostStr] : @"";
    
    //NSLog(@"finalURL %@",finalURL);
    
    return finalURL;
}

+(NSString *)getValidPhoneNumberWithString:(NSString *)number {
    
    //    NSCharacterSet *wildCharSet = [NSCharacterSet characterSetWithCharactersInString:@",-{}[]=+&^#().*"];
    //    
    //    NSString *numberWithoutSpace = [[number componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
    //                                    componentsJoinedByString:@""];
    //    
    //    NSString *numberKey = [[numberWithoutSpace componentsSeparatedByCharactersInSet:wildCharSet] componentsJoinedByString:@""];
    
    NSString *numberKey = [number stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [number length])];
    
    if (!numberKey || IS_EMPTY(numberKey)) {
        NSAssert(IS_EMPTY(numberKey), @"Should be valid number");
        return nil;
    }
    int   numberlength  =  (int)[numberKey length];
    if (numberlength > 10)
    {
        NSRange range = NSMakeRange(numberlength - 10, 10);
        numberKey = [numberKey substringWithRange:range];
        // NSLog(@"---->>>>>>>%@",numberKey);
    }
    return numberKey;
}


+(NSString *)getValidPhoneNumberWithStringForLandline:(NSString *)number {
    
    //    NSCharacterSet *wildCharSet = [NSCharacterSet characterSetWithCharactersInString:@",-{}[]=&^#().*"];
    //
    //    
    //    NSString *numberWithoutSpace = [[number componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
    //                                    componentsJoinedByString:@""];
    //    
    //    NSString *numberKey = [[numberWithoutSpace componentsSeparatedByCharactersInSet:wildCharSet] componentsJoinedByString:@""];
    
    NSString *numberKey = [number stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@"00"];
    
    numberKey = [numberKey stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [numberKey length])];
    
    
    
    if (!numberKey || IS_EMPTY(numberKey)) {
        NSAssert(IS_EMPTY(numberKey), @"Should be valid number");
        return nil;
    }
    
    return numberKey;
}
+(NSString *)getValidPhoneNumberWithStringForLandlineminuts:(NSString *)number {
    
    //    NSCharacterSet *wildCharSet = [NSCharacterSet characterSetWithCharactersInString:@",-{}[]=&^#().*"];
    //
    //
    //    NSString *numberWithoutSpace = [[number componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
    //                                    componentsJoinedByString:@""];
    //
    //    NSString *numberKey = [[numberWithoutSpace componentsSeparatedByCharactersInSet:wildCharSet] componentsJoinedByString:@""];
    
    NSString *numberKey =number;// [number stringByReplacingOccurrencesOfString:@"+"
    //  withString:@"00"];
    
    numberKey = [numberKey stringByReplacingOccurrencesOfString:@"[^0-9 +]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [numberKey length])];
    
    
    
    if (!numberKey || IS_EMPTY(numberKey)) {
        NSAssert(IS_EMPTY(numberKey), @"Should be valid number");
        return nil;
    }
    
    return numberKey;
}


+ (UILabel *)getHeaderLabelWithTitle:(NSString *)title
{
    if ([title length] > 20) {
        title = [[title substringWithRange:NSMakeRange(0, 15)] stringByAppendingString:@".."];
    }
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 150)];
    headerLabel.text = title;
    return headerLabel;
}

@end
