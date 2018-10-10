//
//  RazaHelper.h
//  Raza
//
//  Created by Praveen S on 13/03/14.
//  Copyright (c) 2014 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PickerViewControllerDelegate.h"


//#import "iOSNgnStack.h"

typedef enum : NSInteger {
	CARRIER = 0,
	VOIP,
} AlertViewMediaType;

typedef enum ContactsFilterGroup_f
{
	FilterAllFav,
	FilterOnlineFav,
	FilterWiPhoneFav
}
ContactsFilter_f;

typedef enum ContactsDisplayMode_f
{
	Display_Noone,
	Display_ChooseNoForFavorite,
	Display_Search_fav
}
ContactsDisplayMode_r;

@protocol RazaHelperDelegate <NSObject>

-(void)callMadeViaCarrier;

-(void)callMadeViaVOIP;

-(void)callMadeViaCarrierWithParam:(NSString *)remotedestnumber;

@end

@interface RazaHelper : NSObject <UIAlertViewDelegate, NSURLSessionDelegate>{
    
    UIAlertView *callMediaTypeAlertView;
    
	NSMutableDictionary* contacts;
	NSArray* orderedSections;
    
    ContactsFilter_f filterGroup;
	ContactsDisplayMode_r displayMode;
    //NSDictionary *callingInfo;
}

@property(nonatomic, weak)id <RazaHelperDelegate> delegate;

+(NSString *)sliceString:(NSString*)inputString toLength:(NSInteger)maxLength;

+(NSString *)sliceString:(NSString *)targetStr
        withLengthOfWords:(NSInteger)lenOfWords
                fromStart:(NSInteger)noOfCharFromStart
                  fromEnd:(NSInteger)noOfCharFromEnd;

// register account with sip server

+(void)registerAccountToSIPServerWithEmail:(NSString *)email withPassword:(NSString *)password withPhoneNumber:(NSString *)phonenumber;

+(RazaHelper *)sharedInstance;

-(void)presentCallMediaTypeAlertViewWithMessage:(NSString *)message
                                      withTitle:(NSString *)title
                                   withDelegate:(id <RazaHelperDelegate>)delegate;

//-(NSArray *)getAllFavContactsRecordsData;

//-(BOOL)isFavoriteAlreadySetForContact:(NSString *)contact;
//-(NSDictionary *)getFavoriteContactForParticular:(NSString *)favcontactName;

+(NSDictionary *)getStateInfoForStateKey:(NSString *)key withCountry:(NSString *)country;
+(NSString *)getCountryIDForCountryName:(NSString *)countryname;
+(NSString *)formValidURL:(NSString *)urlStringValue;
+(NSString *)getValidPhoneNumberWithString:(NSString *)number;
+(NSString *)getValidPhoneNumberWithStringForLandline:(NSString *)number;
+(NSString *)getValidPhoneNumberWithStringForLandlineminuts:(NSString *)number;
+ (UILabel *)getHeaderLabelWithTitle:(NSString *)title;
@end
