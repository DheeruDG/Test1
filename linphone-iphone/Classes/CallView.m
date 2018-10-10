/* InCallViewController.h
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

#import <AudioToolbox/AudioToolbox.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import "CallView.h"
#import "CallSideMenuView.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "Utils.h"

#include "linphone/linphonecore.h"

const NSInteger SECURE_BUTTON_TAG = 5;

@implementation CallView {
    BOOL hiddenVolume;
}

#pragma mark - Lifecycle Functions

- (id)init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle mainBundle]];
    if (self != nil) {
        singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls:)];
        videoZoomHandler = [[VideoZoomHandler alloc] init];
        videoHidden = TRUE;
    }
    return self;
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil//StatusBarView.class
                                                                 tabBar:nil
                                                               sideMenu:nil////CallSideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:NO//yes
                                                           fragmentWith:nil];
        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - ViewController Functions
-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    //testvariable=nil;
    [super viewDidLoad];
    
    self.callTypeLbl.text=[Razauser SharedInstance].callModeType;

    _routesEarpieceButton.enabled = !IPAD;
    
    // TODO: fixme! video preview frame is too big compared to openGL preview
    // frame, so until this is fixed, temporary disabled it.
#if 0
    _videoPreview.layer.borderColor = UIColor.whiteColor.CGColor;
    _videoPreview.layer.borderWidth = 1;
#endif
    [singleFingerTap setNumberOfTapsRequired:1];
    [singleFingerTap setCancelsTouchesInView:FALSE];
    [self.videoView addGestureRecognizer:singleFingerTap];
    
    [videoZoomHandler setup:_videoGroup];
    _videoGroup.alpha = 0;
    
    [_videoCameraSwitch setPreview:_videoPreview];
    
    UIPanGestureRecognizer *dragndrop =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveVideoPreview:)];
    dragndrop.minimumNumberOfTouches = 1;
    [_videoPreview addGestureRecognizer:dragndrop];
    
    [_zeroButton setDigit:'0'];
    [_zeroButton setDtmf:true];
    [_oneButton setDigit:'1'];
    [_oneButton setDtmf:true];
    [_twoButton setDigit:'2'];
    [_twoButton setDtmf:true];
    [_threeButton setDigit:'3'];
    [_threeButton setDtmf:true];
    [_fourButton setDigit:'4'];
    [_fourButton setDtmf:true];
    [_fiveButton setDigit:'5'];
    [_fiveButton setDtmf:true];
    [_sixButton setDigit:'6'];
    [_sixButton setDtmf:true];
    [_sevenButton setDigit:'7'];
    [_sevenButton setDtmf:true];
    [_eightButton setDigit:'8'];
    [_eightButton setDtmf:true];
    [_nineButton setDigit:'9'];
    [_nineButton setDtmf:true];
    [_starButton setDigit:'*'];
    [_starButton setDtmf:true];
    [_hashButton setDigit:'#'];
    [_hashButton setDtmf:true];
}

- (void)dealloc {
    [PhoneMainView.instance.view removeGestureRecognizer:singleFingerTap];
    // Remove all observer
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _tmplocation.hidden=YES;
    _tmpview.hidden=YES;
    _tmplocation.hidden=YES;
    
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
    [contactarray setObject:@"OUTGOINGRECIVED" forKey:@"MODECALL"];
    
    
    [RAZA_APPDELEGATE hidedurationcalling];
    LinphoneManager.instance.nextCallIsTransfer = NO;
    
    [self updateUnreadMessage:FALSE];
    
    // Update on show
    [self hideRoutes:TRUE animated:FALSE];
    [self hideOptions:TRUE animated:FALSE];
    [self hidePad:TRUE animated:FALSE];
    [self hideSpeaker:LinphoneManager.instance.bluetoothAvailable];
    [self callDurationUpdate];
    [self onCurrentCallChange];
    // Set windows (warn memory leaks)
    linphone_core_set_native_video_window_id(LC, (__bridge void *)(_videoView));
    linphone_core_set_native_preview_window_id(LC, (__bridge void *)(_videoPreview));
    
    [self previewTouchLift];
    
    // Enable tap
    [singleFingerTap setEnabled:TRUE];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(messageReceived:)
                                               name:kLinphoneMessageReceived
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(bluetoothAvailabilityUpdateEvent:)
                                               name:kLinphoneBluetoothAvailabilityUpdate
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(callUpdateEvent:)
                                               name:kLinphoneCallUpdate
                                             object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(callDurationUpdate)
                                   userInfo:nil
                                    repeats:YES];
    //    [NSNotificationCenter.defaultCenter addObserver:self
    //                                           selector:@selector(callUpdateEventforpause:)
    //                                               name:@"callUpdateEventforpausenotif"
    //                                             object:nil];
    
    
    ll=nil;
    //    variableforremotepause=nil;
    //    if ([Razauser SharedInstance].callmode.length)
    //    variableforremotepause=@"push";
    //
    // [self subscribe];
    
    confranceview=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 44)];
    confranceview.backgroundColor=[UIColor clearColor];
    btnAddConfrance = [UIButton buttonWithType:UIButtonTypeCustom];
    lblConfrance=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 20)];
    lblConfrance.text=@"Conference";
    lblConfrance.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:18];
    lblConfrance.textColor=[UIColor whiteColor];
    [btnAddConfrance addTarget:self
                        action:@selector(addConfrance)
              forControlEvents:UIControlEventTouchUpInside];
    // [btnAddConfrance setTitle:@"Add" forState:UIControlStateNormal];
    [btnAddConfrance setImage:[UIImage imageNamed:@"add_contact"] forState:UIControlStateNormal];
    btnAddConfrance.frame = CGRectMake(SCREENWIDTH-60, 10, 44, 44);
    
    //pause_big_default.png
    
    /*connect---*/
    btnResumeConfrance = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnResumeConfrance addTarget:self
                           action:@selector(connectConfrance)
                 forControlEvents:UIControlEventTouchUpInside];
    // [btnResumeConfrance setTitle:@"Conf" forState:UIControlStateNormal];
    [btnResumeConfrance setImage:[UIImage imageNamed:@"concall"] forState:UIControlStateNormal];
    btnResumeConfrance.frame = CGRectMake(20, 10, 44, 44);
    [confranceview addSubview:btnResumeConfrance];
    [confranceview addSubview:btnAddConfrance];
    [confranceview addSubview:lblConfrance];
    // [lblConfrance setCenter:confranceview.center];
    // lblConfrance.frame=CGRectMake(lblConfrance.frame.origin.x,confranceview.frame.size.height/2 , lblConfrance.frame.size.width, lblConfrance.frame.size.height);
    lblConfrance.center = CGPointMake(CGRectGetMidX(confranceview.bounds), lblConfrance.center.y+10);
    [RAZA_APPDELEGATE.window addSubview:confranceview];
}
-(void)connectConfrance
{
    
    [self hideOptions:TRUE animated:TRUE];
    linphone_core_add_all_to_conference(LC);
}
-(void)addConfrance
{
    NSLog(@"ddd");
    DialerView *view = VIEW(DialerView);
    [view setAddress:@""];
    LinphoneManager.instance.nextCallIsTransfer = NO;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}
