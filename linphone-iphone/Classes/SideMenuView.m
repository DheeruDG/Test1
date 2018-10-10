//
//  SideMenuViewController.m
//  linphone
//
//  Created by Gautier Pelloux-Prayer on 28/07/15.
//
//

#import "SideMenuView.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"

@implementation SideMenuView

- (void)viewDidLoad {
	[super viewDidLoad];

#pragma deploymate push "ignored-api-availability"
	if (UIDevice.currentDevice.systemVersion.doubleValue >= 7) {
		// it's better to detect only pan from screen edges
		UIScreenEdgePanGestureRecognizer *pan =
			[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onLateralSwipe:)];
		pan.edges = UIRectEdgeRight;
		[self.view addGestureRecognizer:pan];
		_swipeGestureRecognizer.enabled = NO;
	}
#pragma deploymate pop
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_sideMenuTableViewController viewWillAppear:animated];
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(registrationUpdateEvent:)
											   name:kLinphoneRegistrationUpdate
											 object:nil];

	[self updateHeader];
	[_sideMenuTableViewController.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	_grayBackground.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	_grayBackground.hidden = YES;
	// should be better than that with alpha animation..
}

- (void)updateHeader {
	LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    NSString *phoneNumber;
	if (default_proxy != NULL) {
		const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(default_proxy);
		[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr];
		_addressLabel.text = [NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];
        phoneNumber=[NSString stringWithUTF8String:linphone_proxy_config_get_identity(default_proxy)];//_addressLabel.text;//[NSString stringWithFormat:@"%s", as_string];
        [self getnotifyupdate];
		_presenceImage.image = [StatusBarView imageForState:linphone_proxy_config_get_state(default_proxy)];
	} else {
		_nameLabel.text = linphone_core_get_proxy_config_list(LC) ? NSLocalizedString(@"No default account", nil) : NSLocalizedString(@"No account", nil);
		// display direct IP:port address so that we can be reached
		LinphoneAddress *addr = linphone_core_get_primary_contact_parsed(LC);
		if (addr) {
			char *as_string = linphone_address_as_string(addr);
			_addressLabel.text = [NSString stringWithFormat:@"%s", as_string];
            
			ms_free(as_string);
			linphone_address_destroy(addr);
		} else {
			_addressLabel.text = NSLocalizedString(@"No address", nil);
		}
		_presenceImage.image = nil;
	}
    _avatarImage.image = [LinphoneUtils selfAvatar];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:RAZALOGGEDIMAGE];
    UIImage* image = [UIImage imageWithData:imageData];
    _avatarImage.image=image;
    if (!image) {
        if (phoneNumber.length) {
            
            NSString *logged=[[Razauser SharedInstance]getusername:phoneNumber];
            NSURL *urluser=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",RAZA_PROFILE,logged]];
            [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
                if (image)
                {
                    _avatarImage.image =image;
                     [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:RAZALOGGEDIMAGE];
                }
                
                else
                   _avatarImage.image =  [LinphoneUtils selfAvatar];
            }];
        }
        else
            _avatarImage.image = [LinphoneUtils selfAvatar];
    }
    else
         _avatarImage.image =image;
    
}

#pragma deploymate push "ignored-api-availability"
- (void)onLateralSwipe:(UIScreenEdgePanGestureRecognizer *)pan {
	[PhoneMainView.instance.mainViewController hideSideMenu:YES];
}
#pragma deploymate pop

- (IBAction)onHeaderClick:(id)sender {
//[PhoneMainView.instance changeCurrentView:SettingsView.compositeViewDescription];
	//[PhoneMainView.instance.mainViewController hideSideMenu:YES];
}

- (IBAction)onAvatarClick:(id)sender {
	// hide ourself because we are on top of image picker
	if (!IPAD) {
		[PhoneMainView.instance.mainViewController hideSideMenu:YES];
	}
	[ImagePickerView SelectImageFromDevice:self atPosition:_avatarImage inView:self.view];
}

- (IBAction)onBackgroundClicked:(id)sender {
	[PhoneMainView.instance.mainViewController hideSideMenu:YES];
}

- (void)registrationUpdateEvent:(NSNotification *)notif {
	[self updateHeader];
	[_sideMenuTableViewController.tableView reloadData];
}

#pragma mark - Image picker delegate

