/* OutgoingCallViewController.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
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

#import "CallOutgoingView.h"
#import "PhoneMainView.h"

@implementation CallOutgoingView
@synthesize delegateforminuts=_delegateforminuts,phoneNumber;
//@synthesize _delegateforminuts=delegateforminuts;
#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                //StatusBarView.class
                                                                 tabBar:nil
                                                               sideMenu:nil//CallSideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:NO
                                                           fragmentWith:nil];
        
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

- (void)viewDidLoad {
    _routesEarpieceButton.enabled = !IPAD;
    [Razauser SharedInstance].ratingUserNameDetailSet=[NSMutableSet set];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.calltypeLbl.text=[Razauser SharedInstance].callModeType;
    
    [RAZA_APPDELEGATE requestCameraPermissionsIfNeeded];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(bluetoothAvailabilityUpdateEvent:)
                                               name:kLinphoneBluetoothAvailabilityUpdate
                                             object:nil];
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (!call) {
        //return;
        //_microButton.hidden=YES;
        // _routesSpeakerButton.hidden=YES;
        if (!phoneNumber.length && ! _Accessnumber.length )
        {
            lockunlock=nil;
            return;
        }
        lockunlock=@"minutscall";
        [self settempratue];
        if (_Accessnumber.length)
        {
            _speakerButton.hidden=YES;
            _microButton.hidden=YES;
            [self performSelector:@selector(removefromminutscall) withObject:self afterDelay:4.0 ];
        }
        else
        {
            _speakerButton.hidden=NO;
            _microButton.hidden=NO;
        }
    }
    
    
    const LinphoneAddress *addr ;//
    if (call)
    {
        [contactarray setObject:@"OUTGOING" forKey:@"MODE"];
        _speakerButton.hidden=NO;
        _microButton.hidden=NO;
        addr= linphone_call_get_remote_address(call);
    }
    else
    {
        addr = [LinphoneUtils normalizeSipOrPhoneAddress:phoneNumber];
        
    }
    
    //if (call) {
    
    
    //const LinphoneAddress *addr = linphone_call_get_remote_address(call);
    //[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr];
    if (addr) {
        
        
        [ContactDisplay setDisplayNameLabelRaza:_nameLabel forAddress:addr];
        if (_nameLabel.text.length) {
            [contactarray setObject:_nameLabel.text forKey:@"MODENAME"];
            // [[Razauser SharedInstance].ratingUserNameDetailSet addObject:_nameLabel.text];
            
        }
        char *uri = linphone_address_as_string_uri_only(addr);
        phoneNumber=  [NSString stringWithUTF8String:uri];
        
        phoneNumber=[[Razauser SharedInstance]getusername:phoneNumber];
        
        if (phoneNumber.length) {
            [contactarray setObject:phoneNumber forKey:@"MODEPHONE"];
            
        }
        if ([phoneNumber isEqualToString:RAZAPUSHCALLER])
            _nameLabel.text=[RAZA_APPDELEGATE pushcallingraza:pushcall];// pushcall;
        //-(NSString *)pushcallingraza:(NSString*)callednumbervia;
        // [RAZA_APPDELEGATE pushcallingraza:pushcall];
        _addressLabel.text = [NSString stringWithUTF8String:uri];
        
        
        
        
        ms_free(uri);
    }
    
    NSArray *razauser=[[Razauser SharedInstance]getRazauser];
    if ([razauser containsObject:phoneNumber])
        [[Razauser SharedInstance] setRazaimageforimage:_avatarImage andstringname:phoneNumber andthumbornot:RAZA_PROFILE];
    else
        [_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
    
    if (_avatarImage.image) {
        UIImage *img=_avatarImage.image;
        [contactarray setObject:img forKey:@"MODEIMG"];
    }
    //[_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
    
    //[self hideSpeaker:LinphoneManager.instance.bluetoothAvailable];
    
    if (call) {
        [_speakerButton update];
        [_microButton update];
        [_routesButton update];
        _tmpmode.hidden=YES;
        [self settempratue];
    }
    
    NSDictionary *callDetailsDic=[[NSDictionary alloc]init];
    callDetailsDic=[contactarray mutableCopy];
    if ([[Razauser SharedInstance].ratingDetailDic count]==0) {
        [Razauser SharedInstance].ratingDetailDic=callDetailsDic;
        
        //ratingUserNameDetailArr
    }
    //  }
}



/*-----next phase-----*/


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [RAZA_APPDELEGATE requestCameraPermissionsIfNeeded];
//    [NSNotificationCenter.defaultCenter addObserver:self
//                                           selector:@selector(bluetoothAvailabilityUpdateEvent:)
//                                               name:kLinphoneBluetoothAvailabilityUpdate
//                                             object:nil];
//
//    LinphoneCall *call = linphone_core_get_current_call(LC);
//    if (!call) {
//        //return;
//        //_microButton.hidden=YES;
//        // _routesSpeakerButton.hidden=YES;
//
//        if (phoneNumber.length) {
//            lockunlock=@"minutscall";
//            [self setupcallvalue:call];
//        }
//
//        // [self settempratue];
//    }
//
//
//
//    if (call) {
//        [self setupcallvalue:call];
//
//    }
//}
//-(void)setupcallvalue:(LinphoneCall *)call
//{
//    const LinphoneAddress *addr ;//
//    if (call)
//        addr= linphone_call_get_remote_address(call);
//    else
//    {
//        addr = [LinphoneUtils normalizeSipOrPhoneAddress:phoneNumber];
//
//    }
//    //[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr];
//    [ContactDisplay setDisplayNameLabelRaza:_nameLabel forAddress:addr];
//    char *uri = linphone_address_as_string_uri_only(addr);
//    phoneNumber=  [NSString stringWithUTF8String:uri];
//    phoneNumber=[[Razauser SharedInstance]getusername:phoneNumber];
//
//    if ([phoneNumber isEqualToString:RAZAPUSHCALLER])
//        _nameLabel.text=[RAZA_APPDELEGATE pushcallingraza:pushcall];// pushcall;
//    //-(NSString *)pushcallingraza:(NSString*)callednumbervia;
//    // [RAZA_APPDELEGATE pushcallingraza:pushcall];
//    _addressLabel.text = [NSString stringWithUTF8String:uri];
//
//
//
//
//    ms_free(uri);
//
//    NSArray *razauser=[[Razauser SharedInstance]getRazauser];
//    if ([razauser containsObject:phoneNumber])
//        [[Razauser SharedInstance] setRazaimageforimage:_avatarImage andstringname:phoneNumber andthumbornot:RAZA_PROFILE];
//    else
//        [_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
//
//    //[_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
//
//    //[self hideSpeaker:LinphoneManager.instance.bluetoothAvailable];
//    if (call)
//    {
//        [_speakerButton update];
//        [_microButton update];
//        [_routesButton update];
//    }
//    _tmpmode.hidden=YES;
//    [self settempratue];
//}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // if there is no call (for whatever reason), we must wait viewDidAppear method
    // before popping current view, because UICompositeView cannot handle view change
    // directly in viewWillAppear (this would lead to crash in deallocated memory - easily
    // reproductible on iPad mini).
    
    if (!linphone_core_get_current_call(LC)) {
        if (!phoneNumber.length && ! _Accessnumber.length )
        {
            lockunlock=nil;
            [PhoneMainView.instance popCurrentView];
        }
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    lockunlock=nil;
    [progresshvalidate invalidate];
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (IBAction)onRoutesBluetoothClick:(id)sender {
    [self hideRoutes:TRUE animated:TRUE];
    [LinphoneManager.instance setBluetoothEnabled:TRUE];
}

- (IBAction)onRoutesEarpieceClick:(id)sender {
    [self hideRoutes:TRUE animated:TRUE];
    [LinphoneManager.instance setSpeakerEnabled:FALSE];
    [LinphoneManager.instance setBluetoothEnabled:FALSE];
}

- (IBAction)onRoutesSpeakerClick:(id)sender {
    [self hideRoutes:TRUE animated:TRUE];
    [LinphoneManager.instance setSpeakerEnabled:TRUE];
}

- (IBAction)onRoutesClick:(id)sender {
    if ([_routesView isHidden]) {
        [self hideRoutes:FALSE animated:ANIMATED];
    } else {
        [self hideRoutes:TRUE animated:ANIMATED];
    }
}

- (IBAction)onDeclineClick:(id)sender {
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (call) {
        linphone_core_terminate_call(LC, call);
    }
    
    if([[self delegateforminuts] respondsToSelector:@selector(MinutscallwithDelegateMethod:)])
    {
        lockunlock=nil;
        [PhoneMainView.instance popCurrentView];
        _Accessnumber=nil;
        [[self delegateforminuts] MinutscallwithDelegateMethod:_Accessnumber];
        
        
    }
}

- (void)hideRoutes:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [_routesButton setOff];
    } else {
        [_routesButton setOn];
    }
    
    _routesBluetoothButton.selected = LinphoneManager.instance.bluetoothEnabled;
    _routesSpeakerButton.selected = LinphoneManager.instance.speakerEnabled;
    _routesEarpieceButton.selected = !_routesBluetoothButton.selected && !_routesSpeakerButton.selected;
    
    if (hidden != _routesView.hidden) {
        [_routesView setHidden:hidden];
    }
}

