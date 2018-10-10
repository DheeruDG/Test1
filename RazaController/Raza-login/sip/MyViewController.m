//
//  MyViewController.m
//  linphone
//
//  Created by umenit on 11/21/16.
//
//

#import "MyViewController.h"

#import "PhoneMainView.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)callfornotify
{
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(registrationUpdateEvent:)
                                               name:kLinphoneRegistrationUpdate
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(configuringUpdate:)
                                               name:kLinphoneConfiguringStateUpdate
                                             object:nil];
    [[RazaBaseClass SharedInstance]ShowWaiting:@"Configuring..."];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAssistantConfig:@"assistant_external_sip.rc"];
    });
    
}
static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:StatusBarView.class
                                                                 tabBar:nil
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:nil];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}
- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)LOGINCLICKED:(id)sender {
    // [self loadAssistantConfig:@"assistant_linphone_existing.rc"];
    // [self configureProxyConfig]
    //[[RazaBaseClass SharedInstance] ShowWaiting:nil];
    
}
- (void)loadAssistantConfig:(NSString *)rcFilename {
    NSString *fullPath = [@"file://" stringByAppendingString:[LinphoneManager bundleFile:rcFilename]];
    linphone_core_set_provisioning_uri(LC, fullPath.UTF8String);
    [LinphoneManager.instance lpConfigSetInt:1 forKey:@"transient_provisioning" inSection:@"misc"];
    
    [self resetLiblinphone];
    if (LC==NULL) {
        NSLog(@"gg");
    }
    [self configureProxyConfig];
}
- (void)resetLiblinphone {
    if (account_creator) {
        linphone_account_creator_unref(account_creator);
        account_creator = NULL;
    }
    [LinphoneManager.instance resetLinphoneCore];
    account_creator = linphone_account_creator_new(
                                                   LC, [LinphoneManager.instance lpConfigStringForKey:@"xmlrpc_url" inSection:@"assistant" withDefault:@""]
                                                   .UTF8String);
    linphone_account_creator_set_user_data(account_creator, (__bridge void *)(self));
    linphone_account_creator_cbs_set_is_account_used(linphone_account_creator_get_callbacks(account_creator),
                                                     assistant_is_account_used1);
    linphone_account_creator_cbs_set_create_account(linphone_account_creator_get_callbacks(account_creator),
                                                    assistant_create_account1);
    linphone_account_creator_cbs_set_activate_account(linphone_account_creator_get_callbacks(account_creator),
                                                      assistant_activate_account1);
    linphone_account_creator_cbs_set_is_account_activated(linphone_account_creator_get_callbacks(account_creator),
                                                          assistant_is_account_activated1);
    linphone_account_creator_cbs_set_recover_phone_account(linphone_account_creator_get_callbacks(account_creator),
                                                           assistant_recover_phone_account1);
    linphone_account_creator_cbs_set_is_account_linked(linphone_account_creator_get_callbacks(account_creator),
                                                       assistant_is_account_linked1);
    
}
void assistant_is_account_used1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status, const char *resp) {
    MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    // thiz.waitView.hidden = YES;
    [thiz isAccountUsed1:status withResp:resp];
}
- (void)isAccountUsed1:(LinphoneAccountCreatorStatus)status withResp:(const char *)resp {
    if (currentView == _linphoneLoginView) {
        if (status == LinphoneAccountCreatorAccountExistWithAlias) {
            _outgoingView = DialerView.compositeViewDescription;
            [self configureProxyConfig];
        }
        //else if (status == LinphoneAccountCreatorAccountExist) {
        //            _outgoingView = AssistantLinkView.compositeViewDescription;
        //            [self configureProxyConfig];
        //        } else {
        //            if (linphone_account_creator_get_username(account_creator) && (strcmp(resp, "ERROR_ACCOUNT_DOESNT_EXIST") == 0)) {
        //                [self showErrorPopup:"ERROR_BAD_CREDENTIALS"];
        //            } else {
        //                [self showErrorPopup:resp];
        //            }
        //        }
    } else {
        if (status == LinphoneAccountCreatorAccountExist || status == LinphoneAccountCreatorAccountExistWithAlias) {
            if (linphone_account_creator_get_phone_number(account_creator) != NULL) {
                // Offer the possibility to resend a sms confirmation in some cases
                linphone_account_creator_is_account_activated(account_creator);
            } else {
                //  [self showErrorPopup:resp];
            }
        } else if (status == LinphoneAccountCreatorAccountNotExist) {
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            linphone_account_creator_set_language(account_creator, [[language substringToIndex:2] UTF8String]);
            linphone_account_creator_create_account(account_creator);
        } else {
            // [self showErrorPopup:resp];
            
        }
    }
}
void assistant_create_account1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status, const char *resp) {
    //MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    // thiz.waitView.hidden = YES;
    if (status == LinphoneAccountCreatorAccountCreated) {
        if (linphone_account_creator_get_phone_number(creator)) {
            //    NSString* phoneNumber = [NSString stringWithUTF8String:linphone_account_creator_get_phone_number(creator)];
            // thiz.activationSMSText.text = [NSString stringWithFormat:NSLocalizedString(@"We have sent a SMS with a validation code to %@. To complete your phone number verification, please enter the 4 digit code below:", nil), phoneNumber];
            // [thiz changeView:thiz.createAccountActivateSMSView back:FALSE animation:TRUE];
        } else {
            //NSString* email = [NSString stringWithUTF8String:linphone_account_creator_get_email(creator)];
            // thiz.activationEmailText.text = [NSString stringWithFormat:NSLocalizedString(@" Your account is created. We have sent a confirmation email to %@. Please check your mails to validate your account. Once it is done, come back here and click on the button.", nil), email];
            //  [thiz changeView:thiz.createAccountActivateEmailView back:FALSE animation:TRUE];
        }
    } else {
        // [thiz showErrorPopup:resp];
    }
}
void assistant_activate_account1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status,
                                 const char *resp) {
    //MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    //thiz.waitView.hidden = YES;
    if (status == LinphoneAccountCreatorAccountActivated) {
        // [thiz configureProxyConfig];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLinphoneAddressBookUpdate object:NULL];
    } else if (status == LinphoneAccountCreatorAccountAlreadyActivated) {
        // in case we are actually trying to link account, let's try it now
        linphone_account_creator_activate_phone_number_link(creator);
    } else {
        // [thiz showErrorPopup:resp];
    }
}
void assistant_is_account_activated1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status,
                                     const char *resp) {
    MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    //thiz.waitView.hidden = YES;
    if (status == LinphoneAccountCreatorAccountActivated) {
        [thiz isAccountActivated1:resp];
    } else if (status == LinphoneAccountCreatorAccountNotActivated) {
        if (!IPAD || linphone_account_creator_get_phone_number(creator) != NULL) {
            //Re send SMS if the username is the phone number
            if (linphone_account_creator_get_username(creator) != linphone_account_creator_get_phone_number(creator) && linphone_account_creator_get_username(creator) != NULL) {
                //[thiz showErrorPopup:"ERROR_ACCOUNT_ALREADY_IN_USE"];
                // [thiz findButton:ViewElement_NextButton].enabled = NO;
            } else {
                NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                linphone_account_creator_set_language(creator, [[language substringToIndex:2] UTF8String]);
                linphone_account_creator_recover_phone_account(creator);
            }
        } else {
            // TO DO : Re send email ?
            //[thiz showErrorPopup:"ERROR_ACCOUNT_ALREADY_IN_USE"];
            // [thiz findButton:ViewElement_NextButton].enabled = NO;
        }
    } else {
        //[thiz showErrorPopup:resp];
    }
}
void assistant_recover_phone_account1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status,
                                      const char *resp) {
    // MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    // thiz.waitView.hidden = YES;
    if (status == LinphoneAccountCreatorOK) {
        NSString* phoneNumber = [NSString stringWithUTF8String:linphone_account_creator_get_phone_number(creator)];
        NSLog(@"%@",phoneNumber);
        //thiz.activationSMSText.text = [NSString stringWithFormat:NSLocalizedString(@"We have sent a SMS with a validation code to %@. To complete your phone number verification, please enter the 4 digit code below:", nil), phoneNumber];
        //  [thiz changeView:thiz.createAccountActivateSMSView back:FALSE animation:TRUE];
    } else {
        if(!resp) {
            //  [thiz showErrorPopup:"ERROR_CANNOT_SEND_SMS"];
        } else {
            //[thiz showErrorPopup:resp];
        }
    }
}
void assistant_is_account_linked1(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status,
                                  const char *resp) {
    // MyViewController *thiz = (__bridge MyViewController *)(linphone_account_creator_get_user_data(creator));
    // thiz.waitView.hidden = YES;
    if (status == LinphoneAccountCreatorAccountLinked) {
        [LinphoneManager.instance lpConfigSetInt:0 forKey:@"must_link_account_time"];
    } else if (status == LinphoneAccountCreatorAccountNotLinked) {
        [LinphoneManager.instance lpConfigSetInt:[NSDate new].timeIntervalSince1970 forKey:@"must_link_account_time"];
    } else {
        // [thiz showErrorPopup:resp];
    }
}
- (void) isAccountActivated1:(const char *)resp {
    //    if (currentView != _createAccountView) {
    //        if( linphone_account_creator_get_phone_number(account_creator) == NULL) {
    //            [self configureProxyConfig];
    //            [PhoneMainView.instance changeCurrentView:AssistantLinkView.compositeViewDescription];
    //        } else {
    //            [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    //        }
    //    } else {
    //        if (!linphone_account_creator_get_username(account_creator)) {
    //            [self showErrorPopup:"ERROR_ALIAS_ALREADY_IN_USE"];
    //        } else {
    //            [self showErrorPopup:"ERROR_ACCOUNT_ALREADY_IN_USE"];
    //        }
    //    }
}
- (void)configureProxyConfig {
    LinphoneManager *lm = LinphoneManager.instance;
    
    //    if (!linphone_core_is_network_reachable(LC)) {
    //        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Network Error", nil)
    //                                                                         message:NSLocalizedString(@"There is no network connection available, enable "
    //                                                                                                   @"WIFI or WWAN prior to configure an account",
    //                                                                                                   nil)
    //                                                                  preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                                style:UIAlertActionStyleDefault
    //                                                              handler:^(UIAlertAction * action) {}];
    //
    //        [errView addAction:defaultAction];
    //        [self presentViewController:errView animated:YES completion:nil];
    //       // _waitView.hidden = YES;
    //        return;
    //    }
    
    // remove previous proxy config, if any
    //    if (new_config != NULL) {
    //        //linphone_core_remove_proxy_config(LC, new_config);
    //        const LinphoneAuthInfo *auth = linphone_proxy_config_find_auth_info(new_config);
    //        linphone_core_remove_proxy_config(LC, new_config);
    //        if (auth) {
    //            linphone_core_remove_auth_info(LC, auth);
    //        }
    //    }
    
    // set transport
    //  UISegmentedControl *transports = (UISegmentedControl *)[self findView:ViewElement_Transport
    //    inView:self.contentView
    //   ofType:UISegmentedControl.class];
    // if (transports) {
    
    [self setconf];
    //    NSString *tmp_phone =
    //    [NSString stringWithUTF8String:linphone_account_creator_get_username(account_creator)];
    //    if (tmp_phone) {
    //
    //    }
    NSString *type = @"TCP";//[transports titleForSegmentAtIndex:[transports selectedSegmentIndex]];
    if (type) {
        // linphone_account_creator_set_transport(account_creator,
        // linphone_transport_parse(type.lowercaseString.UTF8String));
        linphone_account_creator_set_transport(account_creator,LinphoneTransportUdp
                                               );
    }
    
    
    
    new_config = linphone_account_creator_configure(account_creator);
    
    if (new_config) {
        [lm configurePushTokenForProxyConfig:new_config];
        linphone_core_set_default_proxy_config(LC, new_config);
        // reload address book to prepend proxy config domain to contacts' phone number
        // todo: STOP doing that!
        [[LinphoneManager.instance fastAddressBook] reload];
    } else {
        UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Assistant error", nil)
                                                                         message:NSLocalizedString(@"Could not configure your account, please check parameters or try again later",
                                                                                                   nil)
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errView addAction:defaultAction];
        [self presentViewController:errView animated:YES completion:nil];
        // _waitView.hidden = YES;
        return;
    }
}
- (void)registrationUpdateEvent:(NSNotification *)notif {
    NSString *message = [notif.userInfo objectForKey:@"message"];
    [self registrationUpdate:[[notif.userInfo objectForKey:@"state"] intValue]
                    forProxy:[[notif.userInfo objectForKeyedSubscript:@"cfg"] pointerValue]
                     message:message];
}

