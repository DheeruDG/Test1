/* LinphoneAppDelegate.m
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

#import "PhoneMainView.h"
#import "ContactsListView.h"
#import "ContactDetailsView.h"
#import "ShopView.h"
#import "linphoneAppDelegate.h"
#import "AddressBook/ABPerson.h"
#import "DGActivityIndicatorView.h"
#import "CoreTelephony/CTCallCenter.h"
#import "CoreTelephony/CTCall.h"

#import "LinphoneCoreSettingsStore.h"

#include "LinphoneManager.h"
#include "linphone/linphonecore.h"
//#import <HockeySDK/HockeySDK.h>
static NSString * const DeviceTokenKey = @"DeviceToken";
@implementation LinphoneAppDelegate

@synthesize configURL;
@synthesize window;

#pragma mark - Lifecycle Functions

- (id)init {
    self = [super init];
    if (self != nil) {
        startedInBackground = FALSE;
    }
    return self;
}

#pragma mark -

- (void)applicationDidEnterBackground:(UIApplication *)application {
    LOGI(@"%@", NSStringFromSelector(_cmd));
    //  [Razauser SharedInstance].callmode=nil;
    //[Razauser SharedInstance].pausecounter=0;
    [Razauser SharedInstance].modeofview=nil;
    [self HIDELABEL];
    pushdict=nil;
    [self disconnectcallaction];
    [self hidecontrol];
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max && (linphone_core_get_calls_nb(LC) == 0)) {
    //        //linphone_core_set_network_reachable(LC, FALSE);
    //        //LinphoneManager.instance.connectivity = none;
    //    }
    [LinphoneManager.instance enterBackgroundMode];
    if (LC!=NULL)
    {
        if ((linphone_core_get_calls_nb(LC) == 0))
            //linphone_core_destroy(LC);
            [LinphoneManager.instance destroyLinphoneCore:@"remove"];
        NSLog(@"");
    }
    
    
    if (LC==NULL) {
        [LinphoneManager.instance createLinphoneCore];
    }
    //    label  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    //    label.text = @"Connecting....";
    //    [label setBackgroundColor:[UIColor whiteColor]];
    //    [self.window addSubview:label];
    //    [self.window bringSubviewToFront:label];
    //    [self.window makeKeyAndVisible];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self setaudiomode];
    //        [self set];
    //    });
    //  [[UIApplication sharedApplication] endBackgroundTask:counterTask];
    //  [self playringrepete];
}
-(void)playringrepete
{
    //    if(_bgManager == nil)
    //        _bgManager = [[BackgroundManager alloc]init];
    //
    //    [_bgManager startTask];
    [self updob];
    // [self performSelector:@selector(updob) withObject:self afterDelay:3.0 ];
}
-(void)updob
{
    [self setaudiomode];
    [self set];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    LOGI(@"%@", NSStringFromSelector(_cmd));
    LinphoneCall *call = linphone_core_get_current_call(LC);
    //[LinphoneManager.instance destroyLinphoneCore];
    if (call) {
        /* save call context */
        LinphoneManager *instance = LinphoneManager.instance;
        instance->currentCallContextBeforeGoingBackground.call = call;
        instance->currentCallContextBeforeGoingBackground.cameraIsEnabled = linphone_call_camera_enabled(call);
        
        const LinphoneCallParams *params = linphone_call_get_current_params(call);
        if (linphone_call_params_video_enabled(params)) {
            linphone_call_enable_camera(call, false);
        }
    }
    //if (call) {
    
    // }
    //	if (![LinphoneManager.instance resignActive]) {
    //	}
    //    linphone_core_set_network_reachable(LC,TRUE);
}
-(void)HIDELABEL
{
    [label removeFromSuperview];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [basetimer invalidate];
    [playertest stop];
    [_bgManager endTask];
    // [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(loadmissedcounter) userInfo:nil repeats:NO];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (LC!=NULL) {
        LinphoneCall *call = linphone_core_get_current_call(LC);
        if (!call) {
            
            UICompositeViewDescription *vv=PhoneMainView.instance.currentView;//RazaSignUpViewController Razasignup_verification
            
            if (![vv.name isEqualToString:@"RazaLoginViewController"] && ![vv.name isEqualToString:@"RazaSignUpViewController"] && ![vv.name isEqualToString:@"Razasignup_verification"] &&![vv.name isEqualToString:@"RazaTermsViewController"])
            {
                //  NSLog(@"");
                if (LC!=NULL)
                {
                    LinphoneProxyConfig *default_proxy1 = linphone_core_get_default_proxy_config(LC);
                    if (default_proxy1!=NULL)
                    {
                        int stat=   linphone_proxy_config_get_state(default_proxy1);
                        if (stat!=LinphoneRegistrationOk)
                            //ChatsListView
                            // [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
                        {
                            //                            if ([vv.name isEqualToString:@"ChatsListView"] || [vv.name isEqualToString:@"ChatConversationView"]) {
                            
                            
                            [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
                            //}
                            
                            //  [PhoneMainView.instance popCurrentView];
                            // [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
                            NSLog(@"k");
                        }
                    }
                }
            }
        }
    }
    
    [self performSelector:@selector(HIDELABEL) withObject:self afterDelay:10];
    LOGI(@"%@", NSStringFromSelector(_cmd));
    if (LC!=NULL) {
        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
        if (default_proxy!=NULL) {
            int stat=   linphone_proxy_config_get_state(default_proxy);
            if (stat!=LinphoneRegistrationOk) {
                if (![Razauser SharedInstance].modeofview.length) {
                    if (LC!=NULL)
                        if ((linphone_core_get_calls_nb(LC) == 0))
                            if (![[pushdict objectForKey:@"pushtype"] length])
                            {
                                // [LinphoneManager.instance destroyLinphoneCore:@"remove"];
                                //  if (LC==NULL) {
                                // [LinphoneManager.instance startLinphoneCore];
                            }
                }
                else
                    [Razauser SharedInstance].modeofview=nil;
            }
        }
    }
    
    //  [[Razauser SharedInstance]ShowWaitingshort:nil andtime:10.0];
    //if (![[pushdict objectForKey:@"pushtype"] length])
    
    //}
    if (startedInBackground) {
        startedInBackground = FALSE;
        [PhoneMainView.instance startUp];
        [PhoneMainView.instance updateStatusBar:nil];
    }
    LinphoneManager *instance = LinphoneManager.instance;
    
    [instance becomeActive];
    
    if (instance.fastAddressBook.needToUpdate) {
        //Update address book for external changes
        if (PhoneMainView.instance.currentView == ContactsListView.compositeViewDescription || PhoneMainView.instance.currentView == ContactDetailsView.compositeViewDescription||PhoneMainView.instance.currentView == ChatConversationView.compositeViewDescription) {
            [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
        }
        [instance.fastAddressBook reload];
        instance.fastAddressBook.needToUpdate = FALSE;
        const MSList *lists = linphone_core_get_friends_lists(LC);
        while (lists) {
            linphone_friend_list_update_subscriptions(lists->data);
            lists = lists->next;
        }
    }
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
    
    if (call) {
        if (call == instance->currentCallContextBeforeGoingBackground.call) {
            const LinphoneCallParams *params = linphone_call_get_current_params(call);
            if (linphone_call_params_video_enabled(params)) {
                linphone_call_enable_camera(call, instance->currentCallContextBeforeGoingBackground.cameraIsEnabled);
            }
            instance->currentCallContextBeforeGoingBackground.call = 0;
        } else if (linphone_call_get_state(call) == LinphoneCallIncomingReceived) {
            [PhoneMainView.instance displayIncomingCall:call];
            // in this case, the ringing sound comes from the notification.
            // To stop it we have to do the iOS7 ring fix...
            [self fixRing];
        }
    }
    [LinphoneManager.instance.iapManager check];
    [self loadmissedcounter];
    // if (!call)
    // {
    //    UICompositeViewDescription *vv=PhoneMainView.instance.currentView;//RazaSignUpViewController Razasignup_verification
    //
    //   if (![vv.name isEqualToString:@"RazaLoginViewController"] && ![vv.name isEqualToString:@"RazaSignUpViewController"] && ![vv.name isEqualToString:@"Razasignup_verification"] &&![vv.name isEqualToString:@"RazaTermsViewController"])
    //   {
    //     //  NSLog(@"");
    //       if (LC!=NULL)
    //       {
    //           LinphoneProxyConfig *default_proxy1 = linphone_core_get_default_proxy_config(LC);
    //       if (default_proxy1!=NULL)
    //       {
    //           int stat=   linphone_proxy_config_get_state(default_proxy1);
    //       if (stat!=LinphoneRegistrationOk)
    //       // [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    //           NSLog(@"k");
    //       }
    //       }
    //   }
    // }
}

#pragma deploymate push "ignored-api-availability"
- (UIUserNotificationCategory *)getMessageNotificationCategory {
    NSArray *actions;
    
    if ([[UIDevice.currentDevice systemVersion] floatValue] < 9 ||
        [LinphoneManager.instance lpConfigBoolForKey:@"show_msg_in_notif"] == NO) {
        
        UIMutableUserNotificationAction *reply = [[UIMutableUserNotificationAction alloc] init];
        reply.identifier = @"reply";
        reply.title = NSLocalizedString(@"Reply", nil);
        reply.activationMode = UIUserNotificationActivationModeForeground;
        reply.destructive = NO;
        reply.authenticationRequired = YES;
        
        UIMutableUserNotificationAction *mark_read = [[UIMutableUserNotificationAction alloc] init];
        mark_read.identifier = @"mark_read";
        mark_read.title = NSLocalizedString(@"Mark Read", nil);
        mark_read.activationMode = UIUserNotificationActivationModeBackground;
        mark_read.destructive = NO;
        mark_read.authenticationRequired = NO;
        
        actions = @[ mark_read, reply ];
    } else {
        // iOS 9 allows for inline reply. We don't propose mark_read in this case
        UIMutableUserNotificationAction *reply_inline = [[UIMutableUserNotificationAction alloc] init];
        
        reply_inline.identifier = @"reply_inline";
        reply_inline.title = NSLocalizedString(@"Reply", nil);
        reply_inline.activationMode = UIUserNotificationActivationModeBackground;
        reply_inline.destructive = NO;
        reply_inline.authenticationRequired = NO;
        reply_inline.behavior = UIUserNotificationActionBehaviorTextInput;
        
        actions = @[ reply_inline ];
    }
    
    UIMutableUserNotificationCategory *localRingNotifAction = [[UIMutableUserNotificationCategory alloc] init];
    localRingNotifAction.identifier = @"incoming_msg";
    [localRingNotifAction setActions:actions forContext:UIUserNotificationActionContextDefault];
    [localRingNotifAction setActions:actions forContext:UIUserNotificationActionContextMinimal];
    
    return localRingNotifAction;
}

- (UIUserNotificationCategory *)getCallNotificationCategory {
    UIMutableUserNotificationAction *answer = [[UIMutableUserNotificationAction alloc] init];
    answer.identifier = @"answer";
    answer.title = NSLocalizedString(@"Answer", nil);
    answer.activationMode = UIUserNotificationActivationModeForeground;
    answer.destructive = NO;
    answer.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *decline = [[UIMutableUserNotificationAction alloc] init];
    decline.identifier = @"decline";
    decline.title = NSLocalizedString(@"Decline", nil);
    decline.activationMode = UIUserNotificationActivationModeBackground;
    decline.destructive = YES;
    decline.authenticationRequired = NO;
    
    NSArray *localRingActions = @[ decline, answer ];
    
    UIMutableUserNotificationCategory *localRingNotifAction = [[UIMutableUserNotificationCategory alloc] init];
    localRingNotifAction.identifier = @"incoming_call";
    [localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextDefault];
    [localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextMinimal];
    
    return localRingNotifAction;
}

- (UIUserNotificationCategory *)getAccountExpiryNotificationCategory {
    
    UIMutableUserNotificationCategory *expiryNotification = [[UIMutableUserNotificationCategory alloc] init];
    expiryNotification.identifier = @"expiry_notification";
    return expiryNotification;
}


- (void)registerForNotifications:(UIApplication *)app {
    self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    self.voipRegistry.delegate = self;
    
    // Initiate registration.
    self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
    //        // Call category
    //        UNNotificationAction *act_ans =
    //        [UNNotificationAction actionWithIdentifier:@"Answer"
    //                                             title:NSLocalizedString(@"Answer", nil)
    //                                           options:UNNotificationActionOptionForeground];
    //        UNNotificationAction *act_dec = [UNNotificationAction actionWithIdentifier:@"Decline"
    //                                                                             title:NSLocalizedString(@"Decline", nil)
    //                                                                           options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_call =
    //        [UNNotificationCategory categoryWithIdentifier:@"call_cat"
    //                                               actions:[NSArray arrayWithObjects:act_ans, act_dec, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        // Msg category
    //        UNTextInputNotificationAction *act_reply =
    //        [UNTextInputNotificationAction actionWithIdentifier:@"Reply"
    //                                                      title:NSLocalizedString(@"Reply", nil)
    //                                                    options:UNNotificationActionOptionNone];
    //        UNNotificationAction *act_seen =
    //        [UNNotificationAction actionWithIdentifier:@"Seen"
    //                                             title:NSLocalizedString(@"Mark as seen", nil)
    //                                           options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_msg =
    //        [UNNotificationCategory categoryWithIdentifier:@"msg_cat"
    //                                               actions:[NSArray arrayWithObjects:act_reply, act_seen, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        // Video Request Category
    //        UNNotificationAction *act_accept =
    //        [UNNotificationAction actionWithIdentifier:@"Accept"
    //                                             title:NSLocalizedString(@"Accept", nil)
    //                                           options:UNNotificationActionOptionForeground];
    //
    //        UNNotificationAction *act_refuse = [UNNotificationAction actionWithIdentifier:@"Cancel"
    //                                                                                title:NSLocalizedString(@"Cancel", nil)
    //                                                                              options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *video_call =
    //        [UNNotificationCategory categoryWithIdentifier:@"video_request"
    //                                               actions:[NSArray arrayWithObjects:act_accept, act_refuse, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        // ZRTP verification category
    //        UNNotificationAction *act_confirm = [UNNotificationAction actionWithIdentifier:@"Confirm"
    //                                                                                 title:NSLocalizedString(@"Accept", nil)
    //                                                                               options:UNNotificationActionOptionNone];
    //
    //        UNNotificationAction *act_deny = [UNNotificationAction actionWithIdentifier:@"Deny"
    //                                                                              title:NSLocalizedString(@"Deny", nil)
    //                                                                            options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_zrtp =
    //        [UNNotificationCategory categoryWithIdentifier:@"zrtp_request"
    //                                               actions:[NSArray arrayWithObjects:act_confirm, act_deny, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    //        [[UNUserNotificationCenter currentNotificationCenter]
    //         requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |
    //                                          UNAuthorizationOptionBadge)
    //         completionHandler:^(BOOL granted, NSError *_Nullable error) {
    //             // Enable or disable features based on authorization.
    //             if (error) {
    //                 LOGD(error.description);
    //             }
    //         }];
    //        NSSet *categories = [NSSet setWithObjects:cat_call, cat_msg, video_call, cat_zrtp, nil];
    //        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
    //    }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    //    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    //
    //    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    //        statusBar.backgroundColor = color;
    //    }
}
#pragma deploymate pop

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setrazavariable];
    //[[LinphoneManager.instance fastAddressBook] reload];
    [Razauser SharedInstance].ratingUserNameDetailSet=[NSMutableSet set];
    
    [self setStatusBarBackgroundColor:kColorHeader];
    
    
    UIApplication *app = [UIApplication sharedApplication];
    UIApplicationState state = app.applicationState;
    
    LinphoneManager *instance = [LinphoneManager instance];
    BOOL background_mode = [instance lpConfigBoolForKey:@"backgroundmode_preference"];
    BOOL start_at_boot = [instance lpConfigBoolForKey:@"start_at_boot_preference"];
    [self registerForNotifications:app];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        self.del = [[ProviderDelegate alloc] init];
        [LinphoneManager.instance setProviderDelegate:self.del];
    }
    
    if (state == UIApplicationStateBackground) {
        // we've been woken up directly to background;
        if (!start_at_boot || !background_mode) {
            // autoboot disabled or no background, and no push: do nothing and wait for a real launch
            //output a log with NSLog, because the ortp logging system isn't activated yet at this time
            NSLog(@"Linphone launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
            return YES;
        }
    }
    bgStartId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        LOGW(@"Background task for application launching expired.");
        [[UIApplication sharedApplication] endBackgroundTask:bgStartId];
    }];
    
    [LinphoneManager.instance startLinphoneCore];
    
    LinphoneManager.instance.iapManager.notificationCategory = @"expiry_notification";
    // initialize UI
    [self.window makeKeyAndVisible];
    
    [RootViewManager setupWithPortrait:(PhoneMainView *)self.window.rootViewController];
    [PhoneMainView.instance startUp];
    [PhoneMainView.instance updateStatusBar:nil];
    
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_8_0) {
        NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotif) {
            LOGI(@"PushNotification from launch received.");
            [self processRemoteNotification:remoteNotif];
        }
    }
    
    if (bgStartId != UIBackgroundTaskInvalid)
        [[UIApplication sharedApplication] endBackgroundTask:bgStartId];
    
    //output what state the app is in. This will be used to see when the app is started in the background
    LOGI(@"app launched with state : %li", (long)application.applicationState);
    LOGI(@"FINISH LAUNCHING WITH OPTION : %@", launchOptions.description);
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"header_bg.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
        NSLog(@"%@",@"dfdfdf");
    }
    else{
        //  [self showlaunch];
    }
    [Razauser SharedInstance].modeofview=@"ni";
    
    [self sethockeyapp];
    return YES;
}
-(void)setplist
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LinphoneCoreSettingsStore *sipice=[[LinphoneCoreSettingsStore alloc]init];
        // settingsStore = [[LinphoneCoreSettingsStore alloc] init];
        [sipice transformLinphoneCoreToKeys];
        [sipice synchronize];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    LOGI(@"%@", NSStringFromSelector(_cmd));
    
    linphone_core_terminate_all_calls(LC);
    
    // destroyLinphoneCore automatically unregister proxies but if we are using
    // remote push notifications, we want to continue receiving them
    //	if (LinphoneManager.instance.pushNotificationToken != nil) {
    //		// trick me! setting network reachable to false will avoid sending unregister
    //		const MSList *proxies = linphone_core_get_proxy_config_list(LC);
    //		BOOL pushNotifEnabled = NO;
    //		while (proxies) {
    //			const char *refkey = linphone_proxy_config_get_ref_key(proxies->data);
    //			pushNotifEnabled = pushNotifEnabled || (refkey && strcmp(refkey, "push_notification") == 0);
    //			proxies = proxies->next;
    //		}
    //		// but we only want to hack if at least one proxy config uses remote push..
    //		if (pushNotifEnabled) {
    //			linphone_core_set_network_reachable(LC, FALSE);
    //		}
    //	}
    
    //   linphone_core_set_network_reachable(LC,FALSE);
    
    // connectivity has changed
    //   LinphoneProxyConfig *proxy = linphone_core_get_default_proxy_config(LC);
    
    //	linphone_core_set_network_reachable(LC, false);
    //    linphone_proxy_config_expires(proxy, 0);
    //	linphone_core_set_network_reachable(LC, true);
    //	linphone_core_iterate(LC);
    
    
    //	[LinphoneManager.instance destroyLinphoneCore];
    
    
    //    LinphoneProxyConfig* proxyCfg = NULL;
    //    linphone_core_get_default_proxy(LC, &proxyCfg);
    //
    //    linphone_proxy_config_edit(proxyCfg); /*start editing proxy configuration*/
    //    linphone_proxy_config_enable_publish(proxyCfg, TRUE);
    //    linphone_proxy_config_set_publish_expires(proxyCfg, 0);
    //    linphone_proxy_config_enable_register(proxyCfg,FALSE); /*de-activate registration for this proxy config*/
    //    linphone_proxy_config_done(proxyCfg); /*initiate REGISTER with expire = 0*/
    //
    //
    //    while(linphone_proxy_config_get_state(proxyCfg) !=  LinphoneRegistrationCleared){
    //        NSLog(@"state = %i",linphone_proxy_config_get_state(proxyCfg));
    //        linphone_core_iterate(LC); /*to make sure we receive call backs before shutting down*/
    //        ms_usleep(100000);
    //    }
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
    //        linphone_core_set_network_reachable(LC, FALSE);
    //        LinphoneManager.instance.connectivity = none;
    //    }
    //	[self refreshRegisters];
    
    [self removemissed];
    linphone_core_set_network_reachable(LC,YES);
    // linphone_core_iterate(LC);
    
    // linphone_core_destroy(LC);
    [LinphoneManager.instance destroyLinphoneCore:nil];
    
    
    //UMENIT:TODO Remove push call
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAZAMADECALLPUSH];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *scheme = [[url scheme] lowercaseString];
    if ([scheme isEqualToString:@"linphone-config"] || [scheme isEqualToString:@"linphone-config"]) {
        NSString *encodedURL =
        [[url absoluteString] stringByReplacingOccurrencesOfString:@"linphone-config://" withString:@""];
        self.configURL = [encodedURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Remote configuration", nil)
                                                                         message:NSLocalizedString(@"This operation will load a remote configuration. Continue ?", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self showWaitingIndicator];
                                                              [self attemptRemoteConfiguration];
                                                          }];
        
        [errView addAction:defaultAction];
        [errView addAction:yesAction];
        
        [PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
    } else {
        if ([[url scheme] isEqualToString:@"sip"]) {
            // remove "sip://" from the URI, and do it correctly by taking resourceSpecifier and removing leading and
            // trailing "/"
            NSString *sipUri = [[url resourceSpecifier]
                                stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
            [VIEW(DialerView) setAddress:sipUri];
        }
    }
    return YES;
}

