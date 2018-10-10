//
//  RazaServiceManager.m
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaServiceManager.h"
//#import "RazaConnectionManager.h"


static RazaServiceManager* sharedInstance = nil;

static NSString *soapHeader = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
"<soap:Header>\n"
"<Raza_AuthHeader xmlns=\"http://tempuri.org/\">\n"
"<AuthUsername>r@ZaSusFRonT</AuthUsername>\n"
"<AuthPassword>X6i2!0G2$m3@s2A*pX4T</AuthPassword>\n"
"</Raza_AuthHeader>\n"
"</soap:Header>\n"
"<soap:Body>\n";
/*-----prev Cred---*/
//RMApp
//hArLEm7290

//UserName = mObapnEW
//Password = 8z5e$03d!4%2Am7

//New
//UserName: r@ZaSusFRonT
//Password: X6i2!0G2$m3@s2A*pX4T
@implementation RazaServiceManager

+(void)initialize {
    
    sharedInstance = [[RazaServiceManager alloc]init];
    
}

+(RazaServiceManager *)sharedInstance {
    
    return sharedInstance;
}

+ (void)resetSharedInstance {
    sharedInstance = nil;
}

//
//-(id)init {
//    
//    self = [super init];
//    
//    if (!self) {
//        return nil;
//    }
//    //self.dataModel = [[RazaDataModel alloc]init];
//    return self;
//}
-(void)getCallBackResponseNewsip:(NSDictionary *)resultString withResultType:(NSString *)resultType
{
    if ([resultType isEqualToString:@"add_subscriber"]|| [ resultType isEqualToString:@"update_subscriber"])
    {
        
        NSLog(@"%@",@"jkjjkjkl");
        [[RazaDataModel sharedInstance]loginResponseNewSipServer:resultString withResponseType:resultType];
    }
}
-(void)requestLoginWithNewSipServer:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withDeviceId:(NSString*)deviceid andmethodemode:(NSString*)methodname {
    NSString *header=  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
    NSString *request=[NSString stringWithFormat:
                       @"<request>\n"
                       "<api_username>%@</api_username>\n"
                       "<api_key>%@</api_key>\n"
                       "<command>%@</command>\n"
                       "<return_type>%@</return_type>\n"
                       "<domain>%@</domain>\n"
                       "<username>%@</username>\n"
                       "<password>%@</password>\n"
                       "<sipapp_os>%@</sipapp_os>\n"
                       "<sipapp_token>%@</sipapp_token>\n"
                       "<email_addr>%@</email_addr>\n"
                       "</request>\n"
                       ,@"razaapi",@"8cc18311-31fd-4568-ad26-4d36cc773c48",methodname,@"json",DEFAULT_SIP_APIURL,phone,password,@"ios",deviceid,@"email@domain.com"];
    NSString *requestfinal=[NSString stringWithFormat:@"%@%@",header,request];
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:requestfinal withProtocol:self withResultType:methodname withMethod:DEFAULT_SIP_ADDRESS];
}
-(void)getCountryListWithSearchType:(NSString *)searchType withDestination:(NSString *)destinationType {
    
    NSString *request=[NSString stringWithFormat:
                       @"%@"
                       "<Get_CountryList xmlns=\"http://tempuri.org/\">\n"
                       "<SearchType>%@</SearchType>\n"
                       "<DestinationType>%@</DestinationType>"
                       "</Get_CountryList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",soapHeader, searchType, destinationType];
    
    
    //    NSString *request=[NSString stringWithFormat:
    //                       @"%@"
    //                       "<Get_Rates_By_Country xmlns=\"http://tempuri.org/\">\n"
    //                       "<Alphabet>%@</Alphabet>\n"
    //                       "</Get_Rates_By_Country>\n"
    //                       "</soap:Body>\n"
    //                       "</soap:Envelope>\n",soapHeader, substring];
    requestType = searchType;
    NSLog(@"requestType %@", requestType);
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_CountryListResult" withMethod:@"http://tempuri.org/Get_CountryList"];
}

-(void)getCountryListByRates:(NSString *)substring{
    
    //    NSString *request=[NSString stringWithFormat:
    //                       @"%@"
    //                       "<Get_Rates_By_Country xmlns=\"http://tempuri.org/\">\n"
    //                       "<Alphabet>%@</Alphabet>\n"
    //                       "</Get_Rates_By_Country>\n"
    //                       "</soap:Body>\n"
    //                       "</soap:Envelope>\n",soapHeader, substring];
    //
    //    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    //    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Rates_By_CountryResult" withMethod:@"http://tempuri.org/Get_Rates_By_Country"];
    
    
    NSString *userid=  [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID];
    NSString *userpin = [[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_PIN];
    NSString *request=[NSString stringWithFormat:
                       @"%@"
                       "<Get_Rates_By_Country_V1 xmlns=\"http://tempuri.org/\">\n"
                       "<Alphabet>%@</Alphabet>\n"
                       "<CustomerID>%@</CustomerID>\n"
                       "<Pin>%@</Pin>\n"
                       "</Get_Rates_By_Country_V1>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",soapHeader, substring,userid,userpin];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Rates_By_Country_V1Response" withMethod:@"http://tempuri.org/Get_Rates_By_Country_V1"];
}

#pragma mark -
#pragma mark Account related methods

// request fot login

-(void)requestLoginWithUserName:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withDeviceId:(NSString *)deviceid {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Login xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Login>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone, RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"LoginResult" withMethod:@"http://tempuri.org/Login"];
}

