//
//  RazaLoginModel.m
//  Raza
//
//  Created by Praveen S on 19/11/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaLoginModel.h"

static RazaLoginModel *sharedInstance = nil;

@implementation RazaLoginModel

+(void)initialize {
    sharedInstance = [[RazaLoginModel alloc]init];
}

+(RazaLoginModel *)sharedInstance {
    return sharedInstance;
}

-(void)setLoginInformation:(NSDictionary *)loginInfo {
    
//    self.memberid = [loginInfo objectForKey:@"id"];
//    self.status = [loginInfo objectForKey:@"status"];
//    self.email = [loginInfo objectForKey:@"email"];
//    self.pin = [loginInfo objectForKey:@"pin"];
//    self.usertype = [loginInfo objectForKey:@"usertype"];
//    self.sessionid = [loginInfo objectForKey:@"sessionid"];
//    self.deviceUDID = [loginInfo objectForKey:@"deviceid"];
    self.loginInfo = loginInfo;
}

-(void)setPersonalInformation:(NSDictionary *)info {
    
    self.firstName = [info objectForKey:@"fname"];
    self.lastName = [info objectForKey:@"lname"];
    self.streetName = [info objectForKey:@"address"];
    self.cityName = [info objectForKey:@"city"];
    self.stateName = [info objectForKey:@"state"];
    self.zipcode = [info objectForKey:@"zipcode"];
    self.countryName = [info objectForKey:@"country"];
    self.personalInfo = info;
}

-(void)descriptionInfo {
    
}
@end
