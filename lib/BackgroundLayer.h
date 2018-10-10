//
//  BackgroundLayer.h
//  SocialKids
//
//  Created by UMENIT on 1/4/17.
//  Copyright © 2017 UMENIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject

+(CAGradientLayer*) navHeaderGradient;
+ (CAGradientLayer*) linearGradient;
+ (CAGradientLayer*) superViewGradient;

@end
