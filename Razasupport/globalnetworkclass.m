//
//  globalnetworkclass.m
//  Raza
//
//  Created by umenit on 7/25/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import "globalnetworkclass.h"

@implementation globalnetworkclass
-(void)mainsettingplist: (int)checkforfirst globalplist:(NSMutableDictionary *)globalplist pathforglobalplist:(NSString  *)pathforglobalplist
{
    
    if (checkforfirst==1)
    {
        
        NSMutableArray *settingplistname =[[NSMutableArray alloc]initWithArray:[globalplist valueForKey:@"name"]];
        NSMutableArray *settingplistvalueofchk =[[NSMutableArray alloc]initWithArray:[globalplist valueForKey:@"valueof"]];
        if ([[settingplistname objectAtIndex:1] isEqual:@"Minutes"]&&[[settingplistvalueofchk objectAtIndex:1] isEqual:@"1"])
        {
            NSMutableArray *settingplistorder =[[NSMutableArray alloc]initWithArray:[globalplist valueForKey:@"order"]];
            NSMutableArray *settingplistvalueof =[[NSMutableArray alloc]initWithArray:[globalplist valueForKey:@"valueof"]];
            
            
            [settingplistname exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [settingplistorder exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [settingplistvalueof exchangeObjectAtIndex:0 withObjectAtIndex:1];
            
            [globalplist setObject:settingplistname forKey:@"name"];
            [globalplist setObject:settingplistorder forKey:@"order"];
            [globalplist setObject:settingplistvalueof forKey:@"valueof"];
            [globalplist writeToFile: pathforglobalplist atomically:YES];
        }
        
    }
    
}

-(NSArray *)getchatcustomwallpaper
{
    NSMutableDictionary *dataofwallpaper ;
    dataofwallpaper=[[NSMutableDictionary alloc]init];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *pathtogetwllpaper;
    pathtogetwllpaper = [documentsDirectory stringByAppendingPathComponent:@"Raza_chat_wallpaper.plist"]; //3
    // NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathtogetwllpaper]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Raza_chat_wallpaper" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathtogetwllpaper error:&error]; //6
    }
    
    
    dataofwallpaper = [[NSMutableDictionary alloc] initWithContentsOfFile: pathtogetwllpaper];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:dataofwallpaper,pathtogetwllpaper, nil];
    return arr;
}
-(NSArray *)getchatcustomringtone
{
    NSMutableDictionary *dataofwallpaper ;
    dataofwallpaper=[[NSMutableDictionary alloc]init];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *pathtogetwllpaper;
    pathtogetwllpaper = [documentsDirectory stringByAppendingPathComponent:@"Raza_chat_audio.plist"]; //3
    // NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathtogetwllpaper]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Raza_chat_audio" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathtogetwllpaper error:&error]; //6
    }
    
    
    dataofwallpaper = [[NSMutableDictionary alloc] initWithContentsOfFile: pathtogetwllpaper];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:dataofwallpaper,pathtogetwllpaper, nil];
    return arr;
}
-(void)setwallper :(NSString *)stringtocheck forTime: (NSMutableArray *)globalusername_array forTime2:(NSMutableArray *)globalusername_wallpaper forTime3:(NSString *)chatimage forTime4:(NSMutableDictionary*)globaldictofchatwallpaper forTime5:(NSString *)pathtochange
{
    if (![stringtocheck isEqualToString:@"Default"])
    {
        NSArray* username = [stringtocheck componentsSeparatedByString:@"@"];
        NSArray *final=[[username objectAtIndex:0] componentsSeparatedByString:@":"] ;
        
        if ([globalusername_array containsObject:[final objectAtIndex:1]])
        {
            NSInteger anIndex=[globalusername_array indexOfObject:[final objectAtIndex:1]];
            [globalusername_wallpaper replaceObjectAtIndex:anIndex withObject:chatimage];
        }
        else
        {
            [globalusername_array addObject:[final objectAtIndex:1]];
            [globalusername_wallpaper addObject:chatimage];
        }
        
        
        
        
        
    }
    else
    {
        
        NSInteger anIndex=[globalusername_array indexOfObject:@"Default"];
        [globalusername_wallpaper replaceObjectAtIndex:anIndex withObject:chatimage];
        
    }
    
    [globaldictofchatwallpaper setObject:globalusername_array forKey:@"owner"];
    [globaldictofchatwallpaper setObject:globalusername_wallpaper forKey:@"wallpaper"];
    [globaldictofchatwallpaper writeToFile: pathtochange atomically:YES];
}
-(void)setringtone :(NSString *)stringtocheck globalusername_array: (NSMutableArray *)globalusername_array globalusername_wallpaper:(NSMutableArray *)globalusername_wallpaper chatring:(NSString *)chatring globaldictofchatwallpaper:(NSMutableDictionary*)globaldictofchatwallpaper pathtochange:(NSString *)pathtochange
{
    if (![stringtocheck isEqualToString:@"Default"])
    {
      
        
        if ([globalusername_array containsObject:stringtocheck])
        {
            NSInteger anIndex=[globalusername_array indexOfObject:stringtocheck];
            [globalusername_wallpaper replaceObjectAtIndex:anIndex withObject:chatring];
        }
        else
        {
            [globalusername_array addObject:stringtocheck];
            [globalusername_wallpaper addObject:chatring];
        }
        
        
        
        
        
    }
    else
    {
        
        NSInteger anIndex=[globalusername_array indexOfObject:@"Default"];
        [globalusername_wallpaper replaceObjectAtIndex:anIndex withObject:chatring];
        
    }
    
    [globaldictofchatwallpaper setObject:globalusername_array forKey:@"owner"];
    [globaldictofchatwallpaper setObject:globalusername_wallpaper forKey:@"audio"];
    [globaldictofchatwallpaper writeToFile: pathtochange atomically:YES];
}

