//
//  RazaCountryToModel.h
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaCountryFromModel : NSObject

@property (nonatomic)NSArray *countryList;
@property (nonatomic)NSMutableArray *cityList;
@property (nonatomic)NSMutableDictionary *countryInfo;

@property (nonatomic) NSString *countryID;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *countryCode;

-(id)initWithCountyWithInfo:(NSDictionary *)infoDict;
-(id)initWithJSON:(NSDictionary *)jsonData;
-(id)initWithDictionary:(NSArray *)results;
@end