- (void)imagePickerDelegateImage:(UIImage *)image info:(NSDictionary *)info {
	// When getting image from the camera, it may be 90° rotated due to orientation
	// (image.imageOrientation = UIImageOrientationRight). Just rotate it to be face up.
	if (image.imageOrientation != UIImageOrientationUp) {
		UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
		[image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}

	// Dismiss popover on iPad
	if (IPAD) {
		[VIEW(ImagePickerView).popoverController dismissPopoverAnimated:TRUE];
	} else {
		[PhoneMainView.instance.mainViewController hideSideMenu:NO];
	}

	NSURL *url = [info valueForKey:UIImagePickerControllerReferenceURL];

	// taken from camera, must be saved to device first
	if (!url) {
		[LinphoneManager.instance.photoLibrary
			writeImageToSavedPhotosAlbum:image.CGImage
							 orientation:(ALAssetOrientation)[image imageOrientation]
						 completionBlock:^(NSURL *assetURL, NSError *error) {
						   if (error) {
							   LOGE(@"Cannot save image data downloaded [%@]", [error localizedDescription]);
						   } else {
							   LOGI(@"Image saved to [%@]", [assetURL absoluteString]);
						   }
						   [LinphoneManager.instance lpConfigSetString:assetURL.absoluteString forKey:@"avatar"];
						   _avatarImage.image = [LinphoneUtils selfAvatar];
						 }];
	} else {
		[LinphoneManager.instance lpConfigSetString:url.absoluteString forKey:@"avatar"];
		_avatarImage.image = [LinphoneUtils selfAvatar];
	}
}
-(void)getnotifyupdate
{
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    int stat=   linphone_proxy_config_get_state(default_proxy);
    switch (stat) {
        case LinphoneRegistrationOk:
            if (!([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) )
            {
                //NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                            //stringForKey:RAZAMADECALLPUSH];
//                    if (savedValue.length&&[savedValue isEqualToString:RAZAMADEVIOPPUSH])
//                        [self makecalldelay];
//                    else if (savedValue.length&&[savedValue isEqualToString:RAZAMADEVIDEOPUSH])
//                        [self makecalldelayvideo];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RAZAMADECALLPUSH];
        }

            break;
    }

}
-(void)makecalldelay
{
    [RAZA_APPDELEGATE disconnectcallaction];
    NSString *address=RAZAPUSHCALLER;//@"*9999";
    if ([address length] > 0) {
        selectedmoderazavideooraodio=nil;
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr andmodeVideoAudio:FALSE];
        if (addr)
            linphone_address_destroy(addr);
    }
    
    
//    NSString *from =@"ererer";// [notification.userInfo objectForKey:@"from_addr"];
//     LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
//     if (room)
//     {
    
//         // NSString *from1 =@"test";
//          NSString *replyText=@"opopo";
//        // linphone_chat_room_create_message(room, [from1 UTF8String]);
//         LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
//        // LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
//        // linphone_chat_room_send_chat_message(room, msg);
////       LinphoneChatMessage *msg=  linphone_chat_room_create_message_2(room, replyText.UTF8String, nil, LinphoneChatMessageStateDelivered , 1, NO, YES);
////         linphone_chat_room_send_chat_message(room, msg);
////         linphone_chat_room_mark_as_read(room);
//    // linphone_chat_room_mark_as_read(room);
//         
//         // [(__bridge LinphoneManager *)linphone_core_get_user_data(LC) onMessageReceived:LC room:room message:msg];
//         
//         NSDictionary *dict = @{
//                                @"room" : [NSValue valueWithPointer:room],
//                                @"from_address" : [NSValue valueWithPointer:linphone_chat_message_get_from_address(msg)],
//                                @"message" : [NSValue valueWithPointer:msg],
//                                @"call-id" : @"44444"
//                                };
//         
//         [NSNotificationCenter.defaultCenter postNotificationName:kLinphoneMessageReceived object:self userInfo:dict];
//         
//     }
    
   

    
}
-(void)makecalldelayvideo
{
    
    [RAZA_APPDELEGATE disconnectcallaction];
    NSString *address=RAZAPUSHCALLER;//@"*9999";
    if ([address length] > 0) {
        selectedmoderazavideooraodio=@"videocall";
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr andmodeVideoAudio:TRUE];
        if (addr)
            linphone_address_destroy(addr);
    }
}
@end