-(void)requestFreeTrialExistWithMemberId:(NSString *)memberid {
    NSString *request=[NSString stringWithFormat:
                       @"%@"
                       "<Does_FreeTrial_Exist_V1 xmlns=\"http://tempuri.org/\">\n"
                       "<CustomerID>%@</CustomerID>\n"
                       "<Device_ID>%@</Device_ID>\n"
                       "</Does_FreeTrial_Exist_V1>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Does_FreeTrial_Exist_V1Result" withMethod:@"http://tempuri.org/Does_FreeTrial_Exist_V1"];
}

-(void)requestToSignUpWithEmail:(NSString *)emailid
                   withPassword:(NSString *)password
                      withPhone:(NSString *)phone
         withCallingFromCountry:(NSString *)callingFromCountry
           withCallingToCountry:(NSString *)callingToCountry
                   withDeviceId:(NSString *)deviceid {
    
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Customer_SignUp xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<CallingFrom>%@</CallingFrom>\n"
                         "<CallingTo>%@</CallingTo>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Customer_SignUp>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, emailid, password, phone, callingFromCountry, callingToCountry, deviceid];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Customer_SignUpResult" withMethod:@"http://tempuri.org/Customer_SignUp"];
}
-(void)Customer_SignUp_Eligible:(NSString *)emailid
                   withPassword:(NSString *)password
                      withPhone:(NSString *)phone
                        ZipCode:(NSString *)ZipCode
                        Country:(NSString *)Country
                   withDeviceId:(NSString *)deviceid {
    
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Customer_SignUp_Eligible xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<ZipCode>%@</ZipCode>\n"
                         "<Country>%@</Country>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Customer_SignUp_Eligible>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, emailid, password, phone, ZipCode, Country, deviceid];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Customer_SignUp_EligibleResult" withMethod:@"http://tempuri.org/Customer_SignUp_Eligible"];
}
-(void)Send_SMS_Message:(NSString *)Phone_Number
                Message:(NSString *)Message
          RecipientName:(NSString *)RecipientName

{
    
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Send_SMS_Message_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<Phone_Number>%@</Phone_Number>\n"
                         "<Message>%@</Message>\n"
                         "<RecipientName>%@</RecipientName>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Send_SMS_Message_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, Phone_Number, Message, RecipientName,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Send_SMS_Message_V1Result" withMethod:@"http://tempuri.org/Send_SMS_Message_V1"];
}

-(void)requestToGetPassword:(NSString *)emailid withDelegate:(id <ServiceManagerDelegate>)delegate{
    
    NSString *request;
    request=[NSString stringWithFormat:
             @"%@"
             "<Get_Password_V1 xmlns=\"http://tempuri.org/\">\n"
             "<EmailAddress>%@</EmailAddress>\n"
             "<Device_ID>%@</Device_ID>\n"
             "</Get_Password_V1>\n"
             "</soap:Body>\n"
             "</soap:Envelope>\n",soapHeader, emailid,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Password_V1Result" withMethod:@"http://tempuri.org/Get_Password_V1"];
}

#pragma mark -
#pragma mark Billing info related methods

// Request to get billing info

-(void)requestToUpdateBillingInfo:(NSString *)memeberid
                    withFirstName:(NSString *)firstname
                     withLastName:(NSString *)lastname
                      withAddress:(NSString *)address
                         withCity:(NSString *)city
                        withState:(NSString *)state
                          withZip:(NSString *)zipcode
                      withCountry:(NSString *)country {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Update_Billing_Information_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<FirstName>%@</FirstName>\n"
                         "<LastName>%@</LastName>\n"
                         "<Address>%@</Address>\n"
                         "<City>%@</City>\n"
                         "<State>%@</State>\n"
                         "<ZipCode>%@</ZipCode>\n"
                         "<Country>%@</Country>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Update_Billing_Information_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, memeberid, firstname, lastname, address, city, state, zipcode, country,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Update_Billing_Information_V1Response" withMethod:@"http://tempuri.org/Update_Billing_Information_V1"];
}

// Request to get billing info

-(void)requestToGetBillingInfo:(NSString *)memberid {
    NSString *request = [NSString stringWithFormat:@"%@"
                         "<Get_Billing_Information_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Billing_Information_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Billing_Information_V1Result" withMethod:@"http://tempuri.org/Get_Billing_Information_V1"];
}


#pragma mark -
#pragma mark Recharge related methods

//TODO: Merge the get recharge & redeem requet to a sigle method of the reponse

// Request to get recharge

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
                             withIP:(NSString *)ipaddress