- (void)fixRing {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // iOS7 fix for notification sound not stopping.
        // see http://stackoverflow.com/questions/19124882/stopping-ios-7-remote-notification-sound
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)processRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    
    if (aps != nil) {
        //NSDictionary *alert = [aps objectForKey:@"alert"];
        //----Raza-----*/
        NSString *alert = [aps objectForKey:@"alert"];
        if (alert != nil) {
            NSString *loc_key =alert; //[alert objectForKey:@"loc-key"];
            /*if we receive a remote notification, it is probably because our TCP background socket was no more working.
             As a result, break it and refresh registers in order to make sure to receive incoming INVITE or MESSAGE*/
            if (linphone_core_get_calls(LC) == NULL) { // if there are calls, obviously our TCP socket shall be working
                //linphone_core_set_network_reachable(LC, FALSE);
                //     if (!linphone_core_is_network_reachable(LC)) {
                LinphoneManager.instance.connectivity = none; //Force connectivity to be discovered again
                [LinphoneManager.instance setupNetworkReachabilityCallback];
                [LinphoneManager.instance refreshRegisters];
                
                //    }
                if (loc_key != nil) {
                    
                    NSString *callId = [userInfo objectForKey:@"call-id"];
                    if (callId != nil) {
                        if (![callId isEqualToString:@""]){
                            //Present apn pusher notifications for info
                            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
                                UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                                content.title = @"Raza Incoming message!";//@"APN Pusher";
                                content.body = @"Push notification received !";//@"Push notification received !";
                                //content.categoryIdentifier=@"cal_cat";
                                UNNotificationRequest *req = [UNNotificationRequest requestWithIdentifier:@"call_request" content:content trigger:NULL];
                                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:req withCompletionHandler:^(NSError * _Nullable error) {
                                    // Enable or disable features based on authorization.
                                    if (error) {
                                        LOGD(@"Error while adding notification request :");
                                        LOGD(error.description);
                                    }
                                }];
                            } else {
                                UILocalNotification *notification = [[UILocalNotification alloc] init];
                                notification.repeatInterval = 0;
                                notification.alertBody = @"Raza Incoming message!";
                                notification.alertTitle = @"Notification received !";
                                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                            }
                        } else {
                            [LinphoneManager.instance addPushCallId:callId];
                        }
                    } else  if ([callId  isEqual: @""]) {
                        LOGE(@"PushNotification: does not have call-id yet, fix it !");
                    }
                    
                    if ([loc_key isEqualToString:@"IC_MSG"]) {
                        [self fixRing];
                    }
                }
            }
        }
    }
    LOGI(@"Notification %@ processed", userInfo.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    LOGI(@"%@ : %@", NSStringFromSelector(_cmd), userInfo);
    
    [self processRemoteNotification:userInfo];
}

