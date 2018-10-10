//
//  RazaNotificationObject.m
//  Raza
//
//  Created by umenit on 10/1/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import "RazaNotificationObject.h"

@implementation RazaNotificationObject
+(RazaNotificationObject*)SharedInstance
{
    static RazaNotificationObject *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[RazaNotificationObject alloc] init];
    });
    return __instance;
}
-(NSDate*)backtonsdate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}
-(NSString*)getTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}
-(NSTimeInterval)compareTimeSlot:(NSString*)prevtime
{
    NSString *crttime=[self getTime];
    NSDate *prevdatetime=[self backtonsdate:prevtime];
    NSDate *currentdatetime=[self backtonsdate:crttime];
    NSTimeInterval secondsBetween = [currentdatetime timeIntervalSinceDate:prevdatetime];
    return secondsBetween;
}
-(NSString*)GettrimmedPush:(NSString*)pushstring
{
    //NSString *string = @"'this text has spaces before and after'";
    pushstring = [pushstring substringToIndex:(pushstring.length - 1)];
    pushstring = [pushstring substringFromIndex:(1)];
    return pushstring;
}
-(void)setnotificationformiisedcall
{
    int total=[self getnotifationformissedcall];
    total=total+1;
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"setnotificationformiisedcall"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)getnotifationformissedcall
{

NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"setnotificationformiisedcall"];
    int iInt1 = (int)highScore;
    return iInt1;
}
-(void)setnotificationforchat
{
    int total=[self getnotifationforchat];
    total=total+1;
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"setnotificationforchat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)getnotifationforchat
{
    
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"setnotificationforchat"];
    int iInt1 = (int)highScore;
    return iInt1;
}
-(void)removekeyfornotifity:(NSString*)keyremoval
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyremoval];
     [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray*)modeofpushmsg:(NSString*)pushmsgformat
{
    if ([self containsString:@"Videocall from" andmainstringcontains:pushmsgformat]) {
        NSArray *arr = [pushmsgformat componentsSeparatedByString:@"Videocall from "];
        NSMutableArray *arrmain=[[NSMutableArray alloc]init];
        [arrmain addObject:@"Videocall from "];
        [arrmain addObject:[arr objectAtIndex:1]];
        return arrmain;
    }
    else if ([self containsString:@"Voicecall from" andmainstringcontains:pushmsgformat])
    {
        NSArray *arr = [pushmsgformat componentsSeparatedByString:@"Voicecall from "];
        NSMutableArray *arrmain=[[NSMutableArray alloc]init];
        [arrmain addObject:@"Voicecall from "];
        [arrmain addObject:[arr objectAtIndex:1]];
        
        return arrmain;
    }
    else if ([self containsString:@"Missed Voice call" andmainstringcontains:pushmsgformat])
    {
        NSArray *arr = [pushmsgformat componentsSeparatedByString:@"Missed Voice call from "];
        NSMutableArray *arrmain=[[NSMutableArray alloc]init];
        [arrmain addObject:@"Missed Voice call from "];
        [arrmain addObject:[arr objectAtIndex:1]];
        
        return arrmain;
    }
    else if ([self containsString:@"Missed Video call" andmainstringcontains:pushmsgformat])
    {
        NSArray *arr = [pushmsgformat componentsSeparatedByString:@"Missed Video call from "];
        NSMutableArray *arrmain=[[NSMutableArray alloc]init];
        [arrmain addObject:@"Missed Video call from "];
        [arrmain addObject:[arr objectAtIndex:1]];
        
        return arrmain;
    }
    else if ([self containsString:@"Missed call from" andmainstringcontains:pushmsgformat])
    {
        NSArray *arr = [pushmsgformat componentsSeparatedByString:@"Missed call from "];
        NSMutableArray *arrmain=[[NSMutableArray alloc]init];
        [arrmain addObject:@"Missed call from "];
        [arrmain addObject:[arr objectAtIndex:1]];
        
        return arrmain;
    }

    else
    {
        NSArray *arr= [self checkstringpushmessage:pushmsgformat];
        return arr;
    }
}
-(NSArray*)checkstringpushmessage:(NSString*)msgstring
{
    NSString *strstring= msgstring;
    NSRange range = [strstring rangeOfString:@":"];
    NSString *result;
    NSString *result2;
    if(range.location != NSNotFound)
    {
        result = [strstring substringWithRange:NSMakeRange(0, range.location)];
        result2 = [strstring substringWithRange:NSMakeRange(range.location+1, (strstring.length-range.location)-1)];
        NSLog(@"fgfg");
    }
    NSArray *arr=[[NSArray alloc]initWithObjects:result,result2,nil];
    return arr;
}
- (BOOL) containsString: (NSString*) substring andmainstringcontains:(NSString*)mainstring
{
    NSRange range = [mainstring rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}
@end