{
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Recharge_Pin_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Purchase_Amount>%.2f</Purchase_Amount>\n"
                         "<Card_Number>%@</Card_Number>\n"
                         "<Exp_Date>%@</Exp_Date>\n"
                         "<CVV2>%@</CVV2>\n"
                         "<Address1>%@</Address1>\n"
                         "<Address2>%@</Address2>\n"
                         "<City>%@</City>\n"
                         "<State>%@</State>\n"
                         "<ZipCode>%@</ZipCode>\n"
                         "<Country>%@</Country>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Recharge_Pin_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, memberid, userpin, [amount floatValue], cardnumber, cardexpiry, cvv, street, @"", city, state, zip, country, RAZA_APPDELEGATE.ipAddress,RAZA_APPDELEGATE.deviceID];
    
    
    //    NSString *request = [NSString stringWithFormat:
    //                         @"%@"
    //                         "<Recharge_Pin_V1 xmlns=\"http://tempuri.org/\">\n"
    //                         "<CustomerID>%@</CustomerID>\n"
    //                         "<Pin>%@</Pin>\n"
    //                         "<Purchase_Amount>%.2f</Purchase_Amount>\n"
    //                         "<Card_Number>%@</Card_Number>\n"
    //                         "<Exp_Date>%@</Exp_Date>\n"
    //                         "<CVV2>%@</CVV2>\n"
    //                         "<Address1>%@</Address1>\n"
    //                         "<Address2>%@</Address2>\n"
    //                         "<City>%@</City>\n"
    //                         "<State>%@</State>\n"
    //                         "<ZipCode>%@</ZipCode>\n"
    //                         "<Country>%@</Country>\n"
    //                         "<IP_Address>%@</IP_Address>\n"
    //                         "<Device_ID>%@</Device_ID>\n"
    //                         "</Recharge_Pin_V1>\n"
    //                         "</soap:Body>\n"
    //                         "</soap:Envelope>\n", soapHeader, @"808319", @"1111853061", [amount floatValue], @"5424180796227269", @"0817", @"808", @"5219 N Harlem Ave", @"", @"Chicago", @"IL", @"60656", @"1", RAZA_APPDELEGATE.ipAddress,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Recharge_Pin_V1Result" withMethod:@"http://tempuri.org/Recharge_Pin_V1"];
}
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
  autoRefillEnroll:(BOOL)autoRefillEnroll {
    double amountAuto=0.00;
    if (autoRefillEnroll) {
        amountAuto=10.00;
    }
    NSString *stringAutoRefillEnroll = autoRefillEnroll?@"true":@"false";
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<RechargePin xmlns=\"http://tempuri.org/\">\n"
                         "<customerId>%@</customerId>\n"
                         "<pin>%@</pin>\n"
                         "<purchaseAmount>%.2f</purchaseAmount>\n"
                         "<autoRefillEnroll>%@</autoRefillEnroll>\n"
                         "<autorefillAmount>%.2f</autorefillAmount>\n"
                         "<cardNumber>%@</cardNumber>\n"
                         "<expiryDate>%@</expiryDate>\n"
                         "<cvvCode>%@</cvvCode>\n"
                         "<address1>%@</address1>\n"
                         "<address2>%@</address2>\n"
                         "<city>%@</city>\n"
                         "<state>%@</state>\n"
                         "<zipCode>%@</zipCode>\n"
                         "<country>%@</country>\n"
                         "<ipAddress>%@</ipAddress>\n"
                         "<deviceId>%@</deviceId>\n"
                         "</RechargePin>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, memberid, userpin, [amount floatValue],stringAutoRefillEnroll,amountAuto, cardnumber, cardexpiry, cvv, address1, address2, city, state, zip, country, RAZA_APPDELEGATE.ipAddress,RAZA_APPDELEGATE.deviceID];
    
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"RechargePinResult" withMethod:@"http://tempuri.org/RechargePin"];
}


-(void)requestRechargePinWithFreeTrialMember:(NSString *)memberid withUserPin:(NSString *)userpin withPurchase:(NSString *)amount withStreet:(NSString *)street withCity:(NSString *)city withState:(NSString *)state withZip:(NSString *)zip withCountry:(NSString *)country withIP:(NSString *)ipaddress {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Recharge_Pin_FreeTrial_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Purchase_Amount>%.2f</Purchase_Amount>\n"
                         "<Address1>%@</Address1>\n"
                         "<Address2>%@</Address2>\n"
                         "<City>%@</City>\n"
                         "<State>%@</State>\n"
                         "<ZipCode>%@</ZipCode>\n"
                         "<Country>%@</Country>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Recharge_Pin_FreeTrial_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, memberid, userpin, [amount floatValue], street, @"", city, state, zip, country, RAZA_APPDELEGATE.ipAddress,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Recharge_Pin_FreeTrial_V1Result" withMethod:@"http://tempuri.org/Recharge_Pin_FreeTrial_V1"];
}


-(void)requestToRedeemNowWithMember:(NSString *)memberid
                        withUserPin:(NSString *)userpin
                   withCouponamount:(NSString *)couponamount
                       withAddress1:(NSString *)address1
                       withAddress2:(NSString *)address2
                           withCity:(NSString *)city
                          withState:(NSString *)state
                            withZip:(NSString *)zip
                        withCountry:(NSString *)country
                             withIP:(NSString *)ipaddress {
    
    NSString *request=[NSString stringWithFormat:
                       @"%@"
                       "<Recharge_Pin_Redeem xmlns=\"http://tempuri.org/\">\n"
                       "<CustomerID>%@</CustomerID>\n"
                       "<Pin>%@</Pin>\n"
                       "<Purchase_Amount>%.2f</Purchase_Amount>\n"
                       "<Address1>%@</Address1>\n"
                       "<Address2>%@</Address2>\n"
                       "<City>%@</City>\n"
                       "<State>%@</State>\n"
                       "<ZipCode>%@</ZipCode>\n"
                       "<Country>%@</Country>\n"
                       "<IP_Address>%@</IP_Address>\n"
                       "</Recharge_Pin_Redeem>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",soapHeader, memberid, userpin, [couponamount floatValue], address1, address2, city, state, zip, country, ipaddress];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Recharge_Pin_RedeemResult" withMethod:@"http://tempuri.org/Recharge_Pin_Redeem"];
    
}