- (void)registrationUpdate:(LinphoneRegistrationState)state
                  forProxy:(LinphoneProxyConfig *)proxy
                   message:(NSString *)message {
    // in assistant we only care about ourself
    if (proxy != new_config) {
        return;
    }
    
    switch (state) {
        case LinphoneRegistrationOk: {
            // _waitView.hidden = true;
            
            [LinphoneManager.instance
             lpConfigSetInt:[NSDate new].timeIntervalSince1970 +
             [LinphoneManager.instance lpConfigIntForKey:@"link_account_popup_time" withDefault:84200]
             forKey:@"must_link_account_time"];
            //  [PhoneMainView.instance popToView:_outgoingView];
            break;
        }
        case LinphoneRegistrationNone:
        case LinphoneRegistrationCleared: {
            //  _waitView.hidden = true;
            break;
        }
        case LinphoneRegistrationFailed: {
            //_waitView.hidden = true;
            UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Registration failure", nil)
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            UIAlertAction* continueAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [PhoneMainView.instance popToView:DialerView.compositeViewDescription];
                                                                   }];
            
            [errView addAction:defaultAction];
            [errView addAction:continueAction];
            [self presentViewController:errView animated:YES completion:nil];
            break;
        }
        case LinphoneRegistrationProgress: {
            //  _waitView.hidden = false;
            break;
        }
        default:
            break;
    }
}
- (void)configuringUpdate:(NSNotification *)notif {
    LinphoneConfiguringState status = (LinphoneConfiguringState)[[notif.userInfo valueForKey:@"state"] integerValue];
    
    //  _waitView.hidden = true;
    
    switch (status) {
        case LinphoneConfiguringSuccessful:
            // we successfully loaded a remote provisioned config, go to dialer
            [LinphoneManager.instance lpConfigSetInt:[NSDate new].timeIntervalSince1970
                                              forKey:@"must_link_account_time"];
            if (number_of_configs_before < bctbx_list_size(linphone_core_get_proxy_config_list(LC))) {
                LOGI(@"A proxy config was set up with the remote provisioning, skip assistant");
                [self onDialerClick:nil];
            }
            
            if (nextView == nil) {
                [self fillDefaultValues];
            } else {
                //[self changeView:nextView back:false animation:TRUE];
                nextView = nil;
            }
            break;
        case LinphoneConfiguringFailed: {
            NSString *error_message = [notif.userInfo valueForKey:@"message"];
            UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Provisioning Load error", nil)
                                                                             message:error_message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [errView addAction:defaultAction];
            [self presentViewController:errView animated:YES completion:nil];
            break;
        }
            
        case LinphoneConfiguringSkipped:
        default:
            break;
    }
}
- (IBAction)onDialerClick:(id)event {
    
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
    [[RazaBaseClass SharedInstance]HideWaiting];
}
- (void)fillDefaultValues {
    // [self resetTextFields];
    
    LinphoneProxyConfig *default_conf = linphone_core_create_proxy_config(LC);
    const char *identity = linphone_proxy_config_get_identity(default_conf);
    if (identity) {
        LinphoneAddress *default_addr = linphone_core_interpret_url(LC, identity);
        if (default_addr) {
            const char *domain = linphone_address_get_domain(default_addr);
            const char *username = linphone_address_get_username(default_addr);
            if (domain && strlen(domain) > 0) {
                // [self findTextField:ViewElement_Domain].text = [NSString stringWithUTF8String:domain];
            }
            if (username && strlen(username) > 0 && username[0] != '?') {
                // [self findTextField:ViewElement_Username].text = [NSString stringWithUTF8String:username];
            }
        }
    }
    
    //[self changeView:_remoteProvisioningLoginView back:FALSE animation:TRUE];
    
    linphone_proxy_config_destroy(default_conf);
}
-(void)setconf
{
    NSDictionary *dict = [RAZA_USERDEFAULTS objectForKey:@"logininfo"];
    //    {
    //        accessno = "630-818-2157";
    //        email = "testuser2@razatelecom.com";
    //        id = 1507123;
    //        pin = 1111985347;
    //        sippwd = "1Xo%z9+AG-g23J!wMx8_";
    //        status = 1;
    //        usertype = old;
    //    <ResponseCode>string</ResponseCode>
    //    <ResponseMessage>string</ResponseMessage>
    //    <Id>string</Id>
    //    <EmailAddress>string</EmailAddress>
    //    <Pin>string</Pin>
    //    <AutoRefillEnrolled>boolean</AutoRefillEnrolled>
    //    <AccessNumber>string</AccessNumber>
    //    <SipPassword>string</SipPassword>
    //    <UserType>string</UserType>
    //    <SessionId>string</SessionId>
    //    }
    NSString *loogedphone = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"sipphone"];
    
    NSString *loggeduser=loogedphone;//@"9900000088";
    LinphoneAccountCreatorStatus s =  linphone_account_creator_set_username(account_creator, loggeduser.UTF8String);
    if (s != LinphoneAccountCreatorOK)
        linphone_account_creator_set_username(account_creator, NULL);
    NSString *loggeduserpass=[dict objectForKey:@"SipPassword"];//@"testumenit123@123";
    linphone_account_creator_set_password(account_creator, loggeduserpass.UTF8String);
    NSString *loggeduserdomain=MAINRAZASIPURL;//@"razasip.voipxonline.com";
    linphone_account_creator_set_domain(account_creator, loggeduserdomain.UTF8String);
    
    
    //linphone_nat_policy_ice_enabled(linphone_core_get_nat_policy(LC))
    
}
//- (void)prepareErrorLabels {
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
//    UIAssistantTextField *createUsername = [self findTextField:ViewElement_Username];
//    [createUsername showError:[AssistantView errorForStatus:LinphoneAccountCreatorUsernameInvalid]
//                         when:^BOOL(NSString *inputEntry) {
//                             LinphoneAccountCreatorStatus s =
//                             linphone_account_creator_set_username(account_creator, inputEntry.UTF8String);
//                             if (s != LinphoneAccountCreatorOK) linphone_account_creator_set_username(account_creator, NULL);
//                            // createUsername.errorLabel.text = [AssistantView errorForStatus:s];
//                             return s != LinphoneAccountCreatorOK;
//                         }];
//    UIAssistantTextField *createPhone = [self findTextField:ViewElement_Phone];
//    [createPhone showError:[AssistantView errorForStatus:LinphoneAccountCreatorPhoneNumberInvalid]
//                      when:^BOOL(NSString *inputEntry) {
//                          
//                          UIAssistantTextField* countryCodeField = [self findTextField:ViewElement_PhoneCC];
//                          NSString *newStr = [countryCodeField.text substringWithRange:NSMakeRange(1, [countryCodeField.text length]-1)];
//                          NSString *prefix = (inputEntry.length > 0) ? newStr : nil;
//                          LinphoneAccountCreatorStatus s =
//                          linphone_account_creator_set_phone_number(account_creator, inputEntry.length > 0 ? inputEntry.UTF8String : NULL, prefix.UTF8String);
//                          if (s != LinphoneAccountCreatorOK) {
//                              linphone_account_creator_set_phone_number(account_creator, NULL, NULL);
//                              // if phone is empty and username is empty, this is wrong
//                              if (linphone_account_creator_get_username(account_creator) == NULL) {
//                                  s = LinphoneAccountCreatorPhoneNumberTooShort;
//                              }
//                          }
//                          
//                          createPhone.errorLabel.text = [AssistantView errorForStatus:s];
//                          
//                          return s != LinphoneAccountCreatorOK;
//                      }];
//    
//    UIAssistantTextField *password = [self findTextField:ViewElement_Password];
//    [password showError:[AssistantView errorForStatus:LinphoneAccountCreatorPasswordTooShort]
//                   when:^BOOL(NSString *inputEntry) {
//                       LinphoneAccountCreatorStatus s =
//                       linphone_account_creator_set_password(account_creator, inputEntry.UTF8String);
//                       password.errorLabel.text = [AssistantView errorForStatus:s];
//                       return s != LinphoneAccountCreatorOK;
//                   }];
//    
//    UIAssistantTextField *password2 = [self findTextField:ViewElement_Password2];
//    [password2 showError:NSLocalizedString(@"The confirmation code is invalid. \nPlease check your SMS and try again.", nil)
//                    when:^BOOL(NSString *inputEntry) {
//                        return ![inputEntry isEqualToString:[self findTextField:ViewElement_Password].text];
//                    }];
//    
//    UIAssistantTextField *email = [self findTextField:ViewElement_Email];
//    [email showError:[AssistantView errorForStatus:LinphoneAccountCreatorEmailInvalid]
//                when:^BOOL(NSString *inputEntry) {
//                    LinphoneAccountCreatorStatus s =
//                    linphone_account_creator_set_email(account_creator, inputEntry.UTF8String);
//                    email.errorLabel.text = [AssistantView errorForStatus:s];
//                    return s != LinphoneAccountCreatorOK;
//                }];
//    
//    UIAssistantTextField *domain = [self findTextField:ViewElement_Domain];
//    [domain showError:[AssistantView errorForStatus:LinphoneAccountCreatorDomainInvalid]
//                 when:^BOOL(NSString *inputEntry) {
//                     LinphoneAccountCreatorStatus s =
//                     linphone_account_creator_set_domain(account_creator, inputEntry.UTF8String);
//                     domain.errorLabel.text = [AssistantView errorForStatus:s];
//                     return s != LinphoneAccountCreatorOK;
//                 }];
//    
//    UIAssistantTextField *url = [self findTextField:ViewElement_URL];
//    [url showError:NSLocalizedString(@"Invalid remote provisioning URL", nil)
//              when:^BOOL(NSString *inputEntry) {
//                  if (inputEntry.length > 0) {
//                      // missing prefix will result in http:// being used
//                      if ([inputEntry rangeOfString:@"://"].location == NSNotFound) {
//                          inputEntry = [NSString stringWithFormat:@"http://%@", inputEntry];
//                      }
//                      return (linphone_core_set_provisioning_uri(LC, inputEntry.UTF8String) != 0);
//                  }
//                  return TRUE;
//              }];
//    
//    UIAssistantTextField *displayName = [self findTextField:ViewElement_DisplayName];
//    [displayName showError:[AssistantView errorForStatus:LinphoneAccountCreatorDisplayNameInvalid]
//                      when:^BOOL(NSString *inputEntry) {
//                          LinphoneAccountCreatorStatus s = LinphoneAccountCreatorOK;
//                          if (inputEntry.length > 0) {
//                              s = linphone_account_creator_set_display_name(account_creator, inputEntry.UTF8String);
//                              displayName.errorLabel.text = [AssistantView errorForStatus:s];
//                          }
//                          return s != LinphoneAccountCreatorOK;
//                      }];
//    
//    UIAssistantTextField *smsCode = [self findTextField:ViewElement_SMSCode];
//    [smsCode showError:nil when:^BOOL(NSString *inputEntry) {
//        return inputEntry.length != 4;
//    }];
//    [self shouldEnableNextButton];
//    
//}
//- (UIAssistantTextField *)findTextField:(NSString)tag {
//    return (UIAssistantTextField *)[self findView:tag inView:self.contentView ofType:[UIAssistantTextField class]];
//}
@end