- (LinphoneChatRoom *)findChatRoomForContact:(NSString *)contact {
    const MSList *rooms = linphone_core_get_chat_rooms(LC);
    const char *from = [contact UTF8String];
    while (rooms) {
        const LinphoneAddress *room_from_address = linphone_chat_room_get_peer_address((LinphoneChatRoom *)rooms->data);
        char *room_from = linphone_address_as_string_uri_only(room_from_address);
        if (room_from && strcmp(from, room_from) == 0) {
            return rooms->data;
        }
        rooms = rooms->next;
    }
    return NULL;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"active");
        
        // display some foreground notification;
        [application cancelLocalNotification:notification];
    }
    else
    {
        NSLog(@"inactive");
    }
}
/*
 - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
 LOGI(@"%@ - state = %ld", NSStringFromSelector(_cmd), (long)application.applicationState);
 if ([notification.category isEqual:LinphoneManager.instance.iapManager.notificationCategory]){
 [PhoneMainView.instance changeCurrentView:ShopView.compositeViewDescription];
 return;
 }
 [self fixRing];
 if ([notification.userInfo objectForKey:@"callId"] != nil) {
 BOOL bypass_incoming_view = TRUE;
 // some local notifications have an internal timer to relaunch themselves at specified intervals
 if ([[notification.userInfo objectForKey:@"timer"] intValue] == 1) {
 [LinphoneManager.instance cancelLocalNotifTimerForCallId:[notification.userInfo objectForKey:@"callId"]];
 bypass_incoming_view = [LinphoneManager.instance lpConfigBoolForKey:@"autoanswer_notif_preference"];
 }
 if (bypass_incoming_view) {
 [LinphoneManager.instance acceptCallForCallId:[notification.userInfo objectForKey:@"callId"]];
 }
 } else if ([notification.userInfo objectForKey:@"from_addr"] != nil) {
 NSString *chat = notification.alertBody;
 NSString *remote_uri = (NSString *)[notification.userInfo objectForKey:@"from_addr"];
 NSString *from = (NSString *)[notification.userInfo objectForKey:@"from"];
 NSString *callID = (NSString *)[notification.userInfo objectForKey:@"call-id"];
 LinphoneChatRoom *room = [self findChatRoomForContact:remote_uri];
 if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
 ((PhoneMainView.instance.currentView != ChatsListView.compositeViewDescription) &&
 ((PhoneMainView.instance.currentView != ChatConversationView.compositeViewDescription))) ||
 (PhoneMainView.instance.currentView == ChatConversationView.compositeViewDescription &&
 room != PhoneMainView.instance.currentRoom)) {
 // Create a new notification
 if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
 // Do nothing
 } else {
 UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
 content.title = NSLocalizedString(@"Message received", nil);
 if ([LinphoneManager.instance lpConfigBoolForKey:@"show_msg_in_notif" withDefault:YES]) {
 content.subtitle = from;
 content.body = chat;
 } else {
 content.body = from;
 }
 content.sound = [UNNotificationSound soundNamed:@"msg.caf"];
 content.categoryIdentifier = @"msg_cat";
 content.userInfo = @{ @"from" : from, @"from_addr" : remote_uri, @"call-id" : callID };
 content.accessibilityLabel = @"Message notif";
 UNNotificationRequest *req =
 [UNNotificationRequest requestWithIdentifier:@"call_request" content:content trigger:NULL];
 req.accessibilityLabel = @"Message notif";
 [[UNUserNotificationCenter currentNotificationCenter]
 addNotificationRequest:req
 withCompletionHandler:^(NSError *_Nullable error) {
 // Enable or disable features based on authorization.
 if (error) {
 LOGD(@"Error while adding notification request :");
 LOGD(error.description);
 }
 }];
 }
 }
 } else if ([notification.userInfo objectForKey:@"callLog"] != nil) {
 NSString *callLog = (NSString *)[notification.userInfo objectForKey:@"callLog"];
 HistoryDetailsView *view = VIEW(HistoryDetailsView);
 [view setCallLogId:callLog];
 [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
 }
 }
 */

//// this method is implemented for iOS7. It is invoked when receiving a push notification for a call and it has
//// "content-available" in the aps section.
//- (void)application:(UIApplication *)application
//	didReceiveRemoteNotification:(NSDictionary *)userInfo
//		  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//	LOGI(@"%@ : %@", NSStringFromSelector(_cmd), userInfo);
//	LinphoneManager *lm = LinphoneManager.instance;
//
//	// save the completion handler for later execution.
//	// 2 outcomes:
//	// - if a new call/message is received, the completion handler will be called with "NEWDATA"
//	// - if nothing happens for 15 seconds, the completion handler will be called with "NODATA"
//	lm.silentPushCompletion = completionHandler;
//	[NSTimer scheduledTimerWithTimeInterval:15.0
//									 target:lm
//								   selector:@selector(silentPushFailed:)
//								   userInfo:nil
//									repeats:FALSE];
//
//	// If no call is yet received at this time, then force Linphone to drop the current socket and make new one to
//	// register, so that we get
//	// a better chance to receive the INVITE.
//	if (linphone_core_get_calls(LC) == NULL) {
//		linphone_core_set_network_reachable(LC, FALSE);
//		lm.connectivity = none; /*force connectivity to be discovered again*/
//		[lm refreshRegisters];
//	}
//}

#pragma mark - PushNotification Functions

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    LOGI(@"%@ : %@", NSStringFromSelector(_cmd), deviceToken);
    [LinphoneManager.instance setPushNotificationToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    LOGI(@"%@ : %@", NSStringFromSelector(_cmd), [error localizedDescription]);
    [LinphoneManager.instance setPushNotificationToken:nil];
}

#pragma mark - PushKit Functions

- (void)pushRegistry:(PKPushRegistry *)registry
didInvalidatePushTokenForType:(NSString *)type {
    LOGI(@"PushKit Token invalidated");
    dispatch_async(dispatch_get_main_queue(), ^{[LinphoneManager.instance setPushNotificationToken:nil];});
    
}