/*
 NSString *request=[NSString stringWithFormat:
 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
 "<soap:Header>\n"
 "<Raza_AuthHeader xmlns=\"http://tempuri.org/\">\n"
 "<AuthUsername>mobileapp</AuthUsername>\n"
 "<AuthPassword>app123</AuthPassword>\n"
 "</Raza_AuthHeader>\n"
 "</soap:Header>\n"
 "<soap:Body>\n"
 "<Recharge_Pin_Redeem xmlns=\"http://tempuri.org/\">\n"
 "<CustomerID>%@</CustomerID>\n"
 "<Pin>%@</Pin>\n"
 "<Purchase_Amount>%.2f</Purchase_Amount>\n"
 "<Address1>%@</Address1>\n"
 "<Address2>%@</Address2>\n"
 "<City>%@</City>\n"
 "<State>%@</State>\n"
 "<ZipCode>%@</ZipCode>\n"
 "<Country>%@</Country>\n"
 "<IP_Address>%@</IP_Address>\n"
 "</Recharge_Pin_Redeem>\n"
 "</soap:Body>\n"
 "</soap:Envelope>\n",memid,userPin,[couponamount floatValue],street1,@"",city,[prefs stringForKey:@"state"],zip,[prefs stringForKey:@"countrycode"],ipaddr];
 */


-(void)requestToGetPinBalance:(NSString *)userpin  {
    
    NSString *request=[NSString stringWithFormat:
                       @"%@"
                       "<Get_Pin_Balance_V1 xmlns=\"http://tempuri.org/\">\n"
                       "<CustomerID>%@</CustomerID>\n"
                       "<Pin>%@</Pin>\n"
                       "<Device_ID>%@</Device_ID>\n"
                       "</Get_Pin_Balance_V1>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Pin_Balance_V1Result" withMethod:@"http://tempuri.org/Get_Pin_Balance_V1"];
    
}

#pragma mark -
#pragma mark Call related methods

//-(void)requestToMakeCallWithDeviceId:(NSString *)deviceid withDelegate:(id <ServiceManagerDelegate>)delegate{
//    
//    NSString *request = [NSString stringWithFormat:
//             @"%@"
//             "<Make_A_Call xmlns=\"http://tempuri.org/\">\n"
//             "<Device_ID>%@</Device_ID>\n"
//             "</Make_A_Call>\n"
//             "</soap:Body>\n"
//             "</soap:Envelope>\n",soapHeader, deviceid];
//    
//    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
//    [cnutil initConnection:request withProtocol:self withResultType:@"Make_A_CallResult" withMethod:@"http://tempuri.org/Make_A_Call"];
//}
-(void)requestToMakeCallWithDeviceIdWithCustomerId:(NSString *)deviceid withCustomerId:(NSString *)memberid withDelegate:(id<ServiceManagerDelegate>)delegate{
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Make_Call_AccessNumber xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Make_Call_AccessNumber>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memberid, deviceid];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Make_Call_AccessNumberResult" withMethod:@"http://tempuri.org/Make_Call_AccessNumber"];
}

-(void)requestToSetDestinationWithPin:(NSString *)userpin withAccessNo:(NSString *)accessno withPhoneNo:(NSString *)phone withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Set_Destination_To_Make_Call_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Access_Number>%@</Access_Number>\n"
                         "<Destination_Number>%@</Destination_Number>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Set_Destination_To_Make_Call_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin, accessno, phone,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Set_Destination_To_Make_Call_V1Result" withMethod:@"http://tempuri.org/Set_Destination_To_Make_Call_V1"];
}

-(void)requestToAccessNumbersWithPin:(NSString *)userpin withPhoneNo:(NSString *)phone {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Access_Number_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<Pin>%@</Pin>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Access_Number_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, userpin, phone,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Access_Number_V1Result" withMethod:@"http://tempuri.org/Get_Access_Number_V1"];
}

-(void)requestToGetOrderHistory:(NSString *)memberid {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Order_History_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Order_History_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Order_History_V1Result" withMethod:@"http://tempuri.org/Get_Order_History_V1"];
}

-(void)requestToGetCallHistory:(NSString *)userpin {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Call_History_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Call_History_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Call_History_V1Result" withMethod:@"http://tempuri.org/Get_Call_History_V1"];
}

-(void)requestToGetRewardPoints:(NSString *)memberid withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Reward_Points_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Reward_Points_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Reward_Points_V1Result" withMethod:@"http://tempuri.org/Get_Reward_Points_V1"];
}

-(void)RewardSignUp:(NSString *)memberid withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<RewardSignUp xmlns=\"http://tempuri.org/\">\n"
                         "<customerId>%@</customerId>\n"
                         "<deviceId>%@</deviceId>\n"
                         "</RewardSignUp>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"RewardSignUp" andforth:@"http://tempuri.org/RewardSignUp"];
}

-(void)GetRewardSignUpStatus:(NSString *)memberid withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<GetRewardSignUpStatus xmlns=\"http://tempuri.org/\">\n"
                         "<customerId>%@</customerId>\n"
                         "<deviceId>%@</deviceId>\n"
                         "</GetRewardSignUpStatus>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memberid,RAZA_APPDELEGATE.deviceID];
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"GetRewardSignUpStatus" andforth:@"http://tempuri.org/GetRewardSignUpStatus"];
    //  [cnutil initConnection:request withProtocol:self withResultType:@"GetRewardSignUpStatusResult" withMethod:@"http://tempuri.org/GetRewardSignUpStatus"];
}