-(void)subscribe
{
    
    LinphoneCall *currentCall  =   linphone_core_get_current_call(LC);
    if (currentCall)
        linphone_core_pause_call(LC, currentCall);
    
    //  [self performSelector:@selector(subscribe2) withObject:self afterDelay:0.5 ];
    
    //   [self subscribe2];
    
}
-(void)subscribe2
{
    
    LinphoneCall *currentCall  =  [UIPauseButton getcallrecent]; //linphone_core_get_current_call(LC);
    if (currentCall)
    {
        linphone_core_resume_call(LC, currentCall);
    }
    // [[Razauser SharedInstance]HideWaiting];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    UIDevice.currentDevice.proximityMonitoringEnabled = YES;
    
    [PhoneMainView.instance setVolumeHidden:TRUE];
    hiddenVolume = TRUE;
    
    // we must wait didAppear to reset fullscreen mode because we cannot change it in viewwillappear
    LinphoneCall *call = linphone_core_get_current_call(LC);
    
    /*-------Video---------*/
    //    if(selectedmoderazavideooraodio.length)
    //    {
    //    LinphoneCallAppData *callAppData = (__bridge LinphoneCallAppData *)linphone_call_get_user_pointer(call);
    //    callAppData->videoRequested =
    //    TRUE;
    //    LinphoneCallParams *call_params = linphone_core_create_call_params(LC,call);
    //    linphone_call_params_enable_video(call_params, TRUE);
    //    linphone_core_update_call(LC, call, call_params);
    //    linphone_call_params_destroy(call_params);
    //    }
    /*--------end0----------*/
    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
    [self callUpdate:call state:state animated:FALSE];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
    //testvariable=nil;
    // variableforremotepause=nil;
    
    [Razauser SharedInstance].callmodeofstatus=nil;
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeitstatusnoti" object:self];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"callUpdateEventforpausenotif"
    //                                                  object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"changeitstatusnoti"
    //                                                  object:nil];
    
    [self disableVideoDisplay:TRUE animated:NO];
    
    if (hideControlsTimer != nil) {
        [hideControlsTimer invalidate];
        hideControlsTimer = nil;
    }
    
    if (hiddenVolume) {
        [PhoneMainView.instance setVolumeHidden:FALSE];
        hiddenVolume = FALSE;
    }
    
    if (videoDismissTimer) {
        [self dismissVideoActionSheet:videoDismissTimer];
        [videoDismissTimer invalidate];
        videoDismissTimer = nil;
    }
    BOOL mic= linphone_core_mic_enabled(LC);
    if (mic==NO) {
        linphone_core_enable_mic(LC, false);
    }
    [RAZA_APPDELEGATE showdurationcalling];
    [confranceview removeFromSuperview];
    
    // Remove observer
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:false];
    UIDevice.currentDevice.proximityMonitoringEnabled = NO;
    
    [PhoneMainView.instance fullScreen:false];
    // Disable tap
    [singleFingerTap setEnabled:FALSE];
    
    if (linphone_core_get_calls_nb(LC) == 0) {
        // reseting speaker button because no more call
        _speakerButton.selected = FALSE;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateUnreadMessage:NO];
    [self previewTouchLift];
    [self hideStatusBar:!videoHidden && (_nameLabel.alpha <= 0.f)];
}