- (void)pushRegistry:(PKPushRegistry *)registry
didReceiveIncomingPushWithPayload:(PKPushPayload *)payload
             forType:(NSString *)type {
    
    //    LOGI(@"PushKit : incoming voip notfication: %@", payload.dictionaryPayload);
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) { // Call category
    //        UNNotificationAction *act_ans =
    //        [UNNotificationAction actionWithIdentifier:@"Answer"
    //                                             title:NSLocalizedString(@"Answer", nil)
    //                                           options:UNNotificationActionOptionForeground];
    //        UNNotificationAction *act_dec = [UNNotificationAction actionWithIdentifier:@"Decline"
    //                                                                             title:NSLocalizedString(@"Decline", nil)
    //                                                                           options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_call =
    //        [UNNotificationCategory categoryWithIdentifier:@"call_cat"
    //                                               actions:[NSArray arrayWithObjects:act_ans, act_dec, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //        // Msg category
    //        UNTextInputNotificationAction *act_reply =
    //        [UNTextInputNotificationAction actionWithIdentifier:@"Reply"
    //                                                      title:NSLocalizedString(@"Reply", nil)
    //                                                    options:UNNotificationActionOptionNone];
    //        UNNotificationAction *act_seen =
    //        [UNNotificationAction actionWithIdentifier:@"Seen"
    //                                             title:NSLocalizedString(@"Mark as seen", nil)
    //                                           options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_msg =
    //        [UNNotificationCategory categoryWithIdentifier:@"msg_cat"
    //                                               actions:[NSArray arrayWithObjects:act_reply, act_seen, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        // Video Request Category
    //        UNNotificationAction *act_accept =
    //        [UNNotificationAction actionWithIdentifier:@"Accept"
    //                                             title:NSLocalizedString(@"Accept", nil)
    //                                           options:UNNotificationActionOptionForeground];
    //
    //        UNNotificationAction *act_refuse = [UNNotificationAction actionWithIdentifier:@"Cancel"
    //                                                                                title:NSLocalizedString(@"Cancel", nil)
    //                                                                              options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *video_call =
    //        [UNNotificationCategory categoryWithIdentifier:@"video_request"
    //                                               actions:[NSArray arrayWithObjects:act_accept, act_refuse, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        // ZRTP verification category
    //        UNNotificationAction *act_confirm = [UNNotificationAction actionWithIdentifier:@"Confirm"
    //                                                                                 title:NSLocalizedString(@"Accept", nil)
    //                                                                               options:UNNotificationActionOptionNone];
    //
    //        UNNotificationAction *act_deny = [UNNotificationAction actionWithIdentifier:@"Deny"
    //                                                                              title:NSLocalizedString(@"Deny", nil)
    //                                                                            options:UNNotificationActionOptionNone];
    //        UNNotificationCategory *cat_zrtp =
    //        [UNNotificationCategory categoryWithIdentifier:@"zrtp_request"
    //                                               actions:[NSArray arrayWithObjects:act_confirm, act_deny, nil]
    //                                     intentIdentifiers:[[NSMutableArray alloc] init]
    //                                               options:UNNotificationCategoryOptionCustomDismissAction];
    //
    //        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    //        [[UNUserNotificationCenter currentNotificationCenter]
    //         requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |
    //                                          UNAuthorizationOptionBadge)
    //         completionHandler:^(BOOL granted, NSError *_Nullable error) {
    //             // Enable or disable features based on authorization.
    //             if (error) {
    //                 LOGD(error.description);
    //             }
    //         }];
    //        NSSet *categories = [NSSet setWithObjects:cat_call, cat_msg, video_call, cat_zrtp, nil];
    //        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
    //    }
    //    [LinphoneManager.instance setupNetworkReachabilityCallback];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self processRemoteNotification:payload.dictionaryPayload];
    //    });
    
    /*---------------Raza---------------*/
    
    //
    if (LC==NULL) {
        [LinphoneManager.instance startLinphoneCore];
    }
    
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    if (default_proxy != NULL)
    {
        [self setrazapushnotification:payload];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry
didUpdatePushCredentials:(PKPushCredentials *)credentials
             forType:(NSString *)type {
    LOGI(@"PushKit credentials updated");
    LOGI(@"voip token: %@", (credentials.token));
    LOGI(@"%@ : %@", NSStringFromSelector(_cmd), credentials.token);
    dispatch_async(dispatch_get_main_queue(), ^{[LinphoneManager.instance setPushNotificationToken:credentials.token];});
    
    NSString *oldToken = [self deviceToken];
    NSLog(@"%@",oldToken);
    //    if(oldToken == nil || oldToken.length == 0){
    //
    //        oldToken =@"0";
    //
    //    }
    
    NSString *newToken =[[[[credentials.token description]
                           stringByReplacingOccurrencesOfString:@"<" withString:@""]
                          stringByReplacingOccurrencesOfString:@">" withString:@""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    //  @"Tokdummytest1234567890123456782";/*
    //*/
    //@"Tokdummytest1234567890123456785"; /*
    
    NSLog(@"My token is: %@", newToken);
    if (!self.deviceID.length)
        self.deviceID=newToken;
    // self.deviceID=newToken;
    // phonenumbervalue = newToken;
    
    [self setDeviceToken:newToken];
}

#pragma mark - UserNotifications Framework

- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    LOGD(@"UN : response recieved");
    LOGD(response.description);
    NSLog(@"%@", response.notification.request.content.userInfo);
    NSDictionary *messageclicked=response.notification.request.content.userInfo;
    if ([messageclicked objectForKey:@"pushmsg"]) {
        NSString *callno=[messageclicked objectForKey:@"pushmsg"];
        callno=[NSString stringWithFormat:@"sip:%@@%@",callno,MAINRAZASIPURL];
        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(
                                                                      LC, ((NSString *)callno).UTF8String);
        if (room) {
            //[self pushtoperticularcontroller:room];
        }
    }
    //localNotification.userInfo
    
    // --- this below is to handle action identifier from push notifications - will enable later dinny
    
    
    //    NSString *callId = (NSString *)[response.notification.request.content.userInfo objectForKey:@"CallId"];
    //    LinphoneCall *call = [LinphoneManager.instance callByCallId:callId];
    //    if (call) {
    //        LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
    //        if (data->timer) {
    //            [data->timer invalidate];
    //            data->timer = nil;
    //        }
    //    }
    //
    //    if ([response.actionIdentifier isEqual:@"Answer"]) {
    //        // use the standard handler
    //        [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
    //        linphone_core_accept_call(LC, call);
    //    } else if ([response.actionIdentifier isEqual:@"Decline"]) {
    //        linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
    //    } else if ([response.actionIdentifier isEqual:@"Reply"]) {
    //        LinphoneCore *lc = [LinphoneManager getLc];
    //        NSString *replyText = [(UNTextInputNotificationResponse *)response userText];
    //        NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
    //        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
    //        if (room) {
    //            LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
    //            linphone_chat_room_send_chat_message(room, msg);
    //            linphone_chat_room_mark_as_read(room);
    //            TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
    //                                             getCachedController:NSStringFromClass(TabBarView.class)];
    //            [tab update:YES];
    //            [PhoneMainView.instance updateApplicationBadgeNumber];
    //        }
    //    } else if ([response.actionIdentifier isEqual:@"Seen"]) {
    //        NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
    //        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
    //        if (room) {
    //            linphone_chat_room_mark_as_read(room);
    //            TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
    //                                             getCachedController:NSStringFromClass(TabBarView.class)];
    //            [tab update:YES];
    //            [PhoneMainView.instance updateApplicationBadgeNumber];
    //        }
    //
    //    } else if ([response.actionIdentifier isEqual:@"Cancel"]) {
    //        LOGI(@"User declined video proposal");
    //        if (call == linphone_core_get_current_call(LC)) {
    //            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
    //            linphone_core_accept_call_update(LC, call, params);
    //            linphone_call_params_destroy(params);
    //        }
    //    } else if ([response.actionIdentifier isEqual:@"Accept"]) {
    //        LOGI(@"User accept video proposal");
    //        if (call == linphone_core_get_current_call(LC)) {
    //            [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    //            [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
    //            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
    //            linphone_call_params_enable_video(params, TRUE);
    //            linphone_core_accept_call_update(LC, call, params);
    //            linphone_call_params_destroy(params);
    //        }
    //    } else if ([response.actionIdentifier isEqual:@"Confirm"]) {
    //        if (linphone_core_get_current_call(LC) == call) {
    //            linphone_call_set_authentication_token_verified(call, YES);
    //        }
    //    } else if ([response.actionIdentifier isEqual:@"Deny"]) {
    //        if (linphone_core_get_current_call(LC) == call) {
    //            linphone_call_set_authentication_token_verified(call, NO);
    //        }
    //    } else { // in this case the value is : com.apple.UNNotificationDefaultActionIdentifier
    //        if ([response.notification.request.content.categoryIdentifier isEqual:@"call_cat"]) {
    //            [PhoneMainView.instance displayIncomingCall:call];
    //        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"msg_cat"]) {
    //            [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
    //        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"video_request"]) {
    //            [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
    //            NSTimer *videoDismissTimer = nil;
    //
    //            UIConfirmationDialog *sheet =
    //            [UIConfirmationDialog ShowWithMessage:response.notification.request.content.body
    //                                    cancelMessage:nil
    //                                   confirmMessage:NSLocalizedString(@"ACCEPT", nil)
    //                                    onCancelClick:^() {
    //                                        LOGI(@"User declined video proposal");
    //                                        if (call == linphone_core_get_current_call(LC)) {
    //                                            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
    //                                            linphone_core_accept_call_update(LC, call, params);
    //                                            linphone_call_params_destroy(params);
    //                                            [videoDismissTimer invalidate];
    //                                        }
    //                                    }
    //                              onConfirmationClick:^() {
    //                                  LOGI(@"User accept video proposal");
    //                                  if (call == linphone_core_get_current_call(LC)) {
    //                                      LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
    //                                      linphone_call_params_enable_video(params, TRUE);
    //                                      linphone_core_accept_call_update(LC, call, params);
    //                                      linphone_call_params_destroy(params);
    //                                      [videoDismissTimer invalidate];
    //                                  }
    //                              }
    //                                     inController:PhoneMainView.instance];
    //
    //            videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
    //                                                                 target:self
    //                                                               selector:@selector(dismissVideoActionSheet:)
    //                                                               userInfo:sheet
    //                                                                repeats:NO];
    //        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"zrtp_request"]) {
    //            [UIConfirmationDialog
    //             ShowWithMessage:[NSString stringWithFormat:NSLocalizedString(
    //                                                                          @"Confirm the following SAS with peer:\n%s", nil),
    //                              linphone_call_get_authentication_token(call)]
    //             cancelMessage:NSLocalizedString(@"DENY", nil)
    //             confirmMessage:NSLocalizedString(@"ACCEPT", nil)
    //             onCancelClick:^() {
    //                 if (linphone_core_get_current_call(LC) == call) {
    //                     linphone_call_set_authentication_token_verified(call, NO);
    //                 }
    //             }
    //             onConfirmationClick:^() {
    //                 if (linphone_core_get_current_call(LC) == call) {
    //                     linphone_call_set_authentication_token_verified(call, YES);
    //                 }
    //             }];
    //        } else { // Missed call
    //            [PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
    //        }
    //    }
    
    // --- this above is to handle action identifier from push notifications - will enable later dinny
    //    if (incomingmissed.length&&pushcall.length)
    //    {
    //        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
    //                                stringForKey:RAZAMADECALLPUSH];
    //        if (!savedValue.length)
    //     [self presentsendpushmsg:pushcall];
    //    }
}

- (void)dismissVideoActionSheet:(NSTimer *)timer {
    UIConfirmationDialog *sheet = (UIConfirmationDialog *)timer.userInfo;
    [sheet dismiss];
}

#pragma mark - User notifications

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (call) {
        LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
        if (data->timer) {
            [data->timer invalidate];
            data->timer = nil;
        }
    }
    LOGI(@"%@", NSStringFromSelector(_cmd));
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_9_0) {
        LOGI(@"%@", NSStringFromSelector(_cmd));
        if ([notification.category isEqualToString:@"incoming_call"]) {
            if ([identifier isEqualToString:@"answer"]) {
                // use the standard handler
                [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
                linphone_core_accept_call(LC, call);
            } else if ([identifier isEqualToString:@"decline"]) {
                LinphoneCall *call = linphone_core_get_current_call(LC);
                if (call)
                    linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
            }
        } else if ([notification.category isEqualToString:@"incoming_msg"]) {
            if ([identifier isEqualToString:@"reply"]) {
                // use the standard handler
                [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
            } else if ([identifier isEqualToString:@"mark_read"]) {
                NSString *from = [notification.userInfo objectForKey:@"from_addr"];
                LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
                if (room) {
                    linphone_chat_room_mark_as_read(room);
                    TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
                                                     getCachedController:NSStringFromClass(TabBarView.class)];
                    [tab update:YES];
                    [PhoneMainView.instance updateApplicationBadgeNumber];
                }
            }
        }
    }
    completionHandler();
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
   withResponseInfo:(NSDictionary *)responseInfo
  completionHandler:(void (^)())completionHandler {
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (call) {
        LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
        if (data->timer) {
            [data->timer invalidate];
            data->timer = nil;
        }
    }
    if ([notification.category isEqualToString:@"incoming_call"]) {
        if ([identifier isEqualToString:@"answer"]) {
            // use the standard handler
            [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
            linphone_core_accept_call(LC, call);
        } else if ([identifier isEqualToString:@"decline"]) {
            LinphoneCall *call = linphone_core_get_current_call(LC);
            if (call)
                linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
        }
    } else if ([notification.category isEqualToString:@"incoming_msg"] &&
               [identifier isEqualToString:@"reply_inline"]) {
        LinphoneCore *lc = [LinphoneManager getLc];
        NSString *replyText = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
        NSString *from = [notification.userInfo objectForKey:@"from_addr"];
        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
        if (room) {
            LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
            linphone_chat_room_send_chat_message(room, msg);
            linphone_chat_room_mark_as_read(room);
            [PhoneMainView.instance updateApplicationBadgeNumber];
        }
    }
    completionHandler();
    
}

//- (void)application:(UIApplication *)application
//	handleActionWithIdentifier:(NSString *)identifier
//		 forRemoteNotification:(NSDictionary *)userInfo
//			 completionHandler:(void (^)())completionHandler {
//	LOGI(@"%@", NSStringFromSelector(_cmd));
//	completionHandler();
//}
#pragma deploymate pop

#pragma mark - Remote configuration Functions (URL Handler)

- (void)ConfigurationStateUpdateEvent:(NSNotification *)notif {
    LinphoneConfiguringState state = [[notif.userInfo objectForKey:@"state"] intValue];
    if (state == LinphoneConfiguringSuccessful) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneConfiguringStateUpdate object:nil];
        [_waitingIndicator dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil)
                                                                         message:NSLocalizedString(@"Remote configuration successfully fetched and applied.", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
        
        [PhoneMainView.instance startUp];
    }
    if (state == LinphoneConfiguringFailed) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneConfiguringStateUpdate object:nil];
        [_waitingIndicator dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Failure", nil)
                                                                         message:NSLocalizedString(@"Failed configuring from the specified URL.", nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
    }
}

- (void)showWaitingIndicator {
    _waitingIndicator = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Fetching remote configuration...", nil)
                                                            message:@""
                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 60, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [_waitingIndicator setValue:progress forKey:@"accessoryView"];
    [progress setColor:[UIColor blackColor]];
    
    [progress startAnimating];
    [PhoneMainView.instance presentViewController:_waitingIndicator animated:YES completion:nil];
}

- (void)attemptRemoteConfiguration {
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(ConfigurationStateUpdateEvent:)
                                               name:kLinphoneConfiguringStateUpdate
                                             object:nil];
    linphone_core_set_provisioning_uri(LC, [configURL UTF8String]);
    [LinphoneManager.instance destroyLinphoneCore:nil];
    [LinphoneManager.instance startLinphoneCore];
    [LinphoneManager.instance.fastAddressBook reload];
}

#pragma mark - Prevent ImagePickerView from rotating

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([[(PhoneMainView*)self.window.rootViewController currentView] equal:ImagePickerView.compositeViewDescription])
    {
        //Prevent rotation of camera
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        return UIInterfaceOrientationMaskPortrait;
    }
    else return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskAll;
}
-(NSDictionary *)getInformationFromString:(NSString *)resultString {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    NSArray *values = [self getArrayFromRequestString:resultString];
    
    for (NSString *pair in values) {
        
        NSArray *pairs = [pair componentsSeparatedByString:@"="];
        
        [info setObject:[pairs objectAtIndex:1] forKey:[pairs objectAtIndex:0]];
    }
    if ([[info allKeys] count]) {
        return info;
    }
    
    return nil;
}
-(NSArray *)getArrayFromRequestString:(NSString *)resultString {
    
    if (resultString && [resultString length]) {
        
        NSString *sep = @"|~`";
        
        NSArray *values = [self getArrayFromString:resultString separatedBy:sep]; //[resultString componentsSeparatedByCharactersInSet:set];
        return values;
    }
    
    return nil;
}
-(NSArray *)getArrayFromString:(NSString *)resultString separatedBy:(NSString *)separatedBy {
    
    if (resultString && [resultString length]) {
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:separatedBy];
        
        NSArray *values = [resultString componentsSeparatedByCharactersInSet:set];
        
        return values;
    }
    
    return nil;
}
- (NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
    //return @"49e6656b89b1dfaf6ea9d5f9cd393c5a3253bcdec9e8a52cab9bd4bd883250ce";
}

