//
//  BackgroundLayer.m
//  SocialKids
//
//  Created by UMENIT on 1/4/17.
//  Copyright © 2017 UMENIT. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer


+ (CAGradientLayer*) navHeaderGradient {
    
    UIColor *colorTwo = [UIColor colorWithRed:4/255.0 green:144/255.0 blue:238/255.0  alpha:1];
    UIColor *colorOne = [UIColor colorWithRed:3/255.0 green:103/255.0 blue:222/255.0  alpha:1];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    
    return headerLayer;
    
}

+ (CAGradientLayer*) linearGradient {
    
    UIColor *colorTwo = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0  alpha:1];
    UIColor *colorOne = [UIColor colorWithRed:230/255.0 green:22/255.0 blue:127/255.0  alpha:1];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    
    return headerLayer;
    
}

+ (CAGradientLayer*) superViewGradient {
    
    UIColor *colorTwo = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0  alpha:1];
    UIColor *colorOne = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0  alpha:0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    
    return headerLayer;
    
}



@end
