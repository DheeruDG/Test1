//
//  RazaTempratureObject.h
//  forcasting
//
//  Created by umenit on 8/8/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AFHTTPRequestOperation.h"
//#import "AFHTTPRequestOperationManager.h"
//#import "UIImageView+WebCache.h"
#import "AFURLSessionManager.h"
#define BASEIMAGEWEATHER @"http://openweathermap.org/img/w/"
@interface RazaTempratureObject : NSObject
@property (strong,nonatomic) NSString *CurrentImage;
@property (strong,nonatomic) NSString *currentTemprature;
@property (strong,nonatomic) NSString *currentTempraturefahrenheit;
@property (strong,nonatomic) NSString *currentName;
@property (strong,nonatomic) NSString *weatherTypeName;

-(UIView*)Returnview:(RazaTempratureObject*)baseobject;
-(void)setlocationmapsidebar:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error))callback;
-(void)setlocationmapsidebarself:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error))callback;
-(RazaTempratureObject*)Tempobject;
-(RazaTempratureObject*)Tempobjectself;
-(UIView*)GetTempratureview:(NSString*)ViewByName andwidthofview:(float)ViewWidth;
-(void)setRecentTempratue:(NSArray*)mainArray andkeyof:(NSString*)keyofrecent andindexval:(int)IndexofReceent;
-(void)getCallerInfo:(NSString*)phonenumber  andapikey:(NSString*)apikey  callback:(void (^)(NSDictionary *result))callback;
-(void)getCallerInfofortempdetail:(NSString*)countryname aanstatename:
(NSString*)statename andapikey:(NSString*)apikey  callback:(void (^)(NSDictionary *result))callback;
//-(void)setlocationmapsidebarselfonly:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error))callback;
-(void)setlocationmapsidebarselfonly:(NSString*)latitude andlongitude:(NSString*)longitude andapikey:(NSString*)apikey  callback:(void (^)(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error,NSString *timestring))callback;
-(NSString*)getDateDayNight:(NSString*)time;
-(void)checkvalforTemp:(NSString*)phonenumber   callback:(void (^)(NSDictionary *result))callback;
@end

