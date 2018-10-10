//
//  RazaDataModel.m
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaDataModel.h"
#import "RazaLoginModel.h"
#import "RazaViewRatesModel.h"
#import "RazaAccountModel.h"
#import "RazaCountryToModel.h"
#import "RazaCountryFromModel.h"


static RazaDataModel* sharedInstance = nil;

@implementation RazaDataModel

/*
 The initialize method only gets called once and on a single thread before any other class methods. So, no need of additional logic/thread synchronization for the singleton implementation.
 */

+(void)initialize {
    if (self == [RazaDataModel class]) {
        sharedInstance = [[RazaDataModel alloc]init];
    }
    
}

+(RazaDataModel *)sharedInstance {
    
    return sharedInstance;
}

-(id)init {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.countryList = [NSMutableArray array];
    
    self.countryToList = [NSMutableArray array];
    
    self.countryFromList = [NSMutableArray array];
    
    self.rateListByCountry = [NSMutableArray array];
    //_countryModel = [[RazaViewRatesModel alloc]init];
    return self;
}

#pragma mark -
#pragma mark Country Info


-(void)getCountryListByRates:(NSString *)resultString {
    
    [self.countryList removeAllObjects];
    [self.rateListByCountry removeAllObjects];
    
    if(![REMOVE_WHITELINESPACE(resultString) isEqualToString:@"error"])
	{
		NSArray *listItems = [resultString componentsSeparatedByString:@"~"];
        NSString * chkStatus=[listItems objectAtIndex:0];
        NSArray *listItems2 = [chkStatus componentsSeparatedByString:@"="];
        
        if( [[[listItems2 objectAtIndex:1]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"])
        {
            NSArray *listItems3 = [[listItems objectAtIndex:1] componentsSeparatedByString:@"`"];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[listItems objectAtIndex:1] forKey:@"destinationList"];
            
            for(int i=0;i<[listItems3 count];i++)
            {
                NSArray *listItems4 = [[listItems3 objectAtIndex:i] componentsSeparatedByString:@"|"];
                RazaViewRatesModel *_countryModel =  [[RazaViewRatesModel alloc]initWithDictionary:listItems4];
                [self.rateListByCountry addObject:_countryModel];
                [self.countryList addObject:[NSString stringWithFormat:@"%@",[listItems4 objectAtIndex:2]]];
            }
        }
    }
    [self.delegate updateView];

}

-(void)getCountryLists:(NSString *)resultString withSearchType:(NSString *)searchType {
    
    if ([searchType isEqualToString:COUNTRY_FROM_SEARCHTYPE]) {
        [self.countryFromList removeAllObjects];
    }
    else {
        [self.countryToList removeAllObjects];
    }
    
    if(![REMOVE_WHITELINESPACE(resultString) isEqualToString:@"error"])
	{
		NSArray *listItems = [resultString componentsSeparatedByString:@"|"];
        NSString * chkStatus=[listItems objectAtIndex:0];
        NSArray *listItems2 = [chkStatus componentsSeparatedByString:@"="];
        
        if( [[[listItems2 objectAtIndex:1]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"])
        {
            
            NSArray *listItems3 = [[listItems objectAtIndex:1] componentsSeparatedByString:@","];
            //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //[prefs setObject:[listItems objectAtIndex:1] forKey:@"destinationList"];
            
            for(int i=0;i<[listItems3 count];i++)
            {
                NSArray *listItems4 = [[listItems3 objectAtIndex:i] componentsSeparatedByString:@"~"];
                
                if ([searchType isEqualToString:COUNTRY_FROM_SEARCHTYPE]) {
                    RazaCountryFromModel *countryFromModel = [[RazaCountryFromModel alloc]initWithDictionary:listItems4];
                    [self.countryFromList addObject:countryFromModel];
                }
                else {
                
                    RazaCountryToModel *countryToModel =  [[RazaCountryToModel alloc]initWithDictionary:listItems4];
                    [self.countryToList addObject:countryToModel];
                }
            }
        }
        
        [self.delegate updateViewWithRequestIndentity:searchType];
    }
}



-(void)getPurchaseHistory:(NSString *)resultString {
    
    if(![REMOVE_WHITELINESPACE(resultString) isEqualToString:@"error"])
	{
        NSArray *listItems = [resultString componentsSeparatedByString:@"~"];
        NSString *chkStatus=[listItems objectAtIndex:0];
        NSArray *listItems2 = [chkStatus componentsSeparatedByString:@"="];
        if( [[[listItems2 objectAtIndex:1]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"])
        {
            
            listItems2 = [[listItems objectAtIndex:1] componentsSeparatedByString:@"`"];
            self.purchaseHistories = [[NSArray alloc] initWithArray:listItems2];// objectAtIndex:1] componentsSeparatedByString:@","]];
        }
        else{
            self.purchaseHistories = [[NSArray alloc] init];
            listItems = [resultString componentsSeparatedByString:@"|"];
            chkStatus=[listItems objectAtIndex:1];
            listItems2 = [chkStatus componentsSeparatedByString:@"="];
            UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Message"  message:[NSString stringWithFormat:@"%@",[listItems2 objectAtIndex:1]]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    [self.delegate updateView];
}

-(NSDictionary*)loadDataRow:(NSArray *)list {
	
//	NSString* contentfile = [query readTextColumn];
//	NSString* positionindex = [query readTextColumn];
//	NSString* notes = [query readTextColumn];
//	NSInteger bookmarkID = [query readIntColumn];
//	NSString* description = [query readTextColumn];
//	NSInteger chapterno = [query readIntColumn];
//	NSString* date = [query readTextColumn];
    NSString *date = [list objectAtIndex:0];
    NSString *duration = [list objectAtIndex:2];
    NSString *cost = [list objectAtIndex:3];
    
	return [NSDictionary dictionaryWithObjectsAndKeys:date,@"date",duration,@"duration",cost,@"cost",nil];
	
}

-(void)getCallHistory:(NSString *)resultString {
    self.callLogs = [NSMutableDictionary dictionary];
    self.callLogsArray=[[NSMutableArray alloc]init];
    
    if(![REMOVE_WHITELINESPACE(resultString) isEqualToString:@"error"])
	{
        NSArray *listItems = [resultString componentsSeparatedByString:@"~"];
        NSDictionary *statusInfo = [RAZA_APPDELEGATE getInformationFromString:[listItems objectAtIndex:0]];
        if ([[statusInfo objectForKey:@"status"] isEqualToString:@"1"]) {
            NSString *calldetails = [listItems objectAtIndex:1];
            NSArray *calls = [calldetails componentsSeparatedByString:@"`"];
            
            for (NSString *call in calls) {
                
                NSArray *individual = [call componentsSeparatedByString:@"|"];
                [self.callLogsArray addObject:individual];
                NSString *phone = [individual objectAtIndex:1];
                
                NSMutableArray *tempArray = [self.callLogs objectForKey:phone];
                
                if (!tempArray) {
                    tempArray = [NSMutableArray array];
                    [self.callLogs setObject:tempArray forKey:phone];
                }
                
                [tempArray addObject:[self loadDataRow:individual]];
            }
        }
        
        NSMutableArray* _sections = [[NSMutableArray alloc] initWithArray:[self.callLogs allKeys]];
        [_sections sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.callKeys = [NSArray arrayWithArray:_sections];
        
        [self.delegate updateView];
        
    }
}

#pragma mark -
#pragma mark Login Info


-(void)loginResponse:(NSDictionary *)resultString withResponseType:(NSString *)responseType {
    

    //  Login_V1Result LoginResult
    if ([responseType isEqualToString:@"Login_V1Result"]||[responseType isEqualToString:@"Login_V2Result"]  ||[responseType isEqualToString:@"LoginWithPassCode"]) {
        
            if ([[resultString objectForKey:@"ResponseCode"] isEqualToString:@"1"]) {
                [[RazaLoginModel sharedInstance] setLoginInformation:resultString];
            }
            [RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].loginInfo forKey:@"logininfo"];
        
    }
    
 [self.delegate getDataFromModel:resultString withResponseType:responseType];
    
    
    //[self.delegate updateView:nil];
}

-(void)signupResponse:(NSDictionary *)resultString withResponseType:(NSString *)responseType {
    

    [RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].loginInfo forKey:@"logininfo"];
    
   // [self.delegate getDataFromModelforsignup:signupInfo withResponseType:responseType];
    [self.delegate issueNewPin:resultString withResponseType:responseType];
}
-(void)signupResponse_Eligible:(NSDictionary *)resultString withResponseType:(NSString *)responseType {
    
 
    [self.delegate getDataFromModel:resultString withResponseType:responseType];
}
-(void)Send_SMS_MessageResponse:(NSString *)resultString withResponseType:(NSString *)responseType {
    
    NSDictionary *signupInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    
    if (![signupInfo objectForKey:@"error"])
    {
        
        //        [RAZA_USERDEFAULTS setObject:[signupInfo objectForKey:@"id"] forKey:LOGIN_RESPONSE_ID];
        //        [RAZA_USERDEFAULTS setObject:[signupInfo objectForKey:@"sessionid"] forKey:@"sessionid"];
        
        if ([[signupInfo objectForKey:@"status"] isEqualToString:@"1"])
        {
            // do something to save response to any model
            
            //[[RazaLoginModel sharedInstance] setPersonalInformation:signupInfo];
            
        }
    }
    //[RAZA_USERDEFAULTS setObject:[RazaLoginModel sharedInstance].loginInfo forKey:@"logininfo"];
    [self.delegate getDataFromModelforsms:signupInfo withResponseType:responseType];
}
//-(void)getFreeTrialInfo:(NSString *)resultString withResponseType:(NSString *)responseType {
//    
//    //NSDictionary *freeTrialInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
//    
//    //[self.delegate getDataFromModel:freeTrialInfo withResponseType:responseType];
//}

//-(void)getMakeCallInfo:(NSString *)resultString withResponseType:(NSString *)responseType {
//    NSDictionary *freeTrialInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
//    if (![freeTrialInfo objectForKey:@"error"]) {
//        if ([[freeTrialInfo objectForKey:@"status"] isEqualToString:@"1"]) {
//            [[RazaAccountModel sharedInstance] setAccountInformation:freeTrialInfo];
//        }
//    }
//    
//    [self.delegate getDataFromModel:freeTrialInfo withResponseType:responseType];
//}
-(void)loginResponseNewSipServer:(NSDictionary *)resultString withResponseType:(NSString *)responseType {
    
    
    [self.delegate getDataFromModel:resultString withResponseType:responseType];
    
    //[self.delegate updateView:nil];
}

-(void)getMakeCallInfo:(NSString *)resultString withResponseType:(NSString *)responseType {
    NSDictionary *freeTrialInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    if (![freeTrialInfo objectForKey:@"error"]) {
        if ([[freeTrialInfo objectForKey:@"status"] isEqualToString:@"1"]) {
            [[RazaAccountModel sharedInstance] setAccountInformation:freeTrialInfo];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(getDataFromModel:withResponseType:)]) {
            [self.delegate getDataFromModel:freeTrialInfo withResponseType:responseType];
        }
    
    
}



-(void)getBalanceInfo:(NSString *)resultString withResponseType:(NSString *)responseType {
    NSDictionary *balanceInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    if (![balanceInfo objectForKey:@"error"]) {
        if ([[balanceInfo objectForKey:@"status"] isEqualToString:@"1"]) {
            [[RazaAccountModel sharedInstance] setBalanceInformation:balanceInfo];
        }
    }
    if ([self.delegate respondsToSelector:@selector(updateView)]) {
        //do
        [self.delegate updateView];
    }
}


#pragma mark -
#pragma mark Billing Info


-(void)updateBillingInfoResponse:(NSString *)resultString withResponseType:(NSString *)responseType {
    
    NSDictionary *personalInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    
    if (![personalInfo objectForKey:@"error"]) {
        
        [RAZA_USERDEFAULTS setObject:[personalInfo objectForKey:@"sessionid"] forKey:@"sessionid"];
        
    }
    [self.delegate getDataFromModel:personalInfo withResponseType:responseType];
}

-(void)getBillingInfoResponse:(NSString *)resultString withResponseType:(NSString *)responseType {
    
    NSDictionary *personalInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    
    if (![personalInfo objectForKey:@"error"]) {
        
        [RAZA_USERDEFAULTS setObject:[personalInfo objectForKey:@"id"] forKey:LOGIN_RESPONSE_ID];
        if ([[personalInfo objectForKey:@"status"] isEqualToString:@"1"]) {
            [[RazaLoginModel sharedInstance] setPersonalInformation:personalInfo];
        }
    }
    //[self.delegate updateView];
    if ([self.delegate respondsToSelector:@selector(updateView)]) {
        //do
        [self.delegate updateView];
        //[self.delegate getDataFromModel:personalInfo withResponseType:responseType];
    }
}

#pragma mark -
#pragma mark Recharge Info

-(void)getRechargePinInfo:(NSString *)resultString withResponseType:(NSString *)responseType{
    
    NSDictionary *responseInfo = [RAZA_APPDELEGATE getInformationFromString:resultString];
    
    if (![responseInfo objectForKey:@"error"]) {
        
        //TODO : Do something for recharge PIN;
//        [RAZA_USERDEFAULTS setObject:[responseInfo objectForKey:@"id"] forKey:LOGIN_RESPONSE_ID];
//        if ([[responseInfo objectForKey:@"status"] isEqualToString:@"1"]) {
//            [[RazaLoginModel sharedInstance] setPersonalInformation:responseInfo];
//        }
    }
    [self.delegate getDataFromModel:responseInfo withResponseType:responseType];
}

-(void)getNewPinInfo:(NSString *)resultString withResponseType:(NSString *)responseType {
    
    NSDictionary *issueNewPin = [RAZA_APPDELEGATE getInformationFromString:resultString];
    
    if (![issueNewPin objectForKey:@"error"])
    {
        if ([[issueNewPin objectForKey:@"status"] isEqualToString:@"1"])
        {
            
            NSString *pin = [issueNewPin valueForKey:@"pin"];
            
            NSMutableDictionary *oldLoginInfo = [[RAZA_USERDEFAULTS valueForKey:@"logininfo"] mutableCopy];
            
            [oldLoginInfo setObject:pin forKey:@"Pin"];
            
            //clear old login info
            [RAZA_USERDEFAULTS removeObjectForKey:@"logininfo"];
            
            //Create new logininfo after setting new pin value with existing default attributes like email, sessionid, etc..
            [RAZA_USERDEFAULTS setObject:oldLoginInfo forKey:@"logininfo"];
        }
    }
    
    
    [self.delegate getDataFromModel:issueNewPin withResponseType:responseType];
    
    //    if ([self.delegate respondsToSelector:@selector(getDataFromModel:withResponseType:)]) {
    //        [self.delegate getDataFromModel:freeTrialInfo withResponseType:responseType];
    //    }
    
    
}
@end