#pragma mark - UI modification

- (void)hideSpinnerIndicator:(LinphoneCall *)call {
    _videoWaitingForFirstImage.hidden = TRUE;
}

static void hideSpinner(LinphoneCall *call, void *user_data) {
    CallView *thiz = (__bridge CallView *)user_data;
    [thiz hideSpinnerIndicator:call];
}

- (void)updateBottomBar:(LinphoneCall *)call state:(LinphoneCallState)state {
    [_speakerButton update];
    [_microButton update];
    [_callPauseButton update];
    [_conferencePauseButton update];
    [_videoButton update];
    [_hangupButton update];
    
    BOOL mic= linphone_core_mic_enabled(LC);
    if (mic==NO) {
        linphone_core_enable_mic(LC, false);
    }
    _optionsButton.enabled = (!call || !linphone_core_sound_resources_locked(LC));
    _optionsTransferButton.enabled = call && !linphone_core_sound_resources_locked(LC);
    // enable conference button if 2 calls are presents and at least one is not in the conference
    int confSize = linphone_core_get_conference_size(LC) - (linphone_core_is_in_conference(LC) ? 1 : 0);
    _optionsConferenceButton.enabled =
    ((linphone_core_get_calls_nb(LC) > 1) && (linphone_core_get_calls_nb(LC) != confSize));
    bool checkconfrance=((linphone_core_get_calls_nb(LC) > 1) && (linphone_core_get_calls_nb(LC) != confSize));
    if (checkconfrance)
        btnResumeConfrance.hidden=NO;
    else
        btnResumeConfrance.hidden=YES;
    
    bool confstatus=!linphone_core_is_in_conference(LC);
    if (confstatus)
        lblConfrance.hidden=YES;
    else
        lblConfrance.hidden=NO;
    // Disable transfert in conference
    if (linphone_core_get_current_call(LC) == NULL) {
        [_optionsTransferButton setEnabled:FALSE];
    } else {
        [_optionsTransferButton setEnabled:TRUE];
    }
    
    switch (state) {
        case LinphoneCallEnd:
        case LinphoneCallError:
        case LinphoneCallIncoming:
        case LinphoneCallOutgoing:
            [self hidePad:TRUE animated:TRUE];
            [self hideOptions:TRUE animated:TRUE];
            [self hideRoutes:TRUE animated:TRUE];
        default:
            break;
    }
}

- (void)toggleControls:(id)sender {
    bool controlsHidden = (_bottomBar.alpha == 0.0);
    [self hideControls:!controlsHidden sender:sender];
}

- (void)timerHideControls:(id)sender {
    [self hideControls:TRUE sender:sender];
}

- (void)hideControls:(BOOL)hidden sender:(id)sender {
    
    if (videoHidden && hidden)
        return;
    
    if (hideControlsTimer) {
        [hideControlsTimer invalidate];
        hideControlsTimer = nil;
    }
    
    if ([[PhoneMainView.instance currentView] equal:CallView.compositeViewDescription]) {
        // show controls
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        _pausedCallsTable.tableView.alpha = _videoCameraSwitch.alpha = _callPauseButton.alpha = _routesView.alpha =
        _optionsView.alpha = _numPadBGView.alpha = _bottomBar.alpha = (hidden ? 0 : 1);
        _nameLblKeyBorad.alpha=_durationLblKeyboard.alpha =_nameLabel.alpha = _durationLabel.alpha=_videoDurationLbl.alpha=_videoNameLbl.alpha = (hidden ? 0 : .8f);
        
        [self hideStatusBar:hidden];
        
        [UIView commitAnimations];
        
        [PhoneMainView.instance hideTabBar:hidden];
        
        if (!hidden) {
            // hide controls in 5 sec
            hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                 target:self
                                                               selector:@selector(timerHideControls:)
                                                               userInfo:nil
                                                                repeats:NO];
        }
    }
}

