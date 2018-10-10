//
//  RazaViewRatesModel.m
//  Raza
//
//  Created by Praveen S on 11/21/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaViewRatesModel.h"

@implementation RazaViewRatesModel


-(id)initWithDictionary:(NSArray *)results {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.countryName = [results objectAtIndex:2];
    self.price = [results objectAtIndex:4];
    self.countryID = [results objectAtIndex:1];
    
    return self;
}

@end
