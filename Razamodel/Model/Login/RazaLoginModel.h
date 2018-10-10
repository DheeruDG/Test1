//
//  RazaLoginModel.h
//  Raza
//
//  Created by Praveen S on 19/11/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaLoginModel : NSObject


@property (nonatomic)NSString *memberid, *status, *email, *pin, *usertype, *sessionid, *deviceUDID;
@property (nonatomic)NSString *firstName, *lastName, *streetName, *cityName, *stateName, *zipcode, *countryName;
@property (nonatomic)NSDictionary *loginInfo, *personalInfo;

+ (RazaLoginModel *)sharedInstance;
-(void)setLoginInformation:(NSDictionary *)loginInfo;
-(void)setPersonalInformation:(NSDictionary *)info;

-(void)descriptionInfo;

@end