- (void)disableVideoDisplay:(BOOL)disabled animated:(BOOL)animation {
    if (disabled == videoHidden && animation)
        return;
    videoHidden = disabled;
    
    if (!disabled) {
        [videoZoomHandler resetZoom];
    }
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
    }
    
    [_videoGroup setAlpha:disabled ? 0 : 1];
    
    [self hideControls:!disabled sender:nil];
    
    if (animation) {
        [UIView commitAnimations];
    }
    
    // only show camera switch button if we have more than 1 camera
    _videoCameraSwitch.hidden = (disabled || !LinphoneManager.instance.frontCamId);
    _videoPreview.hidden = (disabled || !linphone_core_self_view_enabled(LC));
    
    if (hideControlsTimer != nil) {
        [hideControlsTimer invalidate];
        hideControlsTimer = nil;
    }
    
    //[PhoneMainView.instance fullScreen:!disabled];
    [PhoneMainView.instance fullScreen:YES];
    [PhoneMainView.instance hideTabBar:!disabled];
    
    if (!disabled) {
#ifdef TEST_VIDEO_VIEW_CHANGE
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(_debugChangeVideoView)
                                       userInfo:nil
                                        repeats:YES];
#endif
        // [self batteryLevelChanged:nil];
        
        [_videoWaitingForFirstImage setHidden:NO];
        [_videoWaitingForFirstImage startAnimating];
        
        LinphoneCall *call = linphone_core_get_current_call(LC);
        // linphone_call_params_get_used_video_codec return 0 if no video stream enabled
        if (call != NULL && linphone_call_params_get_used_video_codec(linphone_call_get_current_params(call))) {
            linphone_call_set_next_video_frame_decoded_callback(call, hideSpinner, (__bridge void *)(self));
        }
    }
}

- (void)displayVideoCall:(BOOL)animated {
    [self disableVideoDisplay:FALSE animated:animated];
}

- (void)displayAudioCall:(BOOL)animated {
    [self disableVideoDisplay:TRUE animated:animated];
}

- (void)hideStatusBar:(BOOL)hide {
    /* we cannot use [PhoneMainView.instance show]; because it will automatically
     resize current view to fill empty space, which will resize video. This is
     indesirable since we do not want to crop/rescale video view */
    
    PhoneMainView.instance.mainViewController.statusBarView.hidden = hide;
    
}

- (void)callDurationUpdate {
    //    if (LC!=NULL) {
    //        int duration =
    //        linphone_core_get_current_call(LC) ? linphone_call_get_duration(linphone_core_get_current_call(LC)) : 0;
    //        _durationLabel.text = [LinphoneUtils durationToString:duration];
    //
    //    }
    //    if (testvariable.length||[Razauser SharedInstance].callmode.length) {
    //        _noActiveCallView.hidden=YES;
    //        _conferenceCallsTable.tableView.hidden=YES;
    //    }
    //    else
    //    {
    //	[_pausedCallsTable update];
    //	[_conferenceCallsTable update];
    //    }
    
    if (LC!=NULL) {
        int duration =
        linphone_core_get_current_call(LC) ? linphone_call_get_duration(linphone_core_get_current_call(LC)) : 0;
        _videoDurationLbl.text=_durationLabel.text=_durationLblKeyboard.text = [LinphoneUtils durationToString:duration];
        
    }
    
    [_pausedCallsTable update];
    [_conferenceCallsTable update];
}

