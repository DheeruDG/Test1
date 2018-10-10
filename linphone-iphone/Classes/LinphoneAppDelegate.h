/* LinphoneAppDelegate.h
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */                                                                           
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import <UIKit/UIKit.h>
#import <PushKit/PushKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>

#import "LinphoneCoreSettingsStore.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AFURLSessionManager.h"
#import "RazaNotificationObject.h"
#import "UIImage+animatedGIF.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XMLDictionary.h"
#import "XMLReader.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BackgroundManager.h"
#import "BackgroundLayer.h"
#import <HockeySDK/HockeySDK.h>
#import "ProviderDelegate.h"
//#import "Crashlib/Fabric/iOS/Fabric.framework/Headers/Fabric.h"
//#import "Crashlib/Crashlytics/iOS/Crashlytics.framework/Headers/Crashlytics.h"
//#import <Crashlytics/Crashlytics.h>
//#import <Fabric/Fabric.h>
//#import <Fabric/Fabric.h>
@interface LinphoneAppDelegate : NSObject <UIApplicationDelegate, PKPushRegistryDelegate, UNUserNotificationCenterDelegate,NSXMLParserDelegate,AVAudioSessionDelegate> {
    
    @private
	UIBackgroundTaskIdentifier bgStartId;
    BOOL startedInBackground;
   // CLLocationManager *locationManager;
    //CLLocation *currentLocation;
    UIImageView *iv;
    UIView *Razacallview;
    UILabel   *label;
    NSString *callingnumber;
    UILocalNotification* localNotification;
    int counter;
    AVAudioPlayer  *playertest;
    BackgroundManager* _bgManager;
    LinphoneCall *durationcall;
    NSTimer *durationtimer;
}
-(void)showdurationcalling;
-(void)hidedurationcalling;
-(void)HIDELABEL;
-(void)disconnectcallaction;
- (void)processRemoteNotification:(NSDictionary*)userInfo;
- (void)registerForNotifications:(UIApplication *)app;

@property (strong, nonatomic) UILabel *labelforcallduration;
@property (nonatomic, retain) UIAlertController *waitingIndicator;
@property (nonatomic, retain) NSString *configURL;
@property (nonatomic, strong) UIWindow* window;
@property PKPushRegistry* voipRegistry;
-(NSDictionary *)getInformationFromString:(NSString *)resultString;
@property (strong, nonatomic) NSURL *baseURL;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *ipAddress;
- (NSString*)deviceToken;
-(NSDictionary *)getDictionaryFromString:(NSString *)resultString separatedBy:(NSString *)character withKeyString:(NSString *)keyString withIndex:(int)keyIndex;
-(NSArray *)getArrayFromRequestString:(NSString *)resultString;
@property (strong,nonatomic) NSString *latitudelongitude;
@property (assign)BOOL internetActive;
-(BOOL)checkNetworkPriorRequest;
@property (strong) NSString *internetMessage;
-(void)showIndeterminateMessage:(NSString *)error withShortMessage:(BOOL)flag;
@property (nonatomic, strong) MBProgressHUD *hudIndicator;
@property (nonatomic, strong) MBProgressHUD *hudIndeterminate;
-(void)hideIndeterminateIndicator:(BOOL)flag;
-(void)showMessage:(NSString *)error withMode:(MBProgressHUDMode)mode withDelay:(NSTimeInterval)delay withShortMessage:(BOOL)flag;
@property (nonatomic, strong) NSDictionary *appCountriesFlag;
@property (nonatomic, strong) UIAlertView *razaAlertView;
-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle ;
-(NSString *)getDateInMMYY:(NSString *)targetdate;
-(BOOL)isValidEmail:(NSString *)checkString;
- (NSString *)getIPAddress;
-(NSString *)pushcallingraza:(NSString*)callednumbervia;
-(NSString*)getTime;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (void)requestCameraPermissionsIfNeeded;
- (void)RazauserCount:(id)sender;
@property ProviderDelegate *del;
@end