- (void)setDeviceToken:(NSString*)token
{
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}
-(NSDictionary *)getDictionaryFromString:(NSString *)resultString separatedBy:(NSString *)character withKeyString:(NSString *)keyString withIndex:(int)keyIndex {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:character];
    
    NSArray *resultArray = [self getArrayFromString:resultString separatedBy:character];
    
    //if ([[resultArray objectAtIndex:0] isEqualToString:@"status=1"]) {
    NSMutableArray *accessnumbers = [resultArray mutableCopy];
    [accessnumbers removeObjectAtIndex:0];
    resultArray = accessnumbers;
    for (NSString *pair in resultArray) {
        
        NSArray *pairs = [pair componentsSeparatedByString:keyString];
        NSString *key = [pairs objectAtIndex:keyIndex];
        id value = [self makeDataSource:[pairs mutableCopy] withIndex:0];
        
        NSMutableArray *tempArray = [info objectForKey:key];
        
        if (!tempArray) {
            tempArray = [NSMutableArray array];
            [info setObject:tempArray forKey:key];
        }
        [tempArray addObject:value];
        
    }
    if ([[info allKeys] count]) {
        return info;
    }
    //}
    return nil;
}

-(id)makeDataSource:(NSMutableArray *)pairs withIndex:(int)index {
    
    id value;
    NSString *key;
    
    
    if ([pairs count] == 2) {
        key = [pairs objectAtIndex:0];
        value = [pairs objectAtIndex:1];
    } else if ([pairs count] > 2) {
        key = [pairs objectAtIndex:index];
        [pairs removeObjectAtIndex:index];
        value = pairs;
    }
    if (value) {
        return value;
    }
    
    return nil;
}
-(void)setrazavariable
{
    contactarray=[[NSMutableDictionary alloc]init];
    // [self setlocationself];
    //UIDevice *myDevice = [UIDevice currentDevice];
    // self.deviceID =@"toksstt56676767567567675567teyyyyddid";//[[myDevice identifierForVendor] UUIDString];//@"66E0AD11-5670-4E0B-98C0-E5669644680D45454545454545";//
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    RAZA_APPDELEGATE.baseURL = [NSURL URLWithString:[infoDictionary objectForKey:@"BaseURL"]];
    
    //    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"630-818-2157",@"accessno",@"testuser2@razatelecom.com",@"email",@"1507123",@"id",@"1111985347",@"pin", nil];
    //    [RAZA_USERDEFAULTS setObject:dict forKey:@"logininfo"];
    [self deviceToken];
    self.appCountriesFlag = [self appCountryFlagInfo];
    [self RazauserCount:nil];
    self.ipAddress = [self getIPAddress];
}
//-(void)setlocationself
//{
//    locationManager = [[CLLocationManager alloc] init];
//    [locationManager setDelegate:self];
//    [locationManager setDistanceFilter:kCLDistanceFilterNone];
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    if (IS_OS_8_OR_LATER) {
//        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            [locationManager requestWhenInUseAuthorization];
//            [locationManager requestAlwaysAuthorization];
//        }
//    }
//    [locationManager startUpdatingLocation];
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *currentLoc=[locations objectAtIndex:0];
//    // _coordinate=currentLoc.coordinate;
//    NSString   *_current_Lat = [NSString stringWithFormat:@"%f",currentLoc.coordinate.latitude];
//    NSString   *_current_Long = [NSString stringWithFormat:@"%f",currentLoc.coordinate.longitude];
//    _latitudelongitude=[NSString stringWithFormat:@"%@,%@",_current_Lat,_current_Long];
//    NSLog(@"here lat %@ and here long %@",_current_Lat,_current_Long);
//    //self._locationBlock();
//    [locationManager stopUpdatingLocation];
//    locationManager = nil;
//}
-(BOOL)checkNetworkPriorRequest
{
    Reachability* reachability = [Reachability reachabilityWithHostname:@"www.google.com"];//[Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable: {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            self.internetActive = NO;
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN: {
            self.internetActive = YES;
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            break;
        }
        case ReachableViaWiFi: {
            self.internetActive = YES;
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    
    if (connectionRequired)
    {
        self.internetActive = NO;
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    
    self.internetMessage = statusString;
    NSLog(@"statusString %@ %d",statusString, self.internetActive);
    
    
    return self.internetActive;
}
-(void)showIndeterminateMessage:(NSString *)error withShortMessage:(BOOL)flag {
    
    if (self.hudIndicator) {
        self.hudIndicator = nil;
    }
    
    self.hudIndeterminate = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    // Configure for text only and offset down
    self.hudIndeterminate.mode = MBProgressHUDModeIndeterminate;
    if (flag) {
        self.hudIndeterminate.detailsLabelText = error;
    }
    else {
        self.hudIndeterminate.labelText = error;
    }
    
    self.hudIndeterminate.removeFromSuperViewOnHide = YES;
}

-(void)hideIndeterminateIndicator:(BOOL)flag {
    
    [self.hudIndeterminate hide:flag];
    self.hudIndeterminate = nil;
}
-(void)showMessage:(NSString *)error withMode:(MBProgressHUDMode)mode withDelay:(NSTimeInterval)delay withShortMessage:(BOOL)flag {
    
    if (self.hudIndicator) {
        self.hudIndicator = nil;
    }
    
    self.hudIndicator = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    self.hudIndicator.animationType = MBProgressHUDAnimationZoom;
    // Configure for text only and offset down
    self.hudIndicator.mode = mode;
    if (flag) {
        self.hudIndicator.detailsLabelText = error;
    }
    else {
        self.hudIndicator.labelText = error;
    }
    
    [self.hudIndicator hide:YES afterDelay:delay];
    
    [self hideIndeterminateIndicator:YES];
    
    self.hudIndicator.removeFromSuperViewOnHide = YES;
    
}
- (NSDictionary *)appCountryFlagInfo {
    
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"CountryFlag" ofType:@"plist"];
    NSDictionary *infoDict = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
    
    NSDictionary *countryFlag = [infoDict objectForKey:@"CountryFlag"];
    
    return countryFlag ? countryFlag : nil;
}
-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)title withCancelTitle:(NSString *)cancelTitle {
    
    self.razaAlertView = nil;
    
    if (!self.razaAlertView) {
        
        self.razaAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        
        [self.razaAlertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //do something
        self.razaAlertView = nil;
    }
}
-(NSString *)getDateInMMYY:(NSString *)targetdate {
    
    NSCalendar * gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSArray *dateMY = [targetdate componentsSeparatedByString:@"/"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSDate *aDate = [formatter dateFromString:[dateMY objectAtIndex:0]];
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:aDate];
    NSInteger flags = (NSHourCalendarUnit|NSMinuteCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit);
    NSDateComponents * components = [gregorianCalendar components:flags
                                                         fromDate:aDate];
    
    //    NSInteger hour = [components hour];
    //    NSInteger minute = [components minute];
    //    NSInteger ye = [components year];
    //    NSInteger mon = [components month];
    //    NSInteger day = [components day];
    
    //NSLog(@"%02ld-%02ld-%ld %02ld:%02ld", (long)day, (long)mon, (long)ye, (long)hour, (long)minute);
    NSString *month = [NSString stringWithFormat:@"%02ld", (long)[components month]];
    NSString *year = [[dateMY objectAtIndex:1] substringFromIndex:2];
    
    NSString *resultdate = [month stringByAppendingString:year];
    
    return resultdate;
}
-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (NSString *)getIPAddress {
    
    //    NSString *address = @"error";
    //    struct ifaddrs *interfaces = NULL;
    //    struct ifaddrs *temp_addr = NULL;
    //    int success = 0;
    //    // retrieve the current interfaces - returns 0 on success
    //    success = getifaddrs(&interfaces);
    //    if (success == 0) {
    //        // Loop through linked list of interfaces
    //        temp_addr = interfaces;
    //        while(temp_addr != NULL) {
    //            if(temp_addr->ifa_addr->sa_family == AF_INET) {
    //                // Check if interface is en0 which is the wifi connection on the iPhone
    //                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
    //                    // Get NSString from C String
    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
    //
    //                }
    //
    //            }
    //
    //            temp_addr = temp_addr->ifa_next;
    //        }
    //    }
    //    // Free memory
    //    freeifaddrs(interfaces);
    //    return address;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
    
}
-(NSString*)getTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return NO;
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)RazauserCount:(id)sender {
    [[RazaServiceManager sharedInstance]GetSIPUsersList];
/*
    NSString *header=  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
    NSString *request=[NSString stringWithFormat:
                       @"<request>\n"
                       "<api_username>%@</api_username>\n"
                       "<api_key>%@</api_key>\n"
                       "<command>%@</command>\n"
                       "<return_type>%@</return_type>\n"
                       "<domain>%@</domain>\n"
                       "</request>\n"
                       ,DEFAULT_SIP_APIUSER,DEFAULT_SIP_APIKEY,@"get_subscriber_list",@"json",DEFAULT_SIP_APIURL];
    NSString *final=[NSString stringWithFormat:@"%@%@",header,request];
    
    NSURL *uri=[NSURL URLWithString:DEFAULT_SIP_ADDRESS];//
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:uri cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    
    NSString *xml = final;
    
    theRequest.HTTPBody = [xml dataUsingEncoding:NSUTF8StringEncoding];
    theRequest.HTTPMethod = @"POST";
    [theRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    //  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:theRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSString *json_string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *newStr = [json_string substringWithRange:NSMakeRange(2, [json_string length]-2)];
            NSData* data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *arruser=[jsonDict valueForKey:@"USERS"];
            NSMutableArray *mainarray=[[NSMutableArray alloc]init];
            for (NSDictionary *razauserobject in arruser) {
                NSString *razauserphone=[razauserobject objectForKey:@"USERNAME"];
                
                [mainarray addObject:razauserphone];
            }
            if (![mainarray isEqualToArray:[[Razauser SharedInstance]getRazauser]])
                [[Razauser SharedInstance] setRazauser:mainarray];
            
            // [[Razauser SharedInstance]getrazauserbyname];
            NSLog(@"%@",[[Razauser SharedInstance]getRazauser]);
        }
    }];
    [dataTask resume];
    */
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //    if ((linphone_core_get_calls_nb(LC) == 0)) {
    //        [LinphoneManager.instance destroyLinphoneCore:@"remove"];
    //    }
    //  //  if (LC==NULL) {
    //        [LinphoneManager.instance startLinphoneCore];
    //    //}
    //
    //     //[LinphoneManager.instance startLinphoneCore];
    //    if (LC==NULL) {
    //        [LinphoneManager.instance startLinphoneCore];
    //    }
    
    if ([[pushdict objectForKey:@"pushtype"] length]) {
        if (LC!=NULL)
            
            //[LinphoneManager.instance destroyLinphoneCore:@"remove"];
            //  if (LC==NULL) {
            if ((linphone_core_get_calls_nb(LC) == 0))
                [LinphoneManager.instance startLinphoneCore];
        //Here localnotification for push
        // [self callforpushResponse:[pushdict valueForKey:@"msgpush"]];
        
    }
    // [self performSelector:@selector(subscribe) withObject:self afterDelay:3.0 ];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:RAZAMADECALLPUSH];
    if (savedValue.length) {
        // [[Razauser SharedInstance]ShowWaitingshort:@"Connecting call......" andtime:9];
        [self setRazapushcallview];
    }
    DialerView *view = VIEW(DialerView);
    [view updatechatreadunreadcounter:0];
    //    else
    //    {
    //       // if (incomingmissed.length)
    //        //[PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
    //    }
}
-(void)callforpushResponse:(NSString*)Pushstring
{
    NSTimeInterval comparetime=[[RazaNotificationObject SharedInstance]compareTimeSlot:[pushdict objectForKey:@"pushtime"]];// [notifiyPushobject compareTimeSlot:[pushdict objectForKey:@"pushtime"]];
    if ([[RazaNotificationObject SharedInstance] containsString:@"Videocall from" andmainstringcontains:Pushstring]) {
        
        NSArray *arr = [Pushstring componentsSeparatedByString:@"Videocall from "];
        
        if(arr.count==2)
        {
            //pushtime
            pushcall=[arr objectAtIndex:1];
            if(comparetime<=20||comparetime==NAN||isnan(comparetime))
            {
                // RazaAddressBookVC *avc = [[RazaAddressBookVC alloc]init];
                //[avc addCallToDatabaseWithPhoneNumber:pushcall withCallType:INCOMING_CALL withMediaType:@"voipincoming"];
                if (pushcall.length)
                    [[Razauser SharedInstance]addCallToDatabase:@"OUTGOING" andsender:pushcall];
                [[NSUserDefaults standardUserDefaults] setObject:RAZAMADEVIDEOPUSH forKey:RAZAMADECALLPUSH];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //                 if([[NgnEngine sharedInstance].sipService isRegistered])
                //           //[self performSelector:@selector(makecalldelayvideo) withObject:self afterDelay:1.0];
                //                //[self makecalldelayvideo];
                //                     [self performSelector:@selector(makecalldelayvideo) withObject:self afterDelay:1.0];
                //                else
                //                [self performSelector:@selector(makecalldelayvideo) withObject:self afterDelay:5.0];
            }
            else
            {
                // RazaAddressBookVC *avc = [[RazaAddressBookVC alloc]init];
                //[avc addCallToDatabaseWithPhoneNumber:[arr objectAtIndex:1] withCallType:MISSED_CALL withMediaType:@"Missed"];
                RazaNotificationObject *notifypush=[[RazaNotificationObject alloc]init];
                [notifypush setnotificationformiisedcall];
                if (pushcall.length)
                    [[Razauser SharedInstance]addCallToDatabase:nil andsender:pushcall];
            }
        }
        
        
    }
    else if ([[RazaNotificationObject SharedInstance] containsString:@"Voicecall from" andmainstringcontains:Pushstring]) {
        
        NSArray *arr = [Pushstring componentsSeparatedByString:@"Voicecall from "];
        if(arr.count==2)
        {
            pushcall=[arr objectAtIndex:1];
            if(comparetime<=20||comparetime==NAN||isnan(comparetime))
            {
                //   RazaAddressBookVC *avc = [[RazaAddressBookVC alloc]init];
                //[avc addCallToDatabaseWithPhoneNumber:pushcall withCallType:INCOMING_CALL withMediaType:@"voipincoming"];
                //                 if([[NgnEngine sharedInstance].sipService isRegistered])
                //                //[self makecalldelay];RAZAMADEVIOPPUSH
                //                     [self performSelector:@selector(makecalldelay) withObject:self afterDelay:1.0];
                //                else
                //            [self performSelector:@selector(makecalldelay) withObject:self afterDelay:5.0];
                if (pushcall.length)
                    [[Razauser SharedInstance]addCallToDatabase:@"OUTGOING" andsender:pushcall];
                [[NSUserDefaults standardUserDefaults] setObject:RAZAMADEVIOPPUSH forKey:RAZAMADECALLPUSH];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                // RazaAddressBookVC *avc = [[RazaAddressBookVC alloc]init];
                // [avc addCallToDatabaseWithPhoneNumber:[arr objectAtIndex:1] withCallType:MISSED_CALL withMediaType:@"Missed"];
                RazaNotificationObject *notifypush=[[RazaNotificationObject alloc]init];
                [notifypush setnotificationformiisedcall];
                if (pushcall.length)
                    [[Razauser SharedInstance]addCallToDatabase:nil andsender:pushcall];
            }
        }
        
    }
    else {
        
        NSArray *arrmsg= [[RazaNotificationObject SharedInstance] checkstringpushmessage:Pushstring] ;
        if (arrmsg.count==2) {
            if (!keyforcallbalance.length)
            {
                NSString *basephone= [arrmsg objectAtIndex:0];
                if (basephone.length) {
                    keyforshowpersonal=@"yes";
                    RazaNotificationObject *notifypush=[[RazaNotificationObject alloc]init];
                    [notifypush setnotificationforchat];
                    
                    //  [self performSelector:@selector(makemessagedelayfor:) withObject:basephone afterDelay:1.0];
                }
                
            }
            // [self performSelector:@selector(makemessagedelay) withObject:self afterDelay:1.0];
        }
        
    }
    pushdict=nil;
}
-(void)showlaunch
{
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:
                      @"raza AppV1" ofType:@"mov"];
    
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [_moviePlayer.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT)];
    
    // [self presentMoviePlayerViewControllerAnimated:moviePlayer.view];
    
    _moviePlayer.controlStyle=MPMovieControlStyleNone;
    UIImage *thumbnail = [_moviePlayer thumbnailImageAtTime:0.7
                                                 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    iv = [[UIImageView alloc] initWithImage:thumbnail];
    iv.userInteractionEnabled = YES;
    iv.frame = _moviePlayer.view.frame;
    [self.window addSubview:iv];
    
    [self performSelector:@selector(play) withObject:self afterDelay:0.3000];
}
-(void)play{
    iv.hidden = YES;
    [_moviePlayer play];
    [self.window addSubview:_moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
}
- (void) hidecontrol {
    [iv removeFromSuperview];
    [_moviePlayer.view removeFromSuperview];
    [self setStatusBarBackgroundColor:kColorHeader];
    
    //   [self performSelector:@selector(setcontroller) withObject:self afterDelay:0.0000];
    
}



-(void)pushmsgforios10:(PKPushPayload *)payload
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) { // Call category
        UNNotificationAction *act_ans =
        [UNNotificationAction actionWithIdentifier:@"Answer"
                                             title:NSLocalizedString(@"Answer", nil)
                                           options:UNNotificationActionOptionForeground];
        UNNotificationAction *act_dec = [UNNotificationAction actionWithIdentifier:@"Decline"
                                                                             title:NSLocalizedString(@"Decline", nil)
                                                                           options:UNNotificationActionOptionNone];
        UNNotificationCategory *cat_call =
        [UNNotificationCategory categoryWithIdentifier:@"call_cat"
                                               actions:[NSArray arrayWithObjects:act_ans, act_dec, nil]
                                     intentIdentifiers:[[NSMutableArray alloc] init]
                                               options:UNNotificationCategoryOptionCustomDismissAction];
        // Msg category
        UNTextInputNotificationAction *act_reply =
        [UNTextInputNotificationAction actionWithIdentifier:@"Reply"
                                                      title:NSLocalizedString(@"Reply", nil)
                                                    options:UNNotificationActionOptionNone];
        UNNotificationAction *act_seen =
        [UNNotificationAction actionWithIdentifier:@"Seen"
                                             title:NSLocalizedString(@"Mark as seen", nil)
                                           options:UNNotificationActionOptionNone];
        UNNotificationCategory *cat_msg =
        [UNNotificationCategory categoryWithIdentifier:@"msg_cat"
                                               actions:[NSArray arrayWithObjects:act_reply, act_seen, nil]
                                     intentIdentifiers:[[NSMutableArray alloc] init]
                                               options:UNNotificationCategoryOptionCustomDismissAction];
        
        // Video Request Category
        UNNotificationAction *act_accept =
        [UNNotificationAction actionWithIdentifier:@"Accept"
                                             title:NSLocalizedString(@"Accept", nil)
                                           options:UNNotificationActionOptionForeground];
        
        UNNotificationAction *act_refuse = [UNNotificationAction actionWithIdentifier:@"Cancel"
                                                                                title:NSLocalizedString(@"Cancel", nil)
                                                                              options:UNNotificationActionOptionNone];
        UNNotificationCategory *video_call =
        [UNNotificationCategory categoryWithIdentifier:@"video_request"
                                               actions:[NSArray arrayWithObjects:act_accept, act_refuse, nil]
                                     intentIdentifiers:[[NSMutableArray alloc] init]
                                               options:UNNotificationCategoryOptionCustomDismissAction];
        
        // ZRTP verification category
        UNNotificationAction *act_confirm = [UNNotificationAction actionWithIdentifier:@"Confirm"
                                                                                 title:NSLocalizedString(@"Accept", nil)
                                                                               options:UNNotificationActionOptionNone];
        
        UNNotificationAction *act_deny = [UNNotificationAction actionWithIdentifier:@"Deny"
                                                                              title:NSLocalizedString(@"Deny", nil)
                                                                            options:UNNotificationActionOptionNone];
        UNNotificationCategory *cat_zrtp =
        [UNNotificationCategory categoryWithIdentifier:@"zrtp_request"
                                               actions:[NSArray arrayWithObjects:act_confirm, act_deny, nil]
                                     intentIdentifiers:[[NSMutableArray alloc] init]
                                               options:UNNotificationCategoryOptionCustomDismissAction];
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |
                                          UNAuthorizationOptionBadge)
         completionHandler:^(BOOL granted, NSError *_Nullable error) {
             // Enable or disable features based on authorization.
             if (error) {
                 LOGD(error.description);
             }
         }];
        NSSet *categories = [NSSet setWithObjects:cat_call, cat_msg, video_call, cat_zrtp, nil];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
    }
    [LinphoneManager.instance setupNetworkReachabilityCallback];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self processRemoteNotification:payload.dictionaryPayload];
    });
}


