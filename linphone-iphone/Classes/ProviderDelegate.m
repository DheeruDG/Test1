//
//  ProviderDelegate.m
//  linphone
//
//  Created by REIS Benjamin on 29/11/2016.
//
//

#import "ProviderDelegate.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#include "linphone/linphonecore.h"
#import <AVFoundation/AVAudioSession.h>
#import <Foundation/Foundation.h>

@implementation ProviderDelegate

- (instancetype)init {
	self = [super init];
	self.calls = [[NSMutableDictionary alloc] init];
	self.uuids = [[NSMutableDictionary alloc] init];
	self.pendingCall = NULL;
	self.pendingAddr = NULL;
	self.pendingCallVideo = FALSE;
	CXCallController *callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
	[callController.callObserver setDelegate:self queue:dispatch_get_main_queue()];
	self.controller = callController;

	if (!self) {
		LOGD(@"ProviderDelegate not initialized...");
	}
	return self;
}

- (void)config {
	CXProviderConfiguration *config = [[CXProviderConfiguration alloc]
		initWithLocalizedName:[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
	config.ringtoneSound = @"Ringtone2.mp3";//@"notes_of_the_optimistic.caf";
	config.supportsVideo = FALSE;
	config.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"callkit_logo"]);

	NSArray *ar = @[ [NSNumber numberWithInt:(int)CXHandleTypeGeneric] ];
	NSSet *handleTypes = [[NSSet alloc] initWithArray:ar];
	[config setSupportedHandleTypes:handleTypes];
	[config setMaximumCallGroups:2];
	[config setMaximumCallsPerCallGroup:1];
	self.provider = [[CXProvider alloc] initWithConfiguration:config];
	[self.provider setDelegate:self queue:dispatch_get_main_queue()];
}

- (void)configAudioSession:(AVAudioSession *)audioSession {
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	[audioSession setMode:AVAudioSessionModeVoiceChat error:nil];
    
	double sampleRate = 44100.0;
	[audioSession setPreferredSampleRate:sampleRate error:nil];
}

- (void)reportIncomingCallwithUUID:(NSUUID *)uuid handle:(NSString *)handle video:(BOOL)video {
	// Create update to describe the incoming call and caller
	CXCallUpdate *update = [[CXCallUpdate alloc] init];
	update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:handle];
	update.supportsDTMF = TRUE;
	update.supportsHolding = TRUE;
	update.supportsGrouping = TRUE;
	update.supportsUngrouping = TRUE;
	update.hasVideo = video;

	// Report incoming call to system
	LOGD(@"CallKit: report new incoming call");
	[self.provider reportNewIncomingCallWithUUID:uuid
										  update:update
									  completion:^(NSError *error) {
									  }];
}

#pragma mark - CXProdiverDelegate Protocol

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
	LOGD(@"CallKit : Answering Call");
	//[self configAudioSession:[AVAudioSession sharedInstance]];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self startIOUnit];
