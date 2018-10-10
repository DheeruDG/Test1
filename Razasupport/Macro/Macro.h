//
//  Macro.h
//  LosAngelsApp
//
//  Created by Praveen S on 11/2/13.
//  Copyright (c) 2013 Advali. All rights reserved.
//


#define RAZASIPURL @"54.201.171.108"
#define RAZASIPPORT @"5242"
//UIColor *defaultColor = [UIColor colorWithRed:(36/255.0) green:(60/255.0) blue:(128/255.0) alpha:1];
#define kColorHeader [UIColor colorWithRed:0/255.0f green:175/255.0f blue:215/255.0f alpha:1.0f]
#define kColorKeyboard [UIColor colorWithRed:0/255.0f green:175/255.0f blue:216/255.0f alpha:1.0f]
#define kColordialpad [UIColor colorWithRed:237/255.0f green:240/255.0f blue:245/255.0f alpha:1.0f]
#define kConnectionRed [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f]
#define kConnectionGreen [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f]
#define kConnectionGRAY [UIColor colorWithRed:63/255.0f green:81/255.0f blue:181/255.0f alpha:1.0f]
#define Razatempratureuser @"Temprature"
#define Razatempratureuserself @"TempratureSelf"
#define Razatempraturemode @"tempraturemode"
#define kRecentImgSizeWidth 46
#define kRecentImgSizeHeight 46
#define Kcolorforkeyboardtoolabr [UIColor colorWithRed:(255.0f/255.0f) green:(255.0f/255.0f) blue:(255.0f/255.0f) alpha:1]
//#define Kcolorforkeyboardtoolabr [UIColor colorWithRed:(51.0f/255.0f) green:(153.0f/255.0f) blue:(255.0f/255.0f) alpha:1]

#define RAZACALLINGTONE @"Ringtone2.mp3"//@"Ringtone2.m4r"//@"ringtone.wav"
#define RAZAMP3RING @"Ringtone2.mp3"//@"ringtone.mp3"
#define RESP_ERROR @"error"
#define RAZA_FONT_10 [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
#define RAZA_FONT_13 [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];

#define RAZA_CELL_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];

#define RAZA_CELL_FONT_SETTINGS [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];


#define RAZA_CELL_BOLD_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];

#define RAZA_FONT_BOLD_MEDIUM [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];

#define RAZA_FONT_MEDIUM [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];

#define RAZA_CELL_FONT_BIG [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];

#define RAZA_CELL_SMALL_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];

#define APP_FRAME [UIScreen mainScreen].applicationFrame

#define RAZA_APPDELEGATE  ((LinphoneAppDelegate *) [[UIApplication sharedApplication] delegate])

#define IPHONE4_FRAME(obj,xRatio,yRatio,widthRatio,heightRatio) CGRectMake(obj.frame.origin.x + xRatio, obj.frame.origin.y + yRatio, obj.frame.size.width + widthRatio, obj.frame.size.height + heightRatio)

#define RAZA_USERDEFAULTS [NSUserDefaults standardUserDefaults]

#define RAZA_PROFILE @"http://54.149.13.57/profile/profile-images/"
#define RAZA_PROFILETHUMB @"http://54.149.13.57/profile/profile-thumbimages/"


#import <mach/mach_time.h> // for mach_absolute_time() and friends

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

static inline NSString *StringFromObject(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object respondsToSelector:@selector(stringValue)]){
        return [object stringValue];
    } else {
        return [object description];
    }
}

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_EMPTY(v) [v isEqualToString:@""]
#define IS_NOTEMPTY(v) [v length]

#pragma mark -
#pragma mark iOS Version

#define IOS_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark -
#pragma mark Syntactic sugar

#define NOT_ANIMATED NO
//#define ANIMATED YES

#pragma mark -
#pragma mark UIColor

// example usage: UIColorFromHex(0x9daa76)
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue) UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b) UIColorFromRGBA(r,g,b,1.0)

#pragma mark -
#pragma mark Collections

#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) [NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]

#define DICT(...) DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

//The helper function unpacks the object array and then calls through to NSDictionary to create the dictionary:
static inline NSDictionary *DictionaryWithIDArray(id *array, NSUInteger count) {
    id keys[count];
    id objs[count];
    
    for(NSUInteger i = 0; i < count; i++) {
        keys[i] = array[i * 2];
        objs[i] = array[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}
#define POINTERIZE(x) ((__typeof__(x) []){ x })
#define NSVALUE(x) [NSValue valueWithBytes: POINTERIZE(x) objCType: @encode(__typeof__(x))]

#pragma mark -
#pragma mark Logging

#define LOG(fmt, ...) NSLog(@"%s:%d (%s): " fmt, __FILE__, __LINE__, __func__, ## __VA_ARGS__)

#ifdef DEBUG
#define INFO(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#else
// do nothing
#define INFO(fmt, ...)
#endif

#define ERROR(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#define TRACE(fmt, ...) LOG(fmt, ## __VA_ARGS__)

#pragma mark -
#pragma mark NSNumber

#define NUM_INT(int) [NSNumber numberWithInt:int]
#define NUM_FLOAT(float) [NSNumber numberWithFloat:float]
#define NUM_BOOL(bool) [NSNumber numberWithBool:bool]

#pragma mark -
#pragma mark Frame Geometry

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

#pragma mark -
#pragma mark IndexPath

#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#define ALWAYS_TRUE YES ||
#define NEVER_TRUE NO &&

#pragma mark -
#pragma mark Device type.
// Corresponds to "Targeted device family" in project settings
// Universal apps will return true for whichever device they're on.
// iPhone apps will return true for iPhone even if run on iPad.

#define TARGETED_DEVICE_IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TARGETED_DEVICE_IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define TARGETED_DEVICE_IS_IPHONE_568 TARGETED_DEVICE_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height > 500

#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define iPhone4Or5oriPad ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : 999))
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))

#pragma mark -
#pragma mark Transforms

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

static inline void TimeThisBlock (void (^block)(void), NSString *message) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        block();
        return;
    };
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    LOG(@"Took %f seconds to %@", (CGFloat)nanos / NSEC_PER_SEC, message);
}

#define REMOVE_WHITELINESPACE(obj) [obj stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]



// idoubs related

#undef TAG
#define kTAG @"RazaAppDelegate///: "
#define TAG kTAG
#define kNotifKey									@"key"
#define kNotifKey_IncomingCall						@"icall"
#define kNotifKey_IncomingMsg						@"imsg"
#define kNotifIncomingCall_SessionId				@"sid"

#define kNetworkAlertMsgThreedGNotEnabled			@"Only 3G network is available. Please enable 3G and try again."
#define kNetworkAlertMsgNotReachable				@"No network connection"

#define kNewMessageAlertText						@"You have a new message"

#define kAlertMsgButtonOkText						@"OK"
#define kAlertMsgButtonCancelText					@"Cancel"
#define ShowHidePopup @"popupcall"

#define PUSHMESSAGE @"setnotificationforchat"
#define PUSHMISSEDCALL @"setnotificationformiisedcall"