-(void)presentsendpushmsg:(NSString*)callerstring
{
    NSTimer *videoDismissTimer = nil;
    
    UIConfirmationDialog *sheet =
    [UIConfirmationDialog ShowWithMessage:@"Send Raza Messsage!"
                            cancelMessage:nil
                           confirmMessage:NSLocalizedString(@"ACCEPT", nil)
                            onCancelClick:^() {
                                LOGI(@"User declined video proposal");
                                
                            }
                      onConfirmationClick:^() {
                          LOGI(@"User accept video proposal");
                          
                          LinphoneCore *lc = [LinphoneManager getLc];
                          NSString *replyText = @"Dummy push message sent!";//[(UNTextInputNotificationResponse *)response userText];
                          NSString *from = callerstring;//@"6304791564";//[response.notification.request.content.userInfo objectForKey:@"from_addr"];
                          LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
                          if (room) {
                              LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
                              linphone_chat_room_send_chat_message(room, msg);
                              linphone_chat_room_mark_as_read(room);
                          }
                          
                      }
                             inController:PhoneMainView.instance];
    
    videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                         target:self
                                                       selector:@selector(dismissVideoActionSheet:)
                                                       userInfo:sheet
                                                        repeats:NO];
}
-(void)setRazapushcallview
{
    Razacallview = [[UIView alloc] initWithFrame:self.window.bounds];
    Razacallview.backgroundColor=[UIColor whiteColor];
    NSString *callednumber=[self pushcallingraza:pushcall];
    if (!callednumber.length)
        callednumber=pushcall;
    
    UIImageView *imgrazacall=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH/2)-60, 60, 120 ,120)];
    // imgrazacall.backgroundColor=[UIColor lightGrayColor];
    imgrazacall.image=[UIImage imageNamed:@"raza_icn"];
    
    // raza_icn
    UIButton *disco=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHIGHT-50, SCREENWIDTH, 50)];
    disco.backgroundColor=[UIColor redColor];//[UIColor colorWithRed:237/255.0f green:85/255.0f blue:101/255.0f alpha:1.0f];
    [disco setTitle:@"Disconnect Call" forState:UIControlStateNormal];
    [disco addTarget:self
              action:@selector(disconnectcallaction)
    forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *connectingLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 200, SCREENWIDTH-60 ,30)];
    connectingLbl.textColor=[UIColor darkGrayColor];
    connectingLbl.font=[UIFont fontWithName:@"Poppins-Regular" size:14.0f];
    connectingLbl.text=[NSString stringWithFormat:@"Connecting to %@",callednumber];
    connectingLbl.textAlignment=NSTextAlignmentCenter;
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallRotate tintColor:[UIColor redColor]];
    
    activityIndicatorView.frame = CGRectMake((SCREENWIDTH/2)-30, 300, 60 , 60);
    [Razacallview addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    
    
    [Razacallview addSubview:connectingLbl];
    [Razacallview addSubview:disco];
    [Razacallview addSubview:imgrazacall];
    [self.window addSubview:Razacallview];
    [self performSelector:@selector(disconnectcallaction) withObject:self afterDelay:25];
    //   return Razacallview;
}
-(void)disconnectcallaction
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAZAMADECALLPUSH];
    [self removecallview];
}
-(void)removecallview{
    
    [Razacallview removeFromSuperview];
}
-(NSString *)pushcallingraza:(NSString*)callednumbervia
{
    NSString *callednumber;
    if (callednumbervia.length) {
        NSString  *cc=[[Razauser SharedInstance]getContactRazaPush:callednumbervia];
        //        if ([cc objectForKey:@"firstname"]&&[cc objectForKey:@"lastname"])
        //            callednumber=[NSString stringWithFormat:@"%@ %@",[cc objectForKey:@"firstname"],[cc objectForKey:@"lastname"]];
        //        else if ([cc objectForKey:@"firstname"])
        //            callednumber=[cc objectForKey:@"firstname"];
        //        else if ([cc objectForKey:@"lastname"])
        callednumber=cc;//[cc objectForKey:@"lastname"];
    }
    return callednumber;
}
/*--------TO:UMENIT This method for set addindatabase-----*/
-(void)addtopushdatabase:(NSString*)textmessage andurl:(NSString*)urlmessage andsender:(NSString*)senderurl
{
    sqlite3 *newDb;
    char *errMsg;
    NSString *newDbPath = [LinphoneManager documentFile:@"linphone_chats.db"];
    if (sqlite3_open([newDbPath UTF8String], &newDb) != SQLITE_OK) {
        LOGE(@"Can't open \"%@\" sqlite3 database.", newDbPath);
        //   return FALSE;
    }
    else
    {
        NSString *from =senderurl;// [notification.userInfo objectForKey:@"from_addr"];
        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
        if (room)
        {
            linphone_chat_room_mark_as_read(room);
            
        }
        
        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
        LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
        NSString *phoneNumber;
        senderurl=[NSString stringWithFormat:@"sip:%@@%@",senderurl,MAINRAZASIPURL];
        // [[Razauser SharedInstance]setPushrazaCounter:senderurl and:@"yes"];
        if (default_proxy != NULL)
            // const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
            phoneNumber = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
        if (phoneNumber.length) {
            const char *migration_statement ;
            if (urlmessage.length) {
                migration_statement = [[NSString stringWithFormat: @"INSERT INTO history (localContact,remoteContact,direction,url,utc,read,status,time,content) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%@\",\"%@\",\"%@\",\"%d\")", phoneNumber,senderurl,@"0",urlmessage,unixTime,@"1",@"2",@"-1",1]UTF8String];
                
                //            migration_statement= "INSERT INTO history (localContact,remoteContact,direction,message,utc,read,status,time) VALUES ('sip:6308156160@razasip.voipxonline.com','sip:6304791564@razasip.voipxonline.com','0','willwork','1483455389','1','2','-1')";
            }
            else
            {
                //   migration_statement= "INSERT INTO history (localContact,remoteContact,direction,message,utc,read,status,time) VALUES ('sip:6308156160@razasip.voipxonline.com','sip:6304791564@razasip.voipxonline.com','0','willwork','1483455389','1','2','-1')";
                
                migration_statement = [[NSString stringWithFormat: @"INSERT INTO history (localContact,remoteContact,direction,message,utc,read,status,time) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%@\",\"%@\",\"%@\")", phoneNumber,senderurl,@"0",textmessage,unixTime,@"1",@"2",@"-1"]UTF8String];
            }
            if (sqlite3_exec(newDb, migration_statement, NULL, NULL, &errMsg) != SQLITE_OK) {
                LOGE(@"DB migration failed, error[%s] ", errMsg);
                sqlite3_free(errMsg);
                
            }
        }
        sqlite3_close(newDb);
    }
}