//        [self configAudioSession:[AVAudioSession sharedInstance]];
//    });
	[action fulfill];
	NSUUID *uuid = action.callUUID;

	NSString *callID = [self.calls objectForKey:uuid]; // first, make sure this callid is not already involved in a call
	LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
	if (call != NULL) {
		BOOL video = (!([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) &&
					  linphone_core_get_video_policy(LC)->automatically_accept &&
					  linphone_call_params_video_enabled(linphone_call_get_remote_params((LinphoneCall *)call)));
		self.pendingCall = call;
		self.pendingCallVideo = video;
      
//        PhoneMainView *view = [[PhoneMainView alloc]init];
//
//        [view incomingCallAccepted:call evenWithVideo:YES];
        
		return;
	};
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action {
	LOGD(@"CallKit : Starting Call");
	// To restart Audio Unit
	[self configAudioSession:[AVAudioSession sharedInstance]];
	[action fulfill];
	NSUUID *uuid = action.callUUID;

	NSString *callID = [self.calls objectForKey:uuid]; // first, make sure this callid is not already involved in a call
	LinphoneCall *call;
	if (![callID isEqualToString:@""]) {
		call = linphone_core_get_current_call(LC);
	} else {
		call = [LinphoneManager.instance callByCallId:callID];
	}
	if (call != NULL) {
		_pendingCall = call;
	}
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
	LOGD(@"CallKit : Ending the Call");
	[action fulfill];
	if (linphone_core_is_in_conference(LC)) {
		LinphoneManager.instance.conf = TRUE;
		linphone_core_terminate_conference(LC);
	} else if (linphone_core_get_calls_nb(LC) > 1) {
		LinphoneManager.instance.conf = TRUE;
		linphone_core_terminate_all_calls(LC);
	} else {
		NSUUID *uuid = action.callUUID;
		NSString *callID = [self.calls objectForKey:uuid];
		LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
		if (call) {
			linphone_core_terminate_call(LC, (LinphoneCall *)call);
		}
	}
}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(nonnull CXSetMutedCallAction *)action {
	[action fulfill];
	if ([[PhoneMainView.instance currentView] equal:CallView.compositeViewDescription]) {
		CallView *view = (CallView *)[PhoneMainView.instance popToView:CallView.compositeViewDescription];
		[view.microButton toggle];
	}
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(nonnull CXSetHeldCallAction *)action {
	LOGD(@"CallKit : Call paused status changed");
	[action fulfill];
	if (linphone_core_is_in_conference(LC) && action.isOnHold) {
		linphone_core_leave_conference(LC);
		[NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
		return;
	}

	if (linphone_core_get_calls_nb(LC) > 1 && action.isOnHold) {
		linphone_core_pause_all_calls(LC);
		return;
	}

	NSUUID *uuid = action.callUUID;
	NSString *callID = [self.calls objectForKey:uuid];
	if (!callID) {
		return;
	}

	LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
	if (call) {
		if (action.isOnHold) {
			linphone_core_pause_call(LC, (LinphoneCall *)call);
		} else {
			[self configAudioSession:[AVAudioSession sharedInstance]];
			if (linphone_core_get_conference(LC)) {
				linphone_core_enter_conference(LC);
				[NSNotificationCenter.defaultCenter postNotificationName:kLinphoneCallUpdate object:self];
			} else {
				_pendingCall = call;
			}
		}
	}
}

- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action {
	LOGD(@"CallKit : playing DTMF");
	[action fulfill];
	NSUUID *call_uuid = action.callUUID;
	NSString *callID = [self.calls objectForKey:call_uuid];
	LinphoneCall *call = [LinphoneManager.instance callByCallId:callID];
	char digit = action.digits.UTF8String[0];
	linphone_call_send_dtmf((LinphoneCall *)call, digit);
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession {
	LOGD(@"CallKit : Audio session activated");
	// Now we can (re)start the call
	if (_pendingCall) {
		LinphoneCallState state = linphone_call_get_state(_pendingCall);
		switch (state) {
			case LinphoneCallIncomingReceived:
				[LinphoneManager.instance acceptCall:(LinphoneCall *)_pendingCall evenWithVideo:_pendingCallVideo];
				break;
			case LinphoneCallPaused:
				linphone_core_resume_call(LC, (LinphoneCall *)_pendingCall);
				break;
			case LinphoneCallStreamsRunning:
				// May happen when multiple calls
				break;
			default:
				break;
		}
	} else {
		if (_pendingAddr) {
            [LinphoneManager.instance doCall:_pendingAddr andmodevideoaudio:MODECALLAUDIOVIDEO];
		} else {
			LOGE(@"CallKit : No pending call");
		}
	}

	_pendingCall = NULL;
	_pendingAddr = NULL;
	_pendingCallVideo = FALSE;
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(nonnull AVAudioSession *)audioSession {
	LOGD(@"CallKit : Audio session deactivated");

	_pendingCall = NULL;
	_pendingAddr = NULL;
	_pendingCallVideo = FALSE;
}

- (void)providerDidReset:(CXProvider *)provider {
	LOGD(@"CallKit : Provider reset");
	LinphoneManager.instance.conf = TRUE;
	linphone_core_terminate_all_calls(LC);
	[self.calls removeAllObjects];
	[self.uuids removeAllObjects];
}

#pragma mark - CXCallObserverDelegate Protocol

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
	LOGD(@"CallKit : Call changed");
}
- (OSStatus)startIOUnit
{
    
    OSStatus err = AudioOutputUnitStart(_rioUnit);
    if (err) NSLog(@"couldn't start Apple Voice Processing IO: %d", (int)err);
    return err;
}
- (void)setupIOUnit
{
  
        // Create a new instance of Apple Voice Processing IO
        
        AudioComponentDescription desc;
        desc.componentType = kAudioUnitType_Output;
        desc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        desc.componentManufacturer = kAudioUnitManufacturer_Apple;
        desc.componentFlags = 0;
        desc.componentFlagsMask = 0;
        
        AudioComponent comp = AudioComponentFindNext(NULL, &desc);
        AudioComponentInstanceNew(comp, &_rioUnit);
        
        //  Enable input and output on Apple Voice Processing IO
        //  Input is enabled on the input scope of the input element
        //  Output is enabled on the output scope of the output element
        
        UInt32 one = 1;
       AudioUnitSetProperty(_rioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &one, sizeof(one));
       AudioUnitSetProperty(_rioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &one, sizeof(one));
        
        // Explicitly set the input and output client formats
        // sample rate = 44100, num channels = 1, format = 32 bit floating point
        
//        CAStreamBasicDescription ioFormat = CAStreamBasicDescription(44100, 1, CAStreamBasicDescription::kPCMFormatFloat32, false);
//        XThrowIfError(AudioUnitSetProperty(_rioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &ioFormat, sizeof(ioFormat)), "couldn't set the input client format on Apple Voice Processing IO");
//        XThrowIfError(AudioUnitSetProperty(_rioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &ioFormat, sizeof(ioFormat)), "couldn't set the output client format on Apple Voice Processing IO");
//        
        // Set the MaximumFramesPerSlice property. This property is used to describe to an audio unit the maximum number
        // of samples it will be asked to produce on any single given call to AudioUnitRender
        UInt32 maxFramesPerSlice = 4096;
       AudioUnitSetProperty(_rioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFramesPerSlice, sizeof(UInt32));
        
        // Get the property value back from Apple Voice Processing IO. We are going to use this value to allocate buffers accordingly
        UInt32 propSize = sizeof(UInt32);
        AudioUnitGetProperty(_rioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFramesPerSlice, &propSize);
        
        // We need references to certain data in the render callback
        // This simple struct is used to hold that information
        
    
   
    

}

@end