- (void)onCurrentCallChange {
    LinphoneCall *call = linphone_core_get_current_call(LC);
    
    _noActiveCallView.hidden = (call || linphone_core_is_in_conference(LC));
    _callView.hidden = !call;
    _conferenceView.hidden = !linphone_core_is_in_conference(LC);
    if (_conferenceView.hidden)
        lblConfrance.hidden=YES;
    else
        lblConfrance.hidden=NO;
    _callPauseButton.hidden = !call && !linphone_core_is_in_conference(LC);
    
    [_callPauseButton setType:UIPauseButtonType_CurrentCall call:call];
    [_conferencePauseButton setType:UIPauseButtonType_Conference call:call];
    
    if (!_callView.hidden) {
        const LinphoneAddress *addr = linphone_call_get_remote_address(call);
        //[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr];
        [ContactDisplay setDisplayNameLabelRaza:_nameLabel forAddress:addr];
        [ContactDisplay setDisplayNameLabelRaza:_nameLblKeyBorad forAddress:addr];
        [ContactDisplay setDisplayNameLabelRaza:_videoNameLbl forAddress:addr];
        [[Razauser SharedInstance].ratingUserNameDetailSet addObject:_nameLabel.text];
        
        //        [addressBookMap removeAllObjects];
        //        addressBookMap=[[OrderedDictionary alloc]init];
        //
        //        NSMutableArray *subAr = [addressBookMap objectForKey:[addressBookMap keyAtIndex:0]];
        //        Contact *contact = subAr[0];
        //
        //        [ContactDisplay setDisplayNameLabel:_nameLabel forContact:contact];
        
        char *uri = linphone_address_as_string_uri_only(addr);
        phoneNumber=  [NSString stringWithUTF8String:uri];
        phoneNumber=[[Razauser SharedInstance]getusername:phoneNumber];
        if ([phoneNumber isEqualToString:RAZAPUSHCALLER])
        {
            NSString *ss=[RAZA_APPDELEGATE pushcallingraza:pushcall];
            if (ss.length)
                _nameLabel.text=_nameLblKeyBorad.text=_videoNameLbl.text=ss;
            else
                _nameLabel.text=_nameLblKeyBorad.text=_videoNameLbl.text=pushcall;
            // _nameLabel.text= [RAZA_APPDELEGATE pushcallingraza:pushcall];//pushcall;
            [[Razauser SharedInstance].ratingUserNameDetailSet addObject:_nameLabel.text];
        }
        
        //  [self settempratue];
        ms_free(uri);
        
        NSArray *razauser=[[Razauser SharedInstance]getRazauser];
        if ([razauser containsObject:phoneNumber]){
            [[Razauser SharedInstance] setRazaimageforimage:_avatarImage andstringname:phoneNumber andthumbornot:RAZA_PROFILE];
            
        }
        else{
            [_avatarImage setImage:[FastAddressBook imageForAddress:addr thumbnail:NO] bordered:YES withRoundedRadius:YES];
            self.chatBtn.hidden=YES;
            self.chatNotificationView.hidden=YES;
            
            _microButton.frame=CGRectMake(_microButton.frame.size.width/2.0, _microButton.frame.origin.y, _microButton.frame.size.width, _microButton.frame.size.height);
        _speakerButton.frame=CGRectMake(_microButton.frame.size.width+_speakerButton.frame.size.width/2.0, _speakerButton.frame.origin.y, _speakerButton.frame.size.width, _speakerButton.frame.size.height);
            
            _numpadButton.frame=CGRectMake(_numpadButton.frame.size.width/2.0+_microButton.frame.size.width+_speakerButton.frame.size.width, _numpadButton.frame.origin.y, _numpadButton.frame.size.width, _numpadButton.frame.size.height);
        }
    }
    
    
    
}

- (void)hidePad:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [_numpadButton setOff];
    } else {
        [_numpadButton setOn];
    }
    if (hidden != _numPadBGView.hidden) {
        if (animated) {
            [self hideAnimation:hidden forView:_numPadBGView completion:nil];
        } else {
            [_numPadBGView setHidden:hidden];
        }
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
        if (animated) {
            [self hideAnimation:hidden forView:_routesView completion:nil];
        } else {
            [_routesView setHidden:hidden];
        }
    }
}