/*--------TO:UMENIT This method for set Razapush-----*/
-(void)setrazapushnotification:(PKPushPayload *)payload
{
    localNotification = [[UILocalNotification alloc] init];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        
        NSString *callerid;
        NSString *modeofpushmsg;
        NSString *msgpush=[[payload.dictionaryPayload valueForKey:@"aps"] valueForKey:@"alert"];
        
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:msgpush,@"msgpush",@"voip",@"pushtype",[[RazaNotificationObject SharedInstance] getTime],@"pushtime",nil];
        pushdict=[[NSDictionary alloc]initWithDictionary:infoDict];
        NSArray *allobj=[[RazaNotificationObject SharedInstance] modeofpushmsg:msgpush];
        if (allobj.count==2) {
            if ([[allobj objectAtIndex:0] isEqualToString:@"Voicecall from "]) {
                callerid=[allobj objectAtIndex:1];
                modeofpushmsg=@"Voicecall from ";
                localNotification.soundName = UILocalNotificationDefaultSoundName;//RAZACALLINGTONE;//@"ringtone.wav";
                // [self performSelector:@selector(updob) withObject:self afterDelay:5.0 ];
                [self playringrepete];
                pushcall=callerid;
                localNotification.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
                incomingmissed=nil;
                //[Razauser SharedInstance].callmode=@"push";
            }
            else  if ([[allobj objectAtIndex:0] isEqualToString:@"Videocall from "]) {
                callerid=[allobj objectAtIndex:1];
                modeofpushmsg=@"Videocall from ";
                localNotification.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
                localNotification.soundName =UILocalNotificationDefaultSoundName;//RAZACALLINGTONE; //@"ringtone.wav";
                [self playringrepete];
                //[self performSelector:@selector(updob) withObject:self afterDelay:5.0 ];
                pushcall=callerid;
                incomingmissed=nil;
                // [Razauser SharedInstance].callmode=@"push";
            }
            else  if ([[allobj objectAtIndex:0] isEqualToString:@"Missed Voice call from "]) {
                callerid=[allobj objectAtIndex:1];
                modeofpushmsg=@"Missed Voice call from ";
                localNotification.soundName =UILocalNotificationDefaultSoundName; //@"ringtone.wav";
                pushcall=callerid;
                incomingmissed=nil;
                [[Razauser SharedInstance] setmissed:YES];
                [[Razauser SharedInstance]addCallToDatabase:nil andsender:pushcall];
                //  [Razauser SharedInstance].callmode=nil;
            }
            else  if ([[allobj objectAtIndex:0] isEqualToString:@"Missed Video call from "]) {
                callerid=[allobj objectAtIndex:1];
                modeofpushmsg=@"Missed Video call from ";
                localNotification.soundName =UILocalNotificationDefaultSoundName; //@"ringtone.wav";
                pushcall=callerid;
                incomingmissed=nil;
                [[Razauser SharedInstance] setmissed:YES];
                [[Razauser SharedInstance]addCallToDatabase:nil andsender:pushcall];
                //[Razauser SharedInstance].callmode=nil;
            }
            else  if ([[allobj objectAtIndex:0] isEqualToString:@"Missed call from "]) {
                callerid=[allobj objectAtIndex:1];
                modeofpushmsg=@"Missed call from ";
                localNotification.soundName =UILocalNotificationDefaultSoundName; //@"ringtone.wav";
                pushcall=callerid;
                incomingmissed=nil;
                [[Razauser SharedInstance] setmissed:YES];
                [[Razauser SharedInstance]addCallToDatabase:nil andsender:pushcall];
                // [Razauser SharedInstance].callmode=nil;
            }
            else
            {
                callerid=[allobj objectAtIndex:0];
                
                NSString  *sendermessage=[allobj objectAtIndex:1];
                //  NSData* data = [[allobj objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
                //                 NSString *xmlString = @" <?xml version=\"1.0\" encoding=\"UTF-8\"?><file xmlns=\"urn:gsma:params:xml:ns:rcs:rcs:fthttp\">\r\n<file-info type=\"file\">\r\n<file-size>15921</file-size>\r\n<file-name>379830256-505378117.979846.jpg</file-name>\r\n<content-type>image/jpeg</content-type>\r\n<data url = \"http://54.215.183.119/floovr/raza/tmp/586c9b0ee248c_a0907f1d67208afc2245.jpg\" until = \"2017-01-11T06:49:50Z\"/>\r\n</file-info>\r\n</file>";
                NSString *trimmedString = [sendermessage stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceCharacterSet]];
                //                if (ncallerid1&&xmlString) {
                //                 //   NSData *data = [[allobj objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
                //                    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:trimmedString];
                //                    NSLog(@"dictionary: %@", xmlDoc);
                NSError *parseError = nil;
                
                NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:trimmedString error:&parseError];
                NSString *imageurl=[[[[xmlDictionary valueForKey:@"file"] valueForKey:@"file-info"] valueForKey:@"data"] valueForKey:@"url"];
                pushcall=callerid;
                if ([[xmlDictionary allKeys]count]&&imageurl) {
                    
                    modeofpushmsg=@"Image recieved";
                    [self addtopushdatabase:nil andurl:imageurl andsender:callerid];
                    
                }
                else  if (!([[xmlDictionary allKeys]count])) {
                    
                    modeofpushmsg=sendermessage;
                    [self addtopushdatabase:sendermessage andurl:nil andsender:callerid];
                    
                }
                else
                    modeofpushmsg=nil;
                //  NSLog(@"%@--%@",xmlDictionary,st);
                // }
                pushcall=callerid;
                incomingmissed=@"chat";
                //                [self pushmsgforios10:payload];
                //               // modeofpushmsg=@"chat";
                //                if (imageurl.length)
                //                    [self addtopushdatabase:nil andurl:imageurl andsender:callerid];
                //                else
                //                    [self addtopushdatabase:@"pushmessage" andurl:nil andsender:callerid];
                
                //  [self AddpushmessageinDb:callerid andmessageinfo:[allobj objectAtIndex:1]];
                
            }
        }
        //        UILabel *label=[[UILabel alloc]init];
        //        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:callerid];
        //        [ContactDisplay setDisplayNameLabelRaza:label forAddress:addr];
        //        NSString *ss=label.text;
        //        if (ss) {
        //
        //        }
        NSString *callednumber=[self pushcallingraza:pushcall];
        if (!callednumber.length)
            callednumber=callerid;
        if ([modeofpushmsg isEqualToString:@"Videocall from "]||[modeofpushmsg isEqualToString:@"Voicecall from "] || [modeofpushmsg isEqualToString:@"Missed Voice call from "]||[modeofpushmsg isEqualToString:@"Missed Video call from "]||[modeofpushmsg isEqualToString:@"Missed call from "]) {
            localNotification.fireDate = [NSDate date];//[NSDate dateWithTimeIntervalSinceNow:60];
            
            
            localNotification.alertBody =[NSString stringWithFormat:@"%@%@",modeofpushmsg,callednumber];
            //[NSString stringWithFormat:@"%@%@",modeofpushmsg,basenumber];
            
            
            pushcall=callerid;
            localNotification.userInfo = infoDict;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            
            // localNotification.repeatInterval = kCFCalendarUnitSecond;
            //localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            if ([modeofpushmsg isEqualToString:@"Missed Voice call from "]||[modeofpushmsg isEqualToString:@"Missed Video call from "]||[modeofpushmsg isEqualToString:@"Missed call from "])
            {
                //localNotification.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
                basetimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removemissed) userInfo:nil repeats:NO];
            }
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
        }
        else if (modeofpushmsg.length) {
            localNotification.fireDate = [NSDate date];//[NSDate dateWithTimeIntervalSinceNow:60];
            
            
            localNotification.alertBody =[NSString stringWithFormat:@"%@: %@",callednumber,modeofpushmsg];
            //[NSString stringWithFormat:@"%@%@",modeofpushmsg,basenumber];
            
            NSString *msgurl=[NSString stringWithFormat:@"sip:%@@%@",callerid,MAINRAZASIPURL];
            [[Razauser SharedInstance]setPushrazaCounter:msgurl and:@"yes"];
            pushcall=callerid;
            NSDictionary *infoDictcall = [NSDictionary dictionaryWithObjectsAndKeys:callerid,@"pushmsg",nil];
            
            localNotification.userInfo = infoDictcall;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
            [UIApplication sharedApplication].applicationIconBadgeNumber=++[UIApplication sharedApplication].applicationIconBadgeNumber;
            //localNotification.soundName = UILocalNotificationDefaultSoundName;
            //[self repeteinterval:localNotification];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        // if ([[loginInfo objectForKey:LOGIN_RESPONSE_STATUS] boolValue])
        //   [self startSIPService:@"foreground"];
        
        // [[NgnEngine sharedInstance].soundService playRingToneforaudio:@"tone_1.mp3"];
        
    }
    
    
}
-(void)removemissed
{
    [playertest stop];
    [_bgManager endTask];
    // [player stop];
    [basetimer invalidate];
    // [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(loadmissedcounter) userInfo:nil repeats:NO];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(void)playring
{
    
    //    NSString *path;
    //
    //    NSURL *url;
    //
    //    //where you are about to add sound
    //
    //    path =[[NSBundle mainBundle] pathForResource:@"Ringtone2" ofType:@"mp3"];
    //
    //    url = [NSURL fileURLWithPath:path];
    //  player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    //    [player setVolume:1.0];
    //    player.numberOfLoops=3;
    //    [player prepareToPlay];
    //    [player play];
    
    //AVAudioSession *session = [AVAudioSession sharedInstance];
    //[session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
}
-(void)loadmissedcounter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        
        int stringbadge= [[Razauser SharedInstance]getmissed];
        DialerView *view = VIEW(DialerView);
        [view updatechatrecent:stringbadge];
        //  [view  updatechatreadunreadcounter:1];
    });
}
-(void)vibratePhone
{
    [self playring];
    //    counter=++counter;
    //    [self repeteinterval:localNotification];
    //    if (counter==3) {
    //        counter=0;
    //        [basetimer invalidate];
    //    }
}
-(void)repeteinterval:(UILocalNotification*)localNotification1
{
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification1];
}
-(void)pushtoperticularcontroller:(LinphoneChatRoom*)room
{
    
    
    ChatConversationView *view = VIEW(ChatConversationView);
    [view setChatRoom:room];
    // [PhoneMainView.instance popCurrentView];
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
    // refresh list of chatrooms if we are using fragment
    if (IPAD) {
        ChatsListView *listView = VIEW(ChatsListView);
        [listView.tableController loadData];
    }
    
}
- (void)requestCameraPermissionsIfNeeded {
    
    // check camera authorization status
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized: { // camera authorized
            // do camera intensive stuff
        }
            break;
        case AVAuthorizationStatusNotDetermined: { // request authorization
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(granted) {
                        // do camera intensive stuff
                    } else {
                        //[self notifyUserOfCameraAccessDenial];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self notifyUserOfCameraAccessDenial];
            });
        }
            break;
        default:
            break;
    }
}

