//
//  Razauser.h
//  linphone
//
//  Created by umenit on 11/30/16.
//
//

#import <Foundation/Foundation.h>
#import "ContactsListView.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "UIRoundedImageView.h"

@interface Razauser : NSObject
{
    OrderedDictionary *addressBookMap;
    
}
+(Razauser*)SharedInstance;
-(NSArray*)getRazauser;

-(void)setRazauser:(NSArray*)allrazauser;
//-(OrderedDictionary*)getFormatedRazaUser;
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
- (void)getformatedrazauser:(NSString *)methodname  callback:(void (^)(OrderedDictionary *addressBookMap, NSError *error))callback;
-(NSString*)getusername:(NSString*)byid;

- (MBProgressHUD *)ShowWaiting:(NSString *)title;
//- (MBProgressHUD *)ShowWaitingshort:(NSString *)title;
- (MBProgressHUD *)ShowWaitingshort:(NSString *)title andtime:(float)timeperiod;
- (void)HideWaiting;
-(NSDictionary *)getRazauserORnotWithPhonenumber:(LinphoneAddress *)address;
@property (strong,nonatomic) NSString* modeofview;
@property int sideBarIndex;
@property (strong,nonatomic) NSString* callmode;
@property (strong,nonatomic) NSString* callmodeofstatus;
@property (strong,nonatomic) NSDictionary* ratingDetailDic;
@property (strong,nonatomic) NSMutableSet* ratingUserNameDetailSet;
@property (strong,nonatomic) NSString* callModeType;
@property BOOL isLocation;
@property  int pausecounter;
@property (strong,nonatomic) OrderedDictionary *addressBookMapalluser;
@property (strong,nonatomic) OrderedDictionary *addressBookMaprazauseruser;
-(void)setrazauserbyname;
-(NSDictionary*)getRazauserbyname;
-(NSData *)compressImage:(UIImage *)image;
-(NSData*)compresstest:(UIImage *)image;
-(void)setContactForPushraza:(NSDictionary*)allrazauser;
-(NSDictionary*)getContactForPushRaza;
- (NSString *)getContactRazaPush:(NSString *)address;
-(void)setPushrazaCounter:(NSString*)senderurl and:(NSString*)addorremove;
-(NSDictionary*)getPushrazaCounter;
@property  int countformsg;
-(void)deletepushfromchat:(LinphoneChatRoom *)chatRoom;
-(void)addCallToDatabase:(NSString*)modeofcall  andsender:(NSString*)senderurl;
-(BOOL)chkforsimGlobal;
-(void)setmissed:(BOOL)yes;
-(int)getmissed;
-(void)setRazaimageforimage:(UIRoundedImageView*)imgview andstringname:(NSString*)str andthumbornot:(NSString*)param;
-(void)setsidebar:(NSString*)length;
-(NSString*)getsidebar;
@property (strong,nonatomic) NSDictionary *tempdict;
- (void)getRazaUserBySearch:(NSString *)name  callback:(void (^)(OrderedDictionary *addressBookMap, NSError *error))callback;


@end