-(void)requestToGetAccessNumbersBy:(NSString *)accessBy withValues:(NSArray *)values withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *accessRequest = @"";
    NSString *resultType = @"";
    NSString *resultMethod = @"";
    
    if ([accessBy isEqualToString:@"phone"]) {
        
        accessRequest = [NSString stringWithFormat:@"<Get_Access_Number_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<Pin>%@</Pin>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Access_Number_V1>\n", [values objectAtIndex:0], [values objectAtIndex:1],RAZA_APPDELEGATE.deviceID];
        resultType = @"Get_Access_Number_V1Result";
        resultMethod = @"http://tempuri.org/Get_Access_Number_V1";
        
    }
    else if ([accessBy isEqualToString:@"state"]) {
        
        accessRequest = [NSString stringWithFormat:@"<Get_Access_Number_By_State_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<Country>%@</Country>\n"
                         "<State>%@</State>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Access_Number_By_State_V1>\n", [values objectAtIndex:0], [values objectAtIndex:1],RAZA_APPDELEGATE.deviceID];
        
        resultType = @"Get_Access_Number_By_State_V1Result";
        resultMethod = @"http://tempuri.org/Get_Access_Number_By_State_V1";
        
    }
    
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "%@"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, accessRequest];
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:resultType withMethod:resultMethod];
}

#pragma mark -
#pragma mark Pinless related methods

-(void)requestToGetPinlessSetupWithUserPin:(NSString *)userpin
                              withDeviceId:(NSString *)deviceid
                              withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Ani_Numbers_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Ani_Numbers_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin, deviceid];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Ani_Numbers_V1Result" withMethod:@"http://tempuri.org/Get_Ani_Numbers_V1"];
}

-(void)requestToDeletePinlessSetupWithUserPin:(NSString *)userpin
                                      withAni:(NSString *)aninumber
                                  withCountry:(NSString *)countrycode
                              withRequestedBy:(NSString *)requestBy
                                 withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Delete_PinLess_SetUp_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<AniNumber>%@</AniNumber>\n"
                         "<CountryCode>%@</CountryCode>\n"
                         "<Requested_By>%@</Requested_By>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Delete_PinLess_SetUp_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin, aninumber, countrycode, @"",RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Delete_PinLess_SetUp_V1Result" withMethod:@"http://tempuri.org/Delete_PinLess_SetUp_V1"];
}

-(void)requestToSubmitPinlessSetupWithAniName:(NSString *)aniname
                                   withMember:(NSString *)memberid
                              withRequestedBy:(NSString *)requestedBy
                                  withUserPin:(NSString *)userpin
                                withAniNumber:(NSString *)aninumber
                                  withCountry:(NSString *)countrycode
                                 withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<PinLess_SetUp xmlns=\"http://tempuri.org/\">\n"
                         "<AniName>%@</AniName>"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Requested_By>%@</Requested_By>\n"
                         "<Pin>%@</Pin>\n"
                         "<AniNumber>%@</AniNumber>\n"
                         "<CountryCode>%@</CountryCode>\n"
                         "</PinLess_SetUp>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, aniname, memberid, requestedBy, userpin, aninumber, countrycode];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"PinLess_SetUpResponse" withMethod:@"http://tempuri.org/PinLess_SetUp"];
}

#pragma mark -
#pragma mark Quickeyless related methods

-(void)requestToGetQuickeylessSetupWithUserPin:(NSString *)userpin
                                  withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Get_Quickeys_Numbers_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Get_Quickeys_Numbers_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID], userpin,RAZA_APPDELEGATE.deviceID];
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Get_Quickeys_Numbers_V1Result" withMethod:@"http://tempuri.org/Get_Quickeys_Numbers_V1"];
}

-(void)requestToDeleteQuickeylessWithUserPin:(NSString *)userpin
                                     withAni:(NSString *)aninumber
                               withSpeedDial:(NSString *)speeddial
                                    withNick:(NSString *)name
                                withDelegate:(id <ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Delete_Quickeys_SetUp_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<Destination_Number>%@</Destination_Number>\n"
                         "<SpeedDial_Number>%@</SpeedDial_Number>\n"
                         "<Requested_By>%@</Requested_By>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Delete_Quickeys_SetUp_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,[[RAZA_USERDEFAULTS objectForKey:@"logininfo"] objectForKey:LOGIN_RESPONSE_ID] ,userpin, aninumber, speeddial, name,RAZA_APPDELEGATE.deviceID];
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Delete_Quickeys_SetUp_V1Result" withMethod:@"http://tempuri.org/Delete_Quickeys_SetUp_V1"];
    
}

-(void)requestToSubmitQuickeylessWithMemberId:(NSString *)memeberid withUserPin:(NSString *)userpin withCountry:(NSString *)countrycode withAni:(NSString *)aninumber withSpeedDial:(NSString *)speeddial withNick:(NSString *)name withDelegate:(id<ServiceManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Quickeys_SetUp_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>\n"
                         "<Pin>%@</Pin>\n"
                         "<CountryCode>%@</CountryCode>\n"
                         "<Destination_Number>%@</Destination_Number>\n"
                         "<SpeedDial_Number>%@</SpeedDial_Number>\n"
                         "<NickName>%@</NickName>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "</Quickeys_SetUp_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader, memeberid, userpin, countrycode, aninumber, speeddial, name,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Quickeys_SetUp_V1Result" withMethod:@"http://tempuri.org/Quickeys_SetUp_V1"];
    
}

-(void)requestToSignUp_Eligible_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Customer_SignUp_Eligible_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Country>%@</Country>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "</Customer_SignUp_Eligible_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone,countrycode, RAZA_APPDELEGATE.deviceID,devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Customer_SignUp_Eligible_V1Result" withMethod:@"http://tempuri.org/Customer_SignUp_Eligible_V1"];
}

-(void)CustomerSignUpEligible_V1:(NSString *)username  withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    [prefs synchronize];

    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<CustomerSignUpEligible_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Country>%@</Country>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "</CustomerSignUpEligible_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, phone,countrycode, RAZA_APPDELEGATE.deviceID,devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong];
    
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"CustomerSignUpEligible_V1" andforth:@"http://tempuri.org/CustomerSignUpEligible_V1"];
}