- (void)hideOptions:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [_optionsButton setOff];
    } else {
        [_optionsButton setOn];
    }
    if (hidden != _optionsView.hidden) {
        if (animated) {
            [self hideAnimation:hidden forView:_optionsView completion:nil];
        } else {
            [_optionsView setHidden:hidden];
        }
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

- (void)callUpdateEvent:(NSNotification *)notif {
    if ([[notif.userInfo objectForKey:@"message"] isEqualToString:@"Streams running"]) {
        self.callTypeLbl.text=[Razauser SharedInstance].callModeType;
    }else{
        self.callTypeLbl.text=@"";

    }
    LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    [self callUpdate:call state:state animated:TRUE];
    [self setTemparatureView];
}
- (void)callUpdateEventforpause:(NSNotification *)notif
{
    //    LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    //    LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    //    [self callUpdateforpause:call state:state animated:TRUE];
}
- (void)callUpdateforpause:(LinphoneCall *)call state:(LinphoneCallState)state animated:(BOOL)animated
{
    
    //LinphoneCallPausedByRemote:
    if (state==LinphoneCallPausedByRemote) {
        
        [Razauser SharedInstance].pausecounter=[Razauser SharedInstance].pausecounter+1;
        // if ([Razauser SharedInstance].pausecounter!=1) {
        //  [self displayAudioCall:animated];
        if (call == linphone_core_get_current_call(LC)) {
            if (variableforremotepause.length) {
                [self displayAudioCall:animated];
                _pausedByRemoteView.hidden = NO;
                _imgremotepause.hidden=NO;
                _lblremotepaused.text=@"You are paused by remote";
            }
            else
            {
                if ([Razauser SharedInstance].pausecounter<=1)
                {
                    
                    _pausedByRemoteView.hidden = YES;
                    _imgremotepause.hidden=YES;
                    _lblremotepaused.text=RAZAPUSHVIDEOCALLMESSAGE;
                }
                else
                {
                    [self displayAudioCall:animated];
                    _pausedByRemoteView.hidden = NO;
                    _imgremotepause.hidden=NO;
                    _lblremotepaused.text=@"You are paused by remote";
                }
            }
        }
    }
    
}
- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state animated:(BOOL)animated {
    [self updateBottomBar:call state:state];
    if (hiddenVolume) {
        [PhoneMainView.instance setVolumeHidden:FALSE];
        hiddenVolume = FALSE;
    }
    
    // Update tables
    [_pausedCallsTable update];
    [_conferenceCallsTable update];
    
    static LinphoneCall *currentCall = NULL;
    if (!currentCall || linphone_core_get_current_call(LC) != currentCall) {
        currentCall = linphone_core_get_current_call(LC);
        [self onCurrentCallChange];
    }
    
    // Fake call update
    if (call == NULL) {
        return;
    }
    
    BOOL shouldDisableVideo =
    (!currentCall || !linphone_call_params_video_enabled(linphone_call_get_current_params(currentCall)));
    if (videoHidden != shouldDisableVideo) {//Video
        if (!shouldDisableVideo) {
            self.bottomBar.backgroundColor=[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.2f];
            [self displayVideoCall:animated];
        } else {
            self.bottomBar.backgroundColor=[UIColor clearColor];
            [self displayAudioCall:animated];
        }
    }
    
    if (state != LinphoneCallPausedByRemote) {
        _pausedByRemoteView.hidden = YES;
    }
    
    switch (state) {
        case LinphoneCallIncomingReceived:
        case LinphoneCallOutgoingInit:
        case LinphoneCallConnected:
        case LinphoneCallStreamsRunning: {
            // check video
            if (!linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {//Audio
                self.bottomBar.backgroundColor=[UIColor clearColor];
                const LinphoneCallParams *param = linphone_call_get_current_params(call);
                const LinphoneCallAppData *callAppData =
                (__bridge const LinphoneCallAppData *)(linphone_call_get_user_pointer(call));
                if (state == LinphoneCallStreamsRunning && callAppData->videoRequested &&
                    linphone_call_params_low_bandwidth_enabled(param)) {
                    // too bad video was not enabled because low bandwidth
                    UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Low bandwidth", nil)
                                                                                     message:NSLocalizedString(@"Video cannot be activated because of low bandwidth "
                                                                                                               @"condition, only audio is available",
                                                                                                               nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [errView addAction:defaultAction];
                    [self presentViewController:errView animated:YES completion:nil];
                    callAppData->videoRequested = FALSE; /*reset field*/
                }
            }
            
            if (linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {
                //  NSLog(@"");
                confranceview.frame=CGRectMake(0,0, SCREENWIDTH, 44);
                if (![self isHeadsetPluggedIn]) {
                    UInt32  override = kAudioSessionOverrideAudioRoute_Speaker;
                    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(override), &override);
                    
                }
                
            }
            else
            {
                confranceview.frame=CGRectMake(0,20, SCREENWIDTH, 44);
                if (![self isHeadsetPluggedIn]) {
                    if (razaimchatting.length)
                    {
                        UInt32  override = kAudioSessionOverrideAudioRoute_Speaker;
                        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(override), &override);
                    }
                }
                
            }
            //            CFStringRef newRoute = CFSTR("Unknown");
            //            UInt32 newRouteSize = sizeof(newRoute);
            //
            //            OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &newRouteSize, &newRoute);
            //            if (!status && newRouteSize > 0) {
            //                NSString *route = (__bridge NSString *)newRoute;
            //                NSLog(@"%@",route);
            //            }
            
            break;
        }
        case LinphoneCallUpdatedByRemote: {
            const LinphoneCallParams *current = linphone_call_get_current_params(call);
            
            const LinphoneCallParams *remote = linphone_call_get_remote_params(call);
            
            /* remote wants to add video */
            if (linphone_core_video_display_enabled(LC) && !linphone_call_params_video_enabled(current) &&
                linphone_call_params_video_enabled(remote) &&
                !linphone_core_get_video_policy(LC)->automatically_accept) {
                linphone_core_defer_call_update(LC, call);
                [self displayAskToEnableVideoCall:call];
            } else if (linphone_call_params_video_enabled(current) && !linphone_call_params_video_enabled(remote)) {
                [self displayAudioCall:animated];
            }
            break;
        }
        case LinphoneCallPausing:
        case LinphoneCallPaused:
            [self displayAudioCall:animated];
            
            break;
        case LinphoneCallPausedByRemote:
            [self displayAudioCall:animated];
            if (call == linphone_core_get_current_call(LC)) {
                _pausedByRemoteView.hidden = NO;
            }
            break;
        case LinphoneCallEnd:
        case LinphoneCallError:
            
        default:
            break;
    }
    
}
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}
#pragma mark - ActionSheet Functions

- (void)displayAskToEnableVideoCall:(LinphoneCall *)call {
    if (linphone_core_get_video_policy(LC)->automatically_accept)
        return;
    
    NSString *username = [FastAddressBook displayNameForAddress:linphone_call_get_remote_address(call)];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@ would like to enable video", nil), username];
    UIConfirmationDialog *sheet = [UIConfirmationDialog ShowWithMessage:title
                                                          cancelMessage:nil
                                                         confirmMessage:NSLocalizedString(@"ACCEPT", nil)
                                                          onCancelClick:^() {
                                                              LOGI(@"User declined video proposal");
                                                              if (call == linphone_core_get_current_call(LC)) {
                                                                  LinphoneCallParams *params = linphone_core_create_call_params(LC,call);
                                                                  linphone_core_accept_call_update(LC, call, params);
                                                                  linphone_call_params_destroy(params);
                                                                  [videoDismissTimer invalidate];
                                                                  videoDismissTimer = nil;
                                                              }
                                                          }
                                                    onConfirmationClick:^() {
                                                        LOGI(@"User accept video proposal");
                                                        if (call == linphone_core_get_current_call(LC)) {
                                                            LinphoneCallParams *params = linphone_core_create_call_params(LC,call);
                                                            linphone_call_params_enable_video(params, TRUE);
                                                            linphone_core_accept_call_update(LC, call, params);
                                                            linphone_call_params_destroy(params);
                                                            [videoDismissTimer invalidate];
                                                            videoDismissTimer = nil;
                                                        }
                                                    }
                                                           inController:self];
    videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                         target:self
                                                       selector:@selector(dismissVideoActionSheet:)
                                                       userInfo:sheet
                                                        repeats:NO];
}

