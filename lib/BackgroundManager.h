//
//  BackgroundManager.h
//
//  Created by Steve Zaharuk on 3/4/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundManager : NSObject

@property(nonatomic, readonly) BOOL isTaskStarted;

-(void)startTask;
-(void)endTask;
-(BOOL)isInBackground;

@end