-(NSArray *)getchatcounter
{
    NSMutableDictionary *dataofwallpaper ;
    dataofwallpaper=[[NSMutableDictionary alloc]init];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *pathtogetwllpaper;
    pathtogetwllpaper = [documentsDirectory stringByAppendingPathComponent:@"Raza_chat_counter.plist"]; //3
    // NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathtogetwllpaper]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Raza_chat_counter" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathtogetwllpaper error:&error]; //6
    }
    
    
    dataofwallpaper = [[NSMutableDictionary alloc] initWithContentsOfFile: pathtogetwllpaper];
    NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:dataofwallpaper,pathtogetwllpaper, nil];
    return arr;
}

-(int)getdeletecounterplist:(NSString*)strofuser username_arraytodelete:(NSMutableArray*)username_arraytodelete userchat_arraytodelete:(NSMutableArray *)userchat_arraytodelete getcounterdicttodelete:(NSMutableDictionary*) getcounterdicttodelete getcounterdicttodeletepath:(NSString*)getcounterdicttodeletepath
{
  //  NSArray* username = [strofuser componentsSeparatedByString:@"@"];
  //  NSArray *final=[[username objectAtIndex:0] componentsSeparatedByString:@":"] ;
    if ([username_arraytodelete containsObject:strofuser])
    {
        
        int a=(int)[username_arraytodelete indexOfObject:strofuser];
        [username_arraytodelete removeObjectAtIndex:a];
        [userchat_arraytodelete removeObjectAtIndex:a];
        [getcounterdicttodelete setObject:username_arraytodelete forKey:@"owner"];
        [getcounterdicttodelete setObject:userchat_arraytodelete forKey:@"counter"];
        [getcounterdicttodelete writeToFile: getcounterdicttodeletepath atomically:YES];
        
    }
    double sum = 0;
    for (NSNumber * n in userchat_arraytodelete)
    {
        sum += [n doubleValue];
    }
    
    int valuetoprint=(int)sum;
    return valuetoprint;
}

-(NSString*)getsecondpartvalue:(float)secondpartdigit
{
    float value = secondpartdigit;
    float integral;
    float divisor = 1000.0f;
    float fractional = modff(value, &integral);  // breaks a float into fractional and integral parts
    NSString * topDigits;
    int xyz = (int)fmodf(fractional*divisor, divisor);  // modulo (cannot just use %)
    if ([[NSString stringWithFormat:@"%d",xyz] length]>=2) {
        topDigits= [[NSString stringWithFormat:@"%d",xyz] substringToIndex:2];
    }
    else if(secondpartdigit>=1)
    {
        topDigits = [NSString stringWithFormat:@"100"];
    }
    else
        topDigits = [NSString stringWithFormat:@"%d",xyz];
    return topDigits;

}
//-(UIImage *)generateThumbImage : (NSString *)filepath
//{
//   NSURL *url = [NSURL fileURLWithPath:filepath];
//   
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//    CMTime time = [asset duration];
//    time.value = 0;
//    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
//    
//    return thumbnail;
//}
//-(UIImage *)generateThumbImagelive : (NSString *)filepath
//{
//  NSURL *url=[NSURL URLWithString:filepath];
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//    CMTime time = [asset duration];
//    time.value = 0;
//    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
//    
//    return thumbnail;
//}

-(BOOL)validation_check:(NSString *)cardNumber
{
    
    int Luhn = 0;
    
    // I'm running through my string backwards
    for (int i=0;i<[cardNumber length];i++)
    {
        NSUInteger count = [cardNumber length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
        int doubled = [[NSNumber numberWithUnsignedChar:[cardNumber characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
        if (i % 2)
        {doubled = doubled*2;}
        
        NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
        
        if ([[NSString stringWithFormat:@"%d",doubled] length] > 1)
        {   Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
            Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;}
        else
        {Luhn = Luhn + doubled;}
    }
    
    if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
    {
      // NSLog(@"yes");
        return true;
    }
    else
    {
        
       // NSLog(@"k");
        return false;
    }
    
}
-(BOOL)checkvaliddate:(NSString *)stringdate andyearval:(NSString*)yearselect
{
    //=======current month======
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
    NSInteger currentmonth = [dateComponents month];
    NSInteger currentyear=[dateComponents year];
    
    //=====selected month======
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSDate *aDate = [formatter dateFromString:stringdate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:aDate];
    NSInteger selectedtmonth = [components month];
    int selectedyear=[yearselect intValue];
    
    if (selectedyear==currentyear)
    {
        if(selectedtmonth>=currentmonth)
        {
            return YES;
        }
        else
            return NO;
    }
    return YES;
}
-(BOOL)checkreachbility
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus statusfortest = [reachability currentReachabilityStatus];
    
    if(statusfortest == NotReachable)
    {
        //No internet
        return NO;
    }
    return YES;
    
}

-(void)DELETENETWORKINFORMATIONALL:(NSString*)Deleteinfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:Deleteinfo];
    [fileManager removeItemAtPath: fullPath error:NULL];
}

@end
