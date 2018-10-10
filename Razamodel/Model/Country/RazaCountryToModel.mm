//
//  RazaCountryToModel.m
//  Raza
//
//  Created by Praveen S on 11/17/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaCountryToModel.h"

#define ID 0
#define COUNTRYNAME 1
#define COUNTRYCODE 2

@implementation RazaCountryToModel

-(id)initWithCountyWithInfo:(NSDictionary *)infoDict{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

-(id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //_subcategories = [[NSMutableDictionary alloc]init];
    return self;
}
-(id)initWithJSON:(NSDictionary *)jsonData {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.countryInfo = [NSMutableDictionary dictionary];
    self.cityList = [NSMutableArray array];
    //_subcategories = [[NSMutableDictionary alloc]init];
    [self fromJSON:jsonData];
    return self;
}

-(void)fromJSON:(NSDictionary *)jsonData {
    NSArray *tempCity = [NSArray array];
    for (NSString *key in jsonData) {
        NSDictionary *countryDict = [jsonData objectForKey:key];
        self.countryList = [jsonData allKeys];
        for (NSArray *cities in [countryDict allValues]) {
            //[self.cityList addObject:cities];
            tempCity = cities;
            //[self.cityList addObject:[[cities objectEnumerator] nextObject]];
            [self.countryInfo setObject:cities forKey:key];
        }
        //[self.cityList addObject:tempCity];
        
    }
}

-(id)initWithDictionary:(NSArray *)results {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.countryID = [results objectAtIndex:ID];
    self.countryName = [results objectAtIndex:COUNTRYNAME];
    self.countryCode = [results objectAtIndex:COUNTRYCODE];
    
    return self;
}


@end
