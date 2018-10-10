//
//  RazaAccountModel.h
//  Raza
//
//  Created by Praveen S on 20/11/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaAccountModel : NSObject

@property (nonatomic)NSString *accessno, *accountstatus, *balance;
@property (nonatomic)NSString *cardno, *ccexpiration, *ccsecurity;

+ (RazaAccountModel *)sharedInstance;

-(void)setAccountInformation:(NSDictionary *)info;
-(void)setBalanceInformation:(NSDictionary *)info;
@end