-(void)CustomerSignUp_V2:(NSString *)username withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode  withVerificationcode:(NSString *)VerificationCode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];

    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<CustomerSignUp_V2 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<CallingFrom>%@</CallingFrom>\n"
                         "<VerificationCode>%@</VerificationCode>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "<API_Token>%@</API_Token>\n"
                         
                         "</CustomerSignUp_V2>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, phone,countrycode,VerificationCode, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong,[RAZA_APPDELEGATE deviceToken]];
    
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"CustomerSignUp_V2" andforth:@"http://tempuri.org/CustomerSignUp_V2"];
    
    //Customer_SignUp_V2Result
  
}


-(void)requestToCustomer_SignUp_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withCountrycode:(NSString *)countrycode withCountrycodeTo:(NSString *)countrycodeTo withVerificationcode:(NSString *)VerificationCode withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Customer_SignUp_V2 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<CallingFrom>%@</CallingFrom>\n"
                         "<CallingTo>%@</CallingTo>\n"
                         "<VerificationCode>%@</VerificationCode>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "<API_Token>%@</API_Token>\n"
                         
                         "</Customer_SignUp_V2>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone,countrycode,countrycodeTo,VerificationCode, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong,[RAZA_APPDELEGATE deviceToken]];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Customer_SignUp_V2Result" withMethod:@"http://tempuri.org/Customer_SignUp_V2"];
}
-(void)requestLoginVerify:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Login_Verify xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "</Login_Verify>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Login_VerifyResult" withMethod:@"http://tempuri.org/Login_Verify"];
}
-(void)requestLoginConfirmWithUserNameLogin_V1:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withVerificationcode:(NSString *)Verificationcode withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Login_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<VerificationCode>%@</VerificationCode>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "</Login_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone,Verificationcode, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Login_V1Result" withMethod:@"http://tempuri.org/Login_V1"];
}

-(void)requestLoginConfirmWithUserNameLogin_V2:(NSString *)username withPassword:(NSString *)password withPhone:(NSString *)phone withVerificationcode:(NSString *)Verificationcode withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Login_V2 xmlns=\"http://tempuri.org/\">\n"
                         "<EmailAddress>%@</EmailAddress>\n"
                         "<Password>%@</Password>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<VerificationCode>%@</VerificationCode>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "<API_Token>%@</API_Token>\n"
                         "</Login_V2>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, username, password, phone,Verificationcode, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong,[RAZA_APPDELEGATE deviceToken]];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Login_V2Result" withMethod:@"http://tempuri.org/Login_V2"];
}

-(void)LoginWithPassCode:(NSString *)password withPhone:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<LoginWithPassCode xmlns=\"http://tempuri.org/\">\n"
                         "<PassCode>%@</PassCode>\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "<API_Token>%@</API_Token>\n"
                         "</LoginWithPassCode>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, password, phone, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong,[RAZA_APPDELEGATE deviceToken]];
    
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"LoginWithPassCode" andforth:@"http://tempuri.org/LoginWithPassCode"];
//Login_V2Result
}

-(void)SendPassCode:(NSString *)phone  withDeviceId:(NSString *)deviceid withDeviceType:(NSString *)devicetype withDevice_PhoneNumber:(NSString *)devicephone withDeviceIP_Address:(NSString *)ipaddress withDeviceIMEI_Number:(NSString *)imeinumber withClientDateTime:(NSString *)clientdatetime withDeviceLongitude_Latitude:(NSString *)latlong {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *phoneWithoutDash = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [prefs setObject:phoneWithoutDash forKey:@"phoneno"];
    
    //RAZA_APPDELEGATE.phoneNumber = phoneWithoutDash;
    
    [prefs synchronize];

    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<SendPassCode xmlns=\"http://tempuri.org/\">\n"
                         "<PhoneNumber>%@</PhoneNumber>\n"
                         "<Device_ID>%@</Device_ID>\n"
                         "<Device_Type>%@</Device_Type>\n"
                         "<Device_PhoneNumber>%@</Device_PhoneNumber>\n"
                         "<IP_Address>%@</IP_Address>\n"
                         "<IMEI_Number>%@</IMEI_Number>\n"
                         "<ClientDateTime>%@</ClientDateTime>\n"
                         "<Longitude_Latitude>%@</Longitude_Latitude>\n"
                         "</SendPassCode>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader, phone, RAZA_APPDELEGATE.deviceID,@"ios",devicephone,ipaddress,RAZA_APPDELEGATE.deviceID,clientdatetime,latlong];
    
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"SendPassCode" andforth:@"http://tempuri.org/SendPassCode"];
    //Login_V2Result
}

-(void)requestToIssueNewPin:(NSString *)memberid
                  withPhone:(NSString *)phone
     withCallingFromCountry:(NSString *)callingFromCountry
       withCallingToCountry:(NSString *)callingToCountry
                withCountry:(NSString *)countrycode
               withDeviceId:(NSString *)deviceid {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<Issue_New_Pin_V1 xmlns=\"http://tempuri.org/\">\n"
                         "<CustomerID>%@</CustomerID>"
                         "<UserType>%@</UserType>"
                         "<Card_ID>%@</Card_ID>"
                         "<TransAmt>%@</TransAmt>"
                         "<CountryFrom>%@</CountryFrom>"
                         "<CountryTo>%@</CountryTo>"
                         "<CouponCode>%@</CouponCode>"
                         "<AniNumber>%@</AniNumber>"
                         "<Payment_Method>%@</Payment_Method>"
                         "<Card_Number>%@</Card_Number>"
                         "<Exp_Date>%@</Exp_Date>"
                         "<CVV2>%@</CVV2>"
                         "<Address1>%@</Address1>"
                         "<Address2>%@</Address2>"
                         "<City>%@</City>"
                         "<State>%@</State>"
                         "<ZipCode>%@</ZipCode>"
                         "<Country>%@</Country>"
                         "<IP_Address>%@</IP_Address>"
                         "<Device_ID>%@</Device_ID>"
                         "</Issue_New_Pin_V1>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,memberid,@"new",@"0",@"0",callingFromCountry,callingToCountry,@"",phone,@"Free Trial",@"",@"",@"",@"",@"",@"",@"",@"",countrycode,RAZA_APPDELEGATE.ipAddress,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"Issue_New_Pin_V1Result" withMethod:@"http://tempuri.org/Issue_New_Pin_V1"];
}