//-(void)ConfigureHockeysdk
//{
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"426f9b0125bb69524a1b8940a76ec169"];//68ae51def007660fa1e0d7e00e28f3c7
//    [[BITHockeyManager sharedHockeyManager] startManager];
//    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
//}
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}

-(void)showdurationcalling
{
    
    // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (LC!=NULL) {
        LinphoneCall *call = linphone_core_get_current_call(LC);
        
        if (!call) {
            const MSList *calls = linphone_core_get_calls(LC);
            while (calls) {
                call = calls->data;
                durationcall=call;
                break;
                //                if (linphone_call_get_state(call) == LinphoneCallPaused) {
                //                    break;
                //
                //                    }
            }
        }
        
        if (call) {
            
            durationtimer= [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(updatecallonwait)
                                                          userInfo:nil
                                                           repeats:YES];
            
            [self setStatusBarBackgroundColor:[UIColor redColor]];
            [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
            
            UILabel *labelforcallduratio11n = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20) ];
            _labelforcallduration = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20) ];
            _labelforcallduration.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:12];
            _labelforcallduration.backgroundColor=[UIColor colorWithRed:73/255.0 green:211/255.0 blue:33/255.0  alpha:1];
            const LinphoneAddress *addr = linphone_call_get_remote_address(call);
            // self.window.frame=CGRectMake(0, 20, SCREENWIDTH, SCREENHIGHT-20);
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            Contact *contact = [FastAddressBook getContactWithAddressRaza:addr];
            if (contact) {
                [ContactDisplay setDisplayNameLabelRaza:labelforcallduratio11n forContact:contact];
            } else {
                labelforcallduratio11n.text = [FastAddressBook displayNameForAddress:addr];
            }
            NSString *ss=labelforcallduratio11n.text;
            if (ss.length)
                callingnumber=ss;
            [_labelforcallduration setText:@""];
            
            
            UILabel *returnLbl = [ [UILabel alloc ] initWithFrame:CGRectMake(30, 0, 100, 20) ];
            returnLbl.font=[UIFont fontWithName:@"SourceSansPro-Bold" size:12];
            returnLbl.textColor=[UIColor whiteColor];
            returnLbl.text=@"Return to call";
            [_labelforcallduration addSubview:returnLbl];
            
            UIImageView *returnCallImgView = [ [UIImageView alloc ] initWithFrame:CGRectMake(10, 3, 14, 14) ];
            returnCallImgView.image=[UIImage imageNamed:@"callHome.png"];
            [_labelforcallduration addSubview:returnCallImgView];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            [_labelforcallduration addGestureRecognizer:singleFingerTap];
            _labelforcallduration.userInteractionEnabled = YES;
            [self.window addSubview:_labelforcallduration];
        }
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    [PhoneMainView.instance popToView:CallView.compositeViewDescription];
}
-(void)updatecallonwait
{
    if (LC!=NULL) {
        int duration =
        linphone_core_get_current_call(LC) ? linphone_call_get_duration(linphone_core_get_current_call(LC)) : 0;
        
        //        if (duration==0) {
        //            duration=durationcall ? linphone_call_get_duration(durationcall) : 0;
        //        }
        //_durationLabel.text = [LinphoneUtils durationToString:duration];
        _labelforcallduration.textColor=[UIColor whiteColor];
        _labelforcallduration.textAlignment=NSTextAlignmentRight;
        
        if (duration==0){
            [_labelforcallduration setText:callingnumber];
            [self hidedurationcalling];
        }
        else
            [_labelforcallduration setText:[NSString stringWithFormat:@"%@  %@\t",callingnumber,[LinphoneUtils durationToString:duration]]];
        
    }
    
}
-(void)hidedurationcalling{
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    [self setStatusBarBackgroundColor:kColorHeader];
    self.window.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT);
    [_labelforcallduration removeFromSuperview];
    [durationtimer invalidate];
    
}

-(void)setaudiomode
{
    
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //   [session setActive:YES error:nil];
    //     [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // Active your audio session
    [audioSession setActive: NO error: nil];
    
    // Set audio session category
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // Modifying Playback Mixing Behavior, allow playing music in other apps
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    
    propertySetError = AudioSessionSetProperty (
                                                kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                sizeof (allowMixing),
                                                &allowMixing);
    
    // Active your audio session
    [audioSession setActive: YES error: nil];
    
}
-(void)set{
    NSString *path;
    
    NSURL *url;
    
    //where you are about to add sound
    
    path =[[NSBundle mainBundle] pathForResource:@"Ringtone2" ofType:@"mp3"];
    
    url = [NSURL fileURLWithPath:path];
    playertest = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [playertest setVolume:1.0];
    playertest.numberOfLoops=-1;
    [playertest prepareToPlay];
    [playertest play];
}
-(void)sethockeyapp
{
    //    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"4df98d88f6d54754b6e44c4e00f54674"];//68ae51def007660fa1e0d7e00e28f3c7
    //    [[BITHockeyManager sharedHockeyManager] startManager];
    //    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
}
@end
