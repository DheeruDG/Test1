//
//  RazaDataModel.h
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RazaCountryModel.h"
#import "RazaViewRatesModel.h"
@protocol RazaDataModelDelegate <NSObject>

@optional
-(void)updateView;
-(void)updateViewWithRequestIndentity:(NSString *)requestIndentity;
-(void)getDataFromModel:(NSDictionary *)info withResponseType:(NSString *)responseType;
-(void)getDataFromModelforsignup:(NSDictionary *)info withResponseType:(NSString *)responseType;
-(void)getDataFromModelforsms:(NSDictionary *)info withResponseType:(NSString *)responseType;
-(void)issueNewPin:(NSDictionary *)info withResponseType:(NSString *)responseType;
@end

@interface RazaDataModel : NSObject

@property (nonatomic, strong)NSMutableArray *countryList;
@property (nonatomic, strong)NSMutableArray *rateListByCountry;
@property (nonatomic, strong)NSMutableArray *countryToList, *countryFromList;
@property (nonatomic, strong)NSMutableDictionary *callLogs;
@property (nonatomic, strong)NSMutableArray *callLogsArray;
@property (nonatomic, strong)NSArray *callKeys;
@property (nonatomic, strong)NSArray *purchaseHistories;
@property(nonatomic, weak)id <RazaDataModelDelegate> delegate;

+ (RazaDataModel *)sharedInstance;
-(void)loginResponseNewSipServer:(NSDictionary *)resultString withResponseType:(NSString *)responseType;
-(void)getCountryListByRates:(NSString *)resultString;
-(void)getCountryLists:(NSString *)resultString withSearchType:(NSString *)searchType;
-(void)getPurchaseHistory:(NSString *)resultString;
-(void)getCallHistory:(NSString *)resultString;
-(void)loginResponse:(NSDictionary *)resultString withResponseType:(NSString *)responseType;
-(void)signupResponse:(NSDictionary *)resultString withResponseType:(NSString *)responseType;
-(void)signupResponse_Eligible:(NSDictionary *)resultString withResponseType:(NSString *)responseType;
-(void)Send_SMS_MessageResponse:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)updateBillingInfoResponse:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)getBillingInfoResponse:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)getRechargePinInfo:(NSString *)resultString withResponseType:(NSString *)responseType;
//-(void)getFreeTrialInfo:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)getMakeCallInfo:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)getBalanceInfo:(NSString *)resultString withResponseType:(NSString *)responseType;
-(void)getNewPinInfo:(NSString *)resultString withResponseType:(NSString *)responseType;

@end