- (void)dismissVideoActionSheet:(NSTimer *)timer {
    UIConfirmationDialog *sheet = (UIConfirmationDialog *)timer.userInfo;
    [sheet dismiss];
}

#pragma mark VideoPreviewMoving

- (void)moveVideoPreview:(UIPanGestureRecognizer *)dragndrop {
    CGPoint center = [dragndrop locationInView:_videoPreview.superview];
    _videoPreview.center = center;
    if (dragndrop.state == UIGestureRecognizerStateEnded) {
        [self previewTouchLift];
    }
}

- (CGFloat)coerce:(CGFloat)value betweenMin:(CGFloat)min andMax:(CGFloat)max {
    return MAX(min, MIN(value, max));
}

- (void)previewTouchLift {
    CGRect previewFrame = _videoPreview.frame;
    previewFrame.origin.x = [self coerce:previewFrame.origin.x
                              betweenMin:5
                                  andMax:(UIScreen.mainScreen.bounds.size.width - 5 - previewFrame.size.width)];
    previewFrame.origin.y = [self coerce:previewFrame.origin.y
                              betweenMin:5
                                  andMax:(UIScreen.mainScreen.bounds.size.height - 5 - previewFrame.size.height)];
    
    if (!CGRectEqualToRect(previewFrame, _videoPreview.frame)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 LOGD(@"Recentering preview to %@", NSStringFromCGRect(previewFrame));
                                 _videoPreview.frame = previewFrame;
                             }];
        });
    }
}

#pragma mark - Action Functions

- (IBAction)onNumpadClick:(id)sender {
    if ([_numPadBGView isHidden]) {
        [self hidePad:FALSE animated:ANIMATED];
    } else {
        [self hidePad:TRUE animated:ANIMATED];
    }
}

- (IBAction)onChatClick:(id)sender {
    [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
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

- (IBAction)onOptionsClick:(id)sender {
    if ([_optionsView isHidden]) {
        [self hideOptions:FALSE animated:ANIMATED];
    } else {
        [self hideOptions:TRUE animated:ANIMATED];
    }
}

- (IBAction)onOptionsTransferClick:(id)sender {
    [self hideOptions:TRUE animated:TRUE];
    DialerView *view = VIEW(DialerView);
    [view setAddress:@""];
    LinphoneManager.instance.nextCallIsTransfer = YES;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

- (IBAction)onOptionsAddClick:(id)sender {
    [self hideOptions:TRUE animated:TRUE];
    DialerView *view = VIEW(DialerView);
    [view setAddress:@""];
    LinphoneManager.instance.nextCallIsTransfer = NO;
    [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
}

- (IBAction)onOptionsConferenceClick:(id)sender {
    [self hideOptions:TRUE animated:TRUE];
    linphone_core_add_all_to_conference(LC);
}

#pragma mark - Animation

- (void)hideAnimation:(BOOL)hidden forView:(UIView *)target completion:(void (^)(BOOL finished))completion {
    if (hidden) {
        int original_y = target.frame.origin.y;
        CGRect newFrame = target.frame;
        newFrame.origin.y = self.view.frame.size.height;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             target.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                             CGRect originFrame = target.frame;
                             originFrame.origin.y = original_y;
                             target.hidden = YES;
                             target.frame = originFrame;
                             if (completion)
                                 completion(finished);
                         }];
    } else {
        CGRect frame = target.frame;
        int original_y = frame.origin.y;
        frame.origin.y = self.view.frame.size.height;
        target.frame = frame;
        frame.origin.y = original_y;
        target.hidden = NO;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             target.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             target.frame = frame; // in case application did not finish
                             if (completion)
                                 completion(finished);
                         }];
    }
}

