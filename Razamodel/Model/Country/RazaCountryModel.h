//
//  RazaCountryModel.h
//  Raza
//
//  Created by Praveen S on 11/21/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaCountryModel : NSObject

@property (nonatomic) NSDictionary *countryInfo;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *countryID;

-(id)initWithDictionary:(NSArray *)results;

@end