- (void)hideSpeaker:(BOOL)hidden {
    _speakerButton.hidden = hidden;
    _routesButton.hidden = !hidden;
}

#pragma mark - Event Functions

- (void)bluetoothAvailabilityUpdateEvent:(NSNotification *)notif {
    bool available = [[notif.userInfo objectForKey:@"available"] intValue];
    [self hideSpeaker:available];
}
-(void)settempratue
{
    if (phoneNumber.length>10) {
        if ([Razauser SharedInstance].tempdict.allKeys.count) {
            [Razauser SharedInstance].isLocation=YES;
            _tmpview.hidden=NO;
            _tmpmode.hidden=NO;
            _tmplocation.hidden=NO;
            _weatherLbl.hidden=YES;
        }
        else
        {
            [Razauser SharedInstance].isLocation=NO;
            _weatherLbl.hidden=YES;
            _tmpview.hidden=YES;
            _tmpmode.hidden=YES;
            _tmplocation.hidden=YES;
        }
        self.tmpview.layer.cornerRadius = 20;//self.tmpview.frame.size.width / 4;
        self.tmpview.clipsToBounds = YES;
        counterprogress=0;
        progresshvalidate= [NSTimer scheduledTimerWithTimeInterval:1.3
                                                            target:self
                                                          selector:@selector(updatecallProgress)
                                                          userInfo:nil
                                                           repeats:YES];
        // NSString *modecall;
        _tmpmode.image=[UIImage imageNamed:[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPIMAGE"]];
        if (lockunlock.length&&[[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] length]) {
            NSString *modecall1=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"];
            if ([modecall1 containsString:@"| "]) {
                NSArray *arr=[[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] componentsSeparatedByString:@"| "];
                if (arr.count==2) {
                    // modecall=[NSString stringWithFormat:@"%@ | %@",[arr objectAtIndex:0],@"Minutes"];
                    _tmplocation.text=[arr objectAtIndex:0];
                }
            }
        }
        else{
            // modecall=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"];
            if ([[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] length]) {
                NSString *modecall1=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"];
                if ([modecall1 containsString:@"| "]) {
                    NSArray *arr=[[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] componentsSeparatedByString:@"| "];
                    if (arr.count==2) {
                        _tmplocation.text=[arr objectAtIndex:0];
                    }
                }
            }
        }
        
        //  _nameLabel.textColor=[UIColor whiteColor];
        // _tmplocation.textColor=[UIColor whiteColor];
        
        //  _tmplocation.text=modecall;//[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"];
        _tmptmp.text=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMP"];
        _tmptime.text=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPTIME"];
        _weatherLbl.text=[[[Razauser SharedInstance].tempdict  objectForKey:@"weatherTypeName"] capitalizedString];
        
        
        //        if (_tmplocation.text.length>10)
        //            [_tmplocation setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:14]];
        //        else
        //            [_tmplocation setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:14]];
        
        
        NSURL *urluser=[NSURL URLWithString:[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPICON"]];
        [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
            if (image)
            {
                _tmpicon.image =image;
                
            }
            
            else
            {
                _tmpicon.image =  [UIImage imageNamed:@"dweather.png"];
            }
            
        }];
        
        
    }
    else
    {
         [Razauser SharedInstance].isLocation=NO;
        // _nameLabel.textColor=[UIColor blackColor];
        // _tmplocation.textColor=[UIColor blackColor];
        _tmplocation.hidden=YES;
        _tmpview.hidden=YES;
        _tmpmode.hidden=YES;
        _tmplocation.hidden=YES;
        
    }
}
//-(void)settempratue:(NSString*)phones
//{
//    phoneNumber=phones;
//    _tmpicon.hidden=YES;
//    _tmptmp.hidden=YES;
//    _tmplocation.hidden=YES;
//    _tmpview.hidden=YES;
//    _tmpmode.hidden=YES;
//    if (phoneNumber.length>=10) {
//      _modenetwork  =[self net];
//        if (phoneNumber.length==10)
//            phoneNumber=[NSString stringWithFormat:@"1%@",phoneNumber];
//   // phoneNumber= @"17737928150";//@"17732406081";//
//        counterprogress=0;
//       progresshvalidate= [NSTimer scheduledTimerWithTimeInterval:1.3
//                                         target:self
//                                       selector:@selector(updatecallProgress)
//                                       userInfo:nil
//                                        repeats:YES];
//         _tmpmode.hidden=NO;
//        self.tmpview.layer.cornerRadius = 20;//self.tmpview.frame.size.width / 4;
//        self.tmpview.clipsToBounds = YES;
//        RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
//        //NSString *numberKey = [phoneNumber stringByReplacingOccurrencesOfString:@"00"
//                                                                    // withString:@"+"];
//        //c1864e8627657358c7fa4a0557d36d3d 30782cdad57eb61895cff22e45fde12c
//        [baseobj getCallerInfo:phoneNumber andapikey:@"30782cdad57eb61895cff22e45fde12c" callback:^(NSDictionary *result) {
//            NSString *main=[result valueForKey:@"location"];
//            NSString *maincountry=[result valueForKey:@"country_name"];
//            maincountry=
//            [maincountry stringByReplacingOccurrencesOfString:@"(Republic of)" withString:@""];
//           // [maincountry stringByReplacingOccurrencesOfString:@"Republic of" withString:@""];
//            //(Republic of)
//            if (![result objectForKey:@"error"]) {
//                [baseobj getCallerInfofortempdetail:[result valueForKey:@"country_code"] aanstatename:main andapikey:@"a9ee24496f040339dbce7ab60211c0bc" callback:^(NSDictionary *result) {
//                    if (result) {
//                       // NSDictionary *cc=[[NSDictionary alloc]init];
//                       // cc=[result valueForKey:@"list"];
//                        NSLog(@"%@--%@",[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"],[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"]);
//
//
//                        RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
//                        [baseobj setlocationmapsidebarselfonly:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"] andlongitude:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"] andapikey:APIKEY callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error, NSString* timestring) {
//                            if (sellerarray) {
//                                _tmpmode.hidden=NO;
//                                _tmpview.hidden=NO;
//                                if (timestring.length) {
//                                    _tmptime.hidden=NO;
//                                    NSArray *array = [timestring componentsSeparatedByString:@" "];
////                                    if (array.count==4)
////                                        timestring=[NSString stringWithFormat:@" %@ %@",[array objectAtIndex:1],[array objectAtIndex:2]];
////
////                                    _tmptime.text=timestring;
////
////                                    RazaTempratureObject *tempobj=[[RazaTempratureObject alloc]init];
////                                  //  [tempobj getDateDayNight:timestring];
////                                    if ([sellerarray.CurrentImage containsString:@"rain"]) {
////                                         _tmpmode.image=[UIImage imageNamed:@"weather-rain.png"];
////                                    }
////                                   else if ([[tempobj getDateDayNight:timestring] containsString:@"NIGHT"])
////                                         _tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
////                                    else
////                                         _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
////
//                                    if (array.count==6) {
//                                        NSString *time=[array objectAtIndex:4];
//                                        NSLog(@"%@",time);
//
//                                        NSString *dateStr = time;
//                                        NSArray *array2 = [dateStr componentsSeparatedByString:@":"];
//                                        dateStr=[NSString stringWithFormat:@"%@.%@",[array2 objectAtIndex:0],[array2 objectAtIndex:1]];
////                                        // Convert string to date object
////                                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
////                                      //  [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
////                                        [dateFormat setDateFormat:@"HH:mm:ss"];
////                                        NSDate *date = [dateFormat dateFromString:dateStr];
////
////
////
////                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////                                        [dateFormatter setDateFormat:@"HH.mm"];
////                                        NSString *strCurrentTime = [dateFormatter stringFromDate:date];
//
//                                        NSLog(@"Check float value: %.2f",[dateStr floatValue]);
//                                        if ([sellerarray.CurrentImage containsString:@"rain"])
//                                        {
//                                                _tmpmode.image=[UIImage imageNamed:@"weather-rain.png"];
//                                        }
//
//                                        else if ([dateStr floatValue] >= 18.00 || [dateStr floatValue]  <= 6.00){
//
//                                            NSLog(@"It's night time");
//                                             _tmpmode.image=[UIImage imageNamed:@"weather-night.png"];
//                                        }else{
//
//                                            NSLog(@"It's day time");
//                                            _tmpmode.image=[UIImage imageNamed:@"weather-day.png"];
//                                        }
//
//                                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//                                        [dateFormatter setDateFormat:@"HH:mm:ss"];
//
//                                        NSDate *date = [dateFormatter dateFromString:time];
//
//                                        [dateFormatter setDateFormat:@"hh:mm a"];
//
//                                        NSString *formattedDate = [dateFormatter stringFromDate:date];
//
//                                        NSLog(@"%@",formattedDate);
//                                        _tmptime.text=formattedDate;
//
//                                    }
//
//                                }
//                                else
//                                    _tmptime.hidden=YES;
//                                _tmpicon.hidden=NO;
//                                _tmptmp.hidden=NO;
//                                _tmplocation.hidden=NO;
//                                //[_tmpicon sd_setImageWithURL:[NSURL URLWithString:sellerarray.CurrentImage]placeholderImage:[UIImage imageNamed:@"dweather.png"] options:SDWebImageContinueInBackground];
//
//
//                                NSURL *urluser=[NSURL URLWithString:sellerarray.CurrentImage];
//                                [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
//                                    if (image)
//                                    {
//                                        _tmpicon.image =image;
//
//                                    }
//
//                                    else
//                                        _tmpicon.image =  [UIImage imageNamed:@"dweather.png"];
//                                }];
//
//
//                                //if (main.length)
//                                   //_tmplocation.text=[NSString stringWithFormat:@"%@|%@",main,maincountry];//sellerarray.currentName
//                                    //_tmplocation.text=[NSString stringWithFormat:@"%@,%@",sellerarray.currentName,maincountry];
////                                else if (main.length)
////                                //_tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,sellerarray.currentName];
////                                _tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,maincountry];
//                                //else
//                                    _tmplocation.text=[NSString stringWithFormat:@"%@| %@",maincountry,_modenetwork];//sellerarray.currentName;_modenetwork
//
//                                if (_tmplocation.text.length>10)
//                                    [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:14]];
//
//                                else
//                                    [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:25]];
//                                if ([[[NSUserDefaults standardUserDefaults]
//                                      stringForKey:Razatempraturemode] length])
//                                    _tmptmp.text=[NSString stringWithFormat:@"%d˚F",[sellerarray.currentTempraturefahrenheit intValue]];
//                                else
//                                    _tmptmp.text=[NSString stringWithFormat:@"%d˚C",[sellerarray.currentTemprature intValue]];
//
//
//
//                                //[self settitleview:@"Australia (2222)"];
//                            }
//
//                        }];
//
//                    }
//                    else{
//                        if (main||maincountry) {
//                             _tmplocation.hidden=NO;
//
//                        if (main.length)
//                            //_tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,sellerarray.currentName];
//                            _tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,maincountry];
//                        else
//                            _tmplocation.text=maincountry;//sellerarray.currentName;
//
//                        if (_tmplocation.text.length>10)
//                            [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:14]];
//
//                        else
//                            [_tmplocation setFont:[UIFont fontWithName:@"Poppins-Regular" size:25]];
//                    }
//                        }
//
//                }];
//
//            }
//        }];
//    }
////    else
////    {
////        _tmpicon.hidden=NO;
////        _tmptmp.hidden=NO;
////        _tmplocation.hidden=NO;
////        [self showselftemp];
////    }
//
//}

-(void)gettemp:(NSString*)countryname andcity:(NSString*)cityname
{
    RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
    [baseobj setlocationmapsidebar:countryname andlongitude:cityname andapikey:APIKEY callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error) {
        
        if (baseview) {
            
            
            //  [_tmpicon sd_setImageWithURL:[NSURL URLWithString:sellerarray.CurrentImage]placeholderImage:[UIImage imageNamed:@"dweather.png"] options:SDWebImageContinueInBackground];
            [[Razauser SharedInstance] downloadImageWithURL:[NSURL URLWithString:sellerarray.CurrentImage] completionBlock:^(BOOL succeeded, UIImage *image) {
                _tmpicon.image=image;
            }];
            _tmplocation.text=sellerarray.currentName;
            if ([[[NSUserDefaults standardUserDefaults]
                  stringForKey:Razatempraturemode] length])
                _tmptmp.text=[NSString stringWithFormat:@"%d˚",[sellerarray.currentTempraturefahrenheit intValue]];
            else
                _tmptmp.text=[NSString stringWithFormat:@"%d˚",[sellerarray.currentTemprature intValue]];
            
            
            //[self settitleview:@"Australia (2222)"];
        }
    }];
}
-(void)showselftemp
{
    RazaTempratureObject *baseobject=[[RazaTempratureObject alloc]init];
    RazaTempratureObject *baseobject2=[baseobject Tempobjectself];
    [[Razauser SharedInstance] downloadImageWithURL:[NSURL URLWithString:baseobject2.CurrentImage] completionBlock:^(BOOL succeeded, UIImage *image) {
        _tmpicon.image=image;
    }];
    //   [_tmpicon sd_setImageWithURL:[NSURL URLWithString:baseobject2.CurrentImage]placeholderImage:[UIImage imageNamed:@"dweather.png"] options:SDWebImageContinueInBackground];
    
    _tmplocation.text=baseobject2.currentName;
    if ([[[NSUserDefaults standardUserDefaults]
          stringForKey:Razatempraturemode] length])
        _tmptmp.text=[NSString stringWithFormat:@"%d˚",[baseobject2.currentTempraturefahrenheit intValue]];
    else
        _tmptmp.text=[NSString stringWithFormat:@"%d˚",[baseobject2.currentTemprature intValue]];
}

-(NSArray *)countryarray
{
    NSString *numberKey = [phoneNumber stringByReplacingOccurrencesOfString:@"00"
                                                                 withString:@"+"];
    NSString *withoutstd;
    if (phoneNumber.length>10) {
        
        NSRange range = NSMakeRange(phoneNumber.length - 10, 10);
        withoutstd = [phoneNumber substringWithRange:range];
        NSLog(@"---->>>>>>>%@",numberKey);
        
    }
    NSString* s1 = phoneNumber;
    NSString* s2 = withoutstd;
    
    NSString * final = [[s1 componentsSeparatedByString:s2] componentsJoinedByString:@""];
    NSString *mm= [final stringByReplacingOccurrencesOfString:@"00"
                                                   withString:@"+"];
    NSLog(@"Final: %@,%@", final,razaglobalcountryarray);
    NSArray *filtered = [razaglobalcountryarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code == %@)", mm]];
    return filtered;
}
-(void)updatecallProgress
{
    counterprogress=counterprogress+.25;
    [self.tmpprogress setProgress:counterprogress];
}

-(void)removefromminutscall
{
    if([[self delegateforminuts] respondsToSelector:@selector(MinutscallwithDelegateMethod:)])
    {
        lockunlock=nil;
        [PhoneMainView.instance popCurrentView];
        [[self delegateforminuts] MinutscallwithDelegateMethod:_Accessnumber];
    }
}
@end
