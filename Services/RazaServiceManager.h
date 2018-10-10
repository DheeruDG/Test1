//
//  RazaServiceManager.h
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RazaDataModel.h"
#import "ConnectionUtil2.h"

//#import "RazaConnectionManager.h"

@protocol ServiceManagerDelegate <NSObject, NSURLConnectionDelegate>

typedef void(^ErrorHandlerBlock)(BOOL status, NSString* message, int statusCode);
typedef void(^DataHandlerBlock)(BOOL status, NSArray* data);

@optional
-(void)receivedDataFromService:(id)info withResponseType:(NSString *)responseType;

@end

@interface RazaServiceManager : NSObject <NSConnectionProt,NSConnectionProt2> {
    
    //RazaDataModel *dataModel;
    NSString *requestType;
}

//@property (nonatomic)RazaDataModel *dataModel;
@property(nonatomic, weak)id <ServiceManagerDelegate> delegate;

+ (RazaServiceManager *)sharedInstance;
+ (void)resetSharedInstance;

-(void)requestLoginWithUserName:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withDeviceId:(NSString *)deviceid;

-(void)requestFreeTrialExistWithMemberId:(NSString *)memberid;

-(void)requestToSignUpWithEmail:(NSString *)emailid
                   withPassword:(NSString *)password
                      withPhone:(NSString *)phone
         withCallingFromCountry:(NSString *)callingFromCountry
           withCallingToCountry:(NSString *)callingToCountry
                   withDeviceId:(NSString *)deviceid;

-(void)Customer_SignUp_Eligible:(NSString *)emailid
                   withPassword:(NSString *)password
                      withPhone:(NSString *)phone
                        ZipCode:(NSString *)ZipCode
                        Country:(NSString *)Country
                   withDeviceId:(NSString *)deviceid;

-(void)Send_SMS_Message:(NSString *)Phone_Number
                Message:(NSString *)Message
          RecipientName:(NSString *)RecipientName;

-(void)requestToGetPassword:(NSString *)emailid withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)getCountryListWithSearchType:(NSString *)searchType withDestination:(NSString *)destinationType;

-(void)getCountryListByRates:(NSString *)substring;

-(void)requestRechargePinWithMember:(NSString *)memberid
                        withUserPin:(NSString *)userpin
                       withPurchase:(NSString *)amount
                     withCardNumber:(NSString *)cardnumber
                     withCardExpiry:(NSString *)cardexpiry
                            withCVV:(NSString *)cvv
                         withStreet:(NSString *)street
                           withCity:(NSString *)city
                          withState:(NSString *)state
                            withZip:(NSString *)zip
                        withCountry:(NSString *)country
                             withIP:(NSString *)ipaddress;

-(void)RechargePin:(NSString *)memberid
       withUserPin:(NSString *)userpin
      withPurchase:(NSString *)amount
    withCardNumber:(NSString *)cardnumber
    withCardExpiry:(NSString *)cardexpiry
           withCVV:(NSString *)cvv
          address1:(NSString *)address1
          address2:(NSString *)address2
          withCity:(NSString *)city
         withState:(NSString *)state
           withZip:(NSString *)zip
       withCountry:(NSString *)country
            withIP:(NSString *)ipaddress
  autoRefillEnroll:(BOOL)autoRefillEnroll;

-(void)requestRechargePinWithFreeTrialMember:(NSString *)memberid
                                 withUserPin:(NSString *)userpin
                                withPurchase:(NSString *)amount
                                  withStreet:(NSString *)street
                                    withCity:(NSString *)city
                                   withState:(NSString *)state
                                     withZip:(NSString *)zip
                                 withCountry:(NSString *)country
                                      withIP:(NSString *)ipaddress;

-(void)requestToRedeemNowWithMember:(NSString *)memberid
                        withUserPin:(NSString *)userpin
                   withCouponamount:(NSString *)couponamount
                       withAddress1:(NSString *)address1
                       withAddress2:(NSString *)address2
                           withCity:(NSString *)city
                          withState:(NSString *)state
                            withZip:(NSString *)zip
                        withCountry:(NSString *)country
                             withIP:(NSString *)ipaddress;

-(void)requestToUpdateBillingInfo:(NSString *)memeberid withFirstName:(NSString *)firstname
                     withLastName:(NSString *)lastname
                      withAddress:(NSString *)address
                         withCity:(NSString *)city
                        withState:(NSString *)state
                          withZip:(NSString *)zipcode
                      withCountry:(NSString *)country;

