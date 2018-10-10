//
//  RazaAccountModel.m
//  Raza
//
//  Created by Praveen S on 20/11/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaAccountModel.h"

static RazaAccountModel *sharedInstance = nil;

@implementation RazaAccountModel

+(void)initialize {
    sharedInstance = [[RazaAccountModel alloc]init];
}

+(RazaAccountModel *)sharedInstance {
    return sharedInstance;
}

-(void)setAccountInformation:(NSDictionary *)info {
    self.accessno = [info objectForKey:@"accessno"];
    self.accountstatus = [info objectForKey:@"status"];
    //self.balance = [info objectForKey:@"balance"];
}

-(void)setBalanceInformation:(NSDictionary *)info {
    self.balance = [info objectForKey:@"balance"];
}

@end
