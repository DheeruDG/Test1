//
//  BackgroundManager.m
//
//  Created by Steve Zaharuk on 3/4/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BackgroundManager.h"

@interface BackgroundManager()
{
    UIBackgroundTaskIdentifier _bgTask;
    BOOL _isPlaying;
}

@end

@implementation BackgroundManager

@synthesize isTaskStarted = _isPlaying;

-(void)startTask
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) 
    {
        _isPlaying = YES;
        _bgTask = UIBackgroundTaskInvalid;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
    }    
}

- (void) doBackground:(NSNotification *)aNotification
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)])
    {
        _bgTask = [app beginBackgroundTaskWithExpirationHandler:^
                  {
                      dispatch_async(dispatch_get_main_queue(), ^
                                     {
                                         if (_bgTask != UIBackgroundTaskInvalid)
                                         {
                                             [app endBackgroundTask:_bgTask];
                                             _bgTask = UIBackgroundTaskInvalid;
                                         }
                                     });
                  }];
    }
}

-(void)endTask
{
    _isPlaying = NO;
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(endBackgroundTask:)]) 
    {
        if (_bgTask != UIBackgroundTaskInvalid)
        {
            [app endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        }
    }   
}

-(BOOL)isInBackground
{
    return _isPlaying && (_bgTask != UIBackgroundTaskInvalid);
}



@end
