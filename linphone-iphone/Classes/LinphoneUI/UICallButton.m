/* UICallButton.m
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
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

#import "UICallButton.h"
#import "LinphoneManager.h"

#import <CoreTelephony/CTCallCenter.h>

@implementation UICallButton

@synthesize addressField;

#pragma mark - Lifecycle Functions

- (void)initUICallButton {
	[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)init {
	self = [super init];
	if (self) {
		[self initUICallButton];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initUICallButton];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		[self initUICallButton];
	}
	return self;
}

#pragma mark -

- (void)touchUp:(id)sender {
    [self plistfile];

	NSString *address = addressField.text;
	if (address.length == 0) {
		LinphoneCallLog *log = linphone_core_get_last_outgoing_call_log(LC);
		if (log) {
			LinphoneAddress *to = linphone_call_log_get_to(log);
			const char *domain = linphone_address_get_domain(to);
			char *bis_address = NULL;
			LinphoneProxyConfig *def_proxy = linphone_core_get_default_proxy_config(LC);

			// if the 'to' address is on the default proxy, only present the username
			if (def_proxy) {
				const char *def_domain = linphone_proxy_config_get_domain(def_proxy);
				if (def_domain && domain && !strcmp(domain, def_domain)) {
					bis_address = ms_strdup(linphone_address_get_username(to));
				}
			}
			if (bis_address == NULL) {
				bis_address = linphone_address_as_string_uri_only(to);
			}
            
            
			[addressField setText:[NSString stringWithUTF8String:bis_address]];
            if ([addressField.text isEqualToString:@"*9999"])
                addressField.text=@"";
			ms_free(bis_address);
			// return after filling the address, let the user confirm the call by pressing again
			return;
		}
	}

	if ([address length] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"makeacallvia3param" object:address];
//		LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
//		[LinphoneManager.instance call:addr];
//		if (addr)
//			linphone_address_destroy(addr);
	}
}

- (void)updateIcon:(NSString*)nameoficon {
   // nameoficon=@"callHome";
  //  [self bringSubviewToFront:self.imageView];
	if (linphone_core_video_capture_enabled(LC) && linphone_core_get_video_policy(LC)->automatically_initiate) {
      //self.hidden=NO;
		[self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateNormal];//@"call_wifi"
		[self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateSelected];

	} else {
        //self.hidden=NO;
		[self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:nameoficon] forState:UIControlStateSelected];

	}

//    if (LinphoneManager.instance.nextCallIsTransfer) {
//       // self.hidden=YES;
//        [self setImage:[UIImage imageNamed:@"call_transfer_default.png"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"call_transfer_disabled.png"] forState:UIControlStateDisabled];
//    } else if (linphone_core_get_calls_nb(LC) > 0) {
//        //self.hidden=YES;
//        [self setImage:[UIImage imageNamed:@"call_add_default.png"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"call_add_disabled.png"] forState:UIControlStateDisabled];
//    }
}

-(void)plistfile{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString*pathfornetwork = [documentsDirectory stringByAppendingPathComponent:@"network_keypad.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: pathfornetwork]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"network_keypad" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: pathfornetwork error:&error]; //6
    }
    
    
    NSMutableDictionary *datafornetwork = [[NSMutableDictionary alloc] initWithContentsOfFile: pathfornetwork];
    [datafornetwork objectForKey:@"valueof"];

    for (int index=0; index<3; index++) {
        if ([[[datafornetwork objectForKey:@"valueof"]objectAtIndex:index] isEqualToString:@"1"]) {
            if (index==0 ){
                [Razauser SharedInstance].callModeType=@"WIFI CALL";
                break;
            }else if (index==1){
                [Razauser SharedInstance].callModeType=@"RAZA MINUTES CALL";
                break;
            }else{
                [Razauser SharedInstance].callModeType=@"DATA CALL";
                break;
            }
        }
    }

}

@end