-(void)SaveAPIRating:(NSString *)customerId
                 pin:(NSString *)pin
        callDateTime:(NSString *)callDateTime
   destinationNumber:(NSString*)destinationNumber
          starRating:(int)starRating {
    
    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<SaveAPIRating xmlns=\"http://tempuri.org/\">\n"
                         "<customerId>%@</customerId>"
                         "<pin>%@</pin>"
                         "<callDateTime>%@</callDateTime>"
                         "<destinationNumber>%@</destinationNumber>"
                         "<starRating>%d</starRating>"
                         "<deviceType>%@</deviceType>"
                         "</SaveAPIRating>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",soapHeader,customerId,pin,callDateTime,destinationNumber,starRating,RAZA_APPDELEGATE.deviceID];
    
    ConnectionUtil* cnutil=[[ConnectionUtil alloc]init];
    [cnutil initConnection:request withProtocol:self withResultType:@"SaveAPIRatingResult" withMethod:@"http://tempuri.org/SaveAPIRating"];
}

-(void)GetSIPUsersList{

    NSString *request = [NSString stringWithFormat:
                         @"%@"
                         "<GetSIPUsersList xmlns=\"http://tempuri.org/\" />\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n", soapHeader];
    
    ConnectionUtil2* cnutil=[[ConnectionUtil2 alloc]init];
    [cnutil initConnection:request andsecond:self andthird:@"GetSIPUsersList" andforth:@"http://tempuri.org/GetSIPUsersList"];
    //Login_V2Result
}



