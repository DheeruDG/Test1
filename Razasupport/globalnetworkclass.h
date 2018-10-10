//
//  globalnetworkclass.h
//  Raza
//
//  Created by umenit on 7/25/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//
#define kMagicSubtractionNumber 48
#import <Foundation/Foundation.h>

@interface globalnetworkclass : NSObject
-(void)mainsettingplist: (int)checkforfirst globalplist:(NSMutableDictionary *)globalplist pathforglobalplist:(NSString  *)pathforglobalplist;
-(NSArray *)getchatcustomwallpaper;
-(NSArray *)getchatcustomringtone;
-(NSArray*)getchatcounter;
-(NSString*)getsecondpartvalue:(float)secondpartdigit;
//-(UIImage *)generateThumbImage : (NSString *)filepath;
//-(UIImage *)generateThumbImagelive : (NSString *)filepath;
-(BOOL)validation_check:(NSString*)pass_value;
-(BOOL)checkvaliddate:(NSString *)stringdate andyearval:(NSString*)yearselect;
-(BOOL)checkreachbility;
-(void)setwallper :(NSString *)stringtocheck forTime: (NSMutableArray *)globalusername_array forTime2:(NSMutableArray *)globalusername_wallpaper forTime3:(NSString *)chatimage forTime4:(NSMutableDictionary*)globaldictofchatwallpaper forTime5:(NSString *)pathtochange;
-(void)setringtone :(NSString *)stringtocheck globalusername_array: (NSMutableArray *)globalusername_array globalusername_wallpaper:(NSMutableArray *)globalusername_wallpaper chatring:(NSString *)chatring globaldictofchatwallpaper:(NSMutableDictionary*)globaldictofchatwallpaper pathtochange:(NSString *)pathtochange;

-(int)getdeletecounterplist:(NSString*)strofuser username_arraytodelete:(NSMutableArray*)username_arraytodelete userchat_arraytodelete:(NSMutableArray *)userchat_arraytodelete getcounterdicttodelete:(NSMutableDictionary*) getcounterdicttodelete getcounterdicttodeletepath:(NSString*)getcounterdicttodeletepath;
-(void)DELETENETWORKINFORMATIONALL:(NSString*)Deleteinfo;
@end