-(void)requestToGetBillingInfo:(NSString *)memberid;

//-(void)requestToMakeCallWithDeviceId:(NSString *)deviceid withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToMakeCallWithDeviceIdWithCustomerId:(NSString *)deviceid
                                    withCustomerId:(NSString *)memberid
                                      withDelegate:(id<ServiceManagerDelegate>)delegate;
-(void)requestToGetPinBalance:(NSString *)userpin;

-(void)requestToSetDestinationWithPin:(NSString *)userpin
                         withAccessNo:(NSString *)accessno
                          withPhoneNo:(NSString *)phone
                         withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToAccessNumbersWithPin:(NSString *)userpin
                         withPhoneNo:(NSString *)phone;

-(void)requestToGetOrderHistory:(NSString *)memberid;

-(void)requestToGetCallHistory:(NSString *)userpin;

-(void)requestToGetRewardPoints:(NSString *)memberid
                   withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)GetRewardSignUpStatus:(NSString *)memberid
                withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)RewardSignUp:(NSString *)memberid
       withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToGetAccessNumbersBy:(NSString *)accessBy withValues:(NSArray *)values withDelegate:(id <ServiceManagerDelegate>)delegate;


//pinless related
-(void)requestToGetPinlessSetupWithUserPin:(NSString *)userpin
                              withDeviceId:(NSString *)deviceid
                              withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToDeletePinlessSetupWithUserPin:(NSString *)userpin
                                      withAni:(NSString *)aninumber
                                  withCountry:(NSString *)countrycode
                              withRequestedBy:(NSString *)requestBy
                                 withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToSubmitPinlessSetupWithAniName:(NSString *)aniname
                                   withMember:(NSString *)memberid
                              withRequestedBy:(NSString *)requestedBy
                                  withUserPin:(NSString *)userpin
                                withAniNumber:(NSString *)aninumber
                                  withCountry:(NSString *)countrycode
                                 withDelegate:(id <ServiceManagerDelegate>)delegate;

//quickeyless related
-(void)requestToGetQuickeylessSetupWithUserPin:(NSString *)userpin
                                  withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToDeleteQuickeylessWithUserPin:(NSString *)userpin
                                     withAni:(NSString *)aninumber
                               withSpeedDial:(NSString *)speeddial
                                    withNick:(NSString *)name
                                withDelegate:(id <ServiceManagerDelegate>)delegate;

-(void)requestToSubmitQuickeylessWithMemberId:(NSString *)memeberid
                                  withUserPin:(NSString *)userpin
                                  withCountry:(NSString *)countrycode
                                      withAni:(NSString *)aninumber
                                withSpeedDial:(NSString *)speeddial
                                     withNick:(NSString *)name
                                 withDelegate:(id <ServiceManagerDelegate>)delegate;
-(void)requestLoginWithNewSipServer:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withDeviceId:(NSString*)deviceid andmethodemode:(NSString*)methodname;

-(void)requestToSignUp_Eligible_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;
-(void)requestToCustomer_SignUp_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withCountrycodeTo:(NSString *)countrycodeTo withVerificationcode:(NSString *)VerificationCode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;

-(void)CustomerSignUp_V2:(NSString *)username withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode  withVerificationcode:(NSString *)VerificationCode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong
;

-(void)CustomerSignUpEligible_V1:(NSString *)username  withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;

-(void)requestLoginVerify:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong ;

-(void)LoginWithPassCode:(NSString *)password withPhone:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;

-(void)SendPassCode:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;

-(void)requestLoginConfirmWithUserNameLogin_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withVerificationcode:(NSString *)Verificationcode withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;
-(void)requestLoginConfirmWithUserNameLogin_V2:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withVerificationcode:(NSString *)Verificationcode withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong;

-(void)requestToIssueNewPin:(NSString *)memberid
                  withPhone:(NSString *)phone
     withCallingFromCountry:(NSString *)callingFromCountry
       withCallingToCountry:(NSString *)callingToCountry
                withCountry:(NSString *)countrycode
               withDeviceId:(NSString *)deviceid;

-(void)SaveAPIRating:(NSString *)customerId
                 pin:(NSString *)pin
        callDateTime:(NSString *)callDateTime
   destinationNumber:(NSString*)destinationNumber
          starRating:(int)starRating;

-(void)GetSIPUsersList;

@end