#pragma mark -
#pragma mark Service Callback Response
//Recharge_Pin_RedeemResult
-(void)getCallBackResponse:(NSString *)resultString withResultType:(NSString *)resultType {
    
    
    if ([resultType isEqualToString:@"SaveAPIRatingResult"]) {
        
        NSDictionary *loginInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate receivedDataFromService:loginInfo withResponseType:resultType];
        
        
    }
    if ([resultType isEqualToString:@"faultcode"]) {
        // do something with Country list response
        
        //[[RazaDataModel sharedInstance] getCountryLists:resultString withSearchType:requestType];
        // [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        //  NSString *errorMessage = @"Error: Enter correct format";
        //  NSString *alertTitle = @"Billing Info";
        
        //  [RAZA_APPDELEGATE showAlertWithMessage:errorMessage withTitle:alertTitle withCancelTitle:@"Ok"];
    }
    if ([resultType isEqualToString:@"Get_CountryListResult"]) {
        // do something with Country list response
        
        [[RazaDataModel sharedInstance] getCountryLists:resultString withSearchType:requestType];
    }
    if ([resultType isEqualToString:@"Send_SMS_Message_V1Result"]) {
        // do something with Country list response
        
        [[RazaDataModel sharedInstance] Send_SMS_MessageResponse:resultString withResponseType:requestType];
    }
    if ([resultType isEqualToString:@"Customer_SignUp_EligibleResult"] || [resultType isEqualToString:@"Customer_SignUp_Eligible_V1Result"]) {
        // do something with Country list response
        
       // [[RazaDataModel sharedInstance] signupResponse_Eligible:resultString withResponseType:requestType];
    }
    
    if ([resultType isEqualToString:@"Get_Rates_By_CountryResult"] || [resultType isEqualToString:@"Get_Rates_By_Country_V1Response"]) {
        [[RazaDataModel sharedInstance]getCountryListByRates:resultString];
    }
    if ([resultType isEqualToString:@"Customer_SignUpResult"] || [resultType isEqualToString:@"Customer_SignUp_V1Result"]||[resultType isEqualToString:@"Customer_SignUp_V2Result"]) {
     //   [[RazaDataModel sharedInstance]signupResponse:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"LoginResult"] || [resultType isEqualToString:@"Login_VerifyResult"] || [resultType isEqualToString:@"Login_V1Result"]||[resultType isEqualToString:@"Login_V2Result"]) {
       // [[RazaDataModel sharedInstance]loginResponse:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Password_V1Result"]) {
        NSDictionary *passwordInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate receivedDataFromService:passwordInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Update_Billing_Information_V1Response"]) {
        [[RazaDataModel sharedInstance]updateBillingInfoResponse:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Billing_Information_V1Result"]) {
        [[RazaDataModel sharedInstance]getBillingInfoResponse:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Recharge_Pin_V1Result"] ||
        [resultType isEqualToString:@"Recharge_Pin_RedeemResult"] || [resultType isEqualToString:@"RechargePinResult"]) {
        [[RazaDataModel sharedInstance]getRechargePinInfo:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Does_FreeTrial_Exist_V1Result"]) {
        //[[RazaDataModel sharedInstance]getFreeTrialInfo:resultString withResponseType:resultType];
        NSDictionary *freeTrialInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate receivedDataFromService:freeTrialInfo withResponseType:resultType];
    }
    //    if ([resultType isEqualToString:@"Make_A_CallResult"]) {
    //        [[RazaDataModel sharedInstance]getMakeCallInfo:resultString withResponseType:resultType];
    //    }
    if ([resultType isEqualToString:@"Get_Pin_Balance_V1Result"]) {
        //NSDictionary *balanceInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [[RazaDataModel sharedInstance]getBalanceInfo:resultString withResponseType:resultType];
        //[self.delegate receivedDataFromService:balanceInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Make_Call_AccessNumberResult"]) {
        [[RazaDataModel sharedInstance]getMakeCallInfo:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Set_Destination_To_Make_Call_V1Result"]) {
        NSDictionary *destinationCallInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        NSString *valueToSave = [destinationCallInfo objectForKey:@"accessno"];
        if (valueToSave.length) {
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"accessnumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        [self.delegate receivedDataFromService:destinationCallInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Access_Number_V1Result"]) {
        //Do someting
    }
    if ([resultType isEqualToString:@"Get_Order_History_V1Result"]) {
        [[RazaDataModel sharedInstance]getPurchaseHistory:resultString];
    }
    if ([resultType isEqualToString:@"Get_Call_History_V1Result"]) {
        [[RazaDataModel sharedInstance]getCallHistory:resultString];
    }
    if ([resultType isEqualToString:@"Get_Reward_Points_V1Result"]) {
        NSDictionary *rewardPointInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate receivedDataFromService:rewardPointInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"RewardSignUpResult"]) {
        NSDictionary *rewardPointInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate  receivedDataFromService:rewardPointInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"GetRewardSignUpStatusResult"]) {
        NSDictionary *rewardPointInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        [self.delegate  receivedDataFromService:rewardPointInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Access_Number_By_State_V1Result"] ||
        [resultType isEqualToString:@"Get_Access_Number_V1Result"]) {
        NSArray *accessnumbers = [RAZA_APPDELEGATE getArrayFromRequestString:resultString];
        [self.delegate receivedDataFromService:accessnumbers withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Ani_Numbers_V1Result"]) {
        
        NSDictionary *pinless = [RAZA_APPDELEGATE getDictionaryFromString:resultString separatedBy:@"~`" withKeyString:@"|" withIndex:0];
        
        [self.delegate receivedDataFromService:pinless withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Delete_PinLess_SetUp_V1Result"] ||
        [resultType isEqualToString:@"PinLess_SetUpResponse"]||[resultType isEqualToString:@"PinLess_SetUp_V1Response"]) {
        
        NSDictionary *pinlessInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        if (!pinlessInfo) {
            pinlessInfo = [RAZA_APPDELEGATE getDictionaryFromString:resultString separatedBy:@"|" withKeyString:@"=" withIndex:0];
        }
        [self.delegate receivedDataFromService:pinlessInfo withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"Get_Quickeys_Numbers_V1Result"]) {
        
        NSDictionary *info = [RAZA_APPDELEGATE getDictionaryFromString:resultString separatedBy:@"~`" withKeyString:@"|" withIndex:0];
        
        [self.delegate receivedDataFromService:info withResponseType:resultType];
        
    }
    if ([resultType isEqualToString:@"Delete_Quickeys_SetUp_V1Result"] ||
        [resultType isEqualToString:@"Quickeys_SetUp_V1Result"]) {
        
        NSDictionary *responseInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        
        [self.delegate receivedDataFromService:responseInfo withResponseType:resultType];
        
    }
    
    if ([resultType isEqualToString:@"Recharge_Pin_FreeTrial_V1Result"]) {
        NSDictionary *responseInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        NSLog(@"responseInfo %@", responseInfo);
    }
    if ([resultType isEqualToString:@"Issue_New_Pin_V1Result"]) {
        NSDictionary *destinationCallInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
        NSString *valueToSave = [destinationCallInfo objectForKey:@"accessno"];
        if (valueToSave.length) {
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"accessnumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [[RazaDataModel sharedInstance]getNewPinInfo:resultString withResponseType:resultType];
    }
    
}


- (void)getData:(NSDictionary *)resultString andsecond:(NSString *)resultType {
    if ([resultType isEqualToString:@"RewardSignUp"]) {
        [self.delegate  receivedDataFromService:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"GetRewardSignUpStatus"]) {
        [self.delegate  receivedDataFromService:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"error"]) {
        [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        [[Razauser SharedInstance]HideWaiting];
    }
    if ([resultType isEqualToString:@"CustomerSignUpEligible_V1"]) {
       [[RazaDataModel sharedInstance] signupResponse_Eligible:resultString withResponseType:requestType];
    }
    //CustomerSignUp_V2
    if ([resultType isEqualToString:@"CustomerSignUp_V2"]) {
        [[RazaDataModel sharedInstance]signupResponse:resultString withResponseType:resultType];
    }
    
    if ([resultType isEqualToString:@"LoginWithPassCode"]) {
        [[RazaDataModel sharedInstance]loginResponse:resultString withResponseType:resultType];
    }
    
    if ([resultType isEqualToString:@"SendPassCode"]) {
        [self.delegate receivedDataFromService:resultString withResponseType:resultType];
    }
    if ([resultType isEqualToString:@"GetSIPUsersList"]) {
        NSArray *arruser=[resultString objectForKey:@"string"];
        [[Razauser SharedInstance] setRazauser:arruser];
       // [self.delegate receivedDataFromService:resultString withResponseType:resultType];
    }
    

}

@end