#pragma mark - Bounce
- (void)messageReceived:(NSNotification *)notif {
    [self updateUnreadMessage:TRUE];
}
- (void)updateUnreadMessage:(BOOL)appear {
    int unreadMessage = [LinphoneManager unreadMessageCount];
    if (unreadMessage > 0) {
        _chatNotificationLabel.text = [NSString stringWithFormat:@"%i", unreadMessage];
        [_chatNotificationView startAnimating:appear];
    } else {
        [_chatNotificationView stopAnimating:appear];
    }
}
-(void)settempratue
{
    _tmpicon.hidden=YES;
    _tmptmp.hidden=YES;
    _tmplocation.hidden=YES;
    if (phoneNumber.length>10) {
        
        
        RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
        //NSString *numberKey = [phoneNumber stringByReplacingOccurrencesOfString:@"00"
        // withString:@"+"];
        //c1864e8627657358c7fa4a0557d36d3d 30782cdad57eb61895cff22e45fde12c
        [baseobj getCallerInfo:phoneNumber andapikey:@"30782cdad57eb61895cff22e45fde12c" callback:^(NSDictionary *result) {
            NSString *main=[result valueForKey:@"location"];
            NSString *maincountry=[result valueForKey:@"country_name"];
            [maincountry stringByReplacingOccurrencesOfString:@"(Republic of)" withString:@""];
            if (![result objectForKey:@"error"]) {
                
                [baseobj getCallerInfofortempdetail:[result valueForKey:@"country_code"] aanstatename:[result valueForKey:@"location"] andapikey:@"a9ee24496f040339dbce7ab60211c0bc" callback:^(NSDictionary *result) {
                    if (result) {
                        // NSDictionary *cc=[[NSDictionary alloc]init];
                        // cc=[result valueForKey:@"list"];
                        NSLog(@"%@--%@",[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"],[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"]);
                        
                        
                        RazaTempratureObject *baseobj=[[RazaTempratureObject alloc]init];
                        [baseobj setlocationmapsidebarselfonly:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lat"] andlongitude:[[[result valueForKey:@"city"] objectForKey:@"coord"]objectForKey:@"lon"] andapikey:APIKEY callback:^(RazaTempratureObject *sellerarray, UIView *baseview, NSError *error, NSString* timestring) {
                            if (sellerarray) {
                                _tmpicon.hidden=NO;
                                _tmptmp.hidden=NO;
                                _tmplocation.hidden=NO;
                                //[_tmpicon sd_setImageWithURL:[NSURL URLWithString:sellerarray.CurrentImage]placeholderImage:[UIImage imageNamed:@"dweather.png"] options:SDWebImageContinueInBackground];
                                
                                
                                NSURL *urluser=[NSURL URLWithString:sellerarray.CurrentImage];
                                [[Razauser SharedInstance] downloadImageWithURL:urluser completionBlock:^(BOOL succeeded, UIImage *image) {
                                    if (image)
                                    {
                                        _tmpicon.image =image;
                                        
                                    }
                                    
                                    else
                                        _tmpicon.image =  [UIImage imageNamed:@"dweather.png"];
                                }];
                                
                                
                                if (main.length)
                                    _tmplocation.text=[NSString stringWithFormat:@"%@,%@",main,maincountry];
                                else
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
                    
                }];
                
            }
        }];
    }
    //    else
    //    {
    //        _tmpicon.hidden=NO;
    //        _tmptmp.hidden=NO;
    //        _tmplocation.hidden=NO;
    //        [self showselftemp];
    //    }
    
}

-(void)setTemparatureView{
    if ([Razauser SharedInstance].isLocation) {
        if ([Razauser SharedInstance].tempdict.allKeys.count) {
            _tmpview.hidden=NO;
            _tmplocation.hidden=NO;
        }
        else{
            _tmpview.hidden=YES;
            _tmplocation.hidden=YES;
        }
        self.tmpview.layer.cornerRadius = 20;
        self.tmpview.clipsToBounds = YES;

        if (lockunlock.length&&[[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] length]) {
            NSString *modecall1=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"];
            if ([modecall1 containsString:@"| "]) {
                NSArray *arr=[[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPLOCATION"] componentsSeparatedByString:@"| "];
                if (arr.count==2) {
                    _tmplocation.text=[arr objectAtIndex:0];
                }
            }
        }
        else{
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

        _tmptmp.text=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMP"];
        _tmptime.text=[[Razauser SharedInstance].tempdict  objectForKey:@"TEMPTIME"];
        
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
    else{
        _tmplocation.hidden=YES;
        _tmpview.hidden=YES;
        _tmplocation.hidden=YES;
        
    }
}

@end
