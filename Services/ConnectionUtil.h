//
//  ConnectionUtil.h
//  Raza
//
//  Created by Dhanendra Singh on 5/21/10.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

@protocol NSConnectionProt
- (void)getCallBackResponse:(NSString *)resultString withResultType:(NSString *)resultType;
- (void)getCallBackResponseNewsip:(NSDictionary *)resultString withResultType:(NSString *)resultType;

@end

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "Reachability.h"

@interface ConnectionUtil : NSObject <NSXMLParserDelegate>{
	BOOL recordResults;
	//id <NSConnectionProt> objprot;
	NetworkStatus internetConnectionStatus;
	NetworkStatus remoteHostStatus;
	Reachability* internetReach;
	
}

@property (weak)id <NSConnectionProt> objprot;

-(void)initConnection:(NSString *)parsingString withProtocol:(id <NSConnectionProt>)objADoerImpl withResultType:(NSString *)resType withMethod:(NSString *)methodName;
+ (void)asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *,NSURLResponse *))successBlock_ failure:(void(^)(NSData *,NSError *))failureBlock_;

//+(NSString *)getIPAddress;
@property(nonatomic, strong) NSString *Methodtype;
@property(nonatomic, strong) NSMutableData *webData;
@property(nonatomic, strong) NSMutableString *soapResults;
@property(nonatomic, strong) NSString *resultType;
@property(nonatomic, strong) NSXMLParser *xmlParser;
//@property NetworkStatus internetConnectionStatus;
//@property NetworkStatus remoteHostStatus;
@end
extern NSString *checkforrecent;
extern NSString *checkforstate;
extern NSString *checkfornetworktype;
extern NSString *checkforcallvia;
extern NSString *checkfor_availablenetwork;
extern NSString *checkfor_useingnetwork;
extern NSMutableArray   *checkforrecentmessage;
 extern NSMutableDictionary *dictforsignupsms;
extern NSString *firstbtn;
extern NSString *secondbtn;
extern NSString *sthirdbtn;
extern NSString *stringforsegmentmedia;
extern UIImage *imgforprofile;
extern  NSMutableDictionary *cellthumbnail;
extern  NSMutableArray *isuploading;
extern  NSString *shoulddelete;
extern  NSString *checkuservibrate;
extern  NSMutableDictionary *personalinfo;
extern  NSString *refreshtablewhilegalary;
extern NSMutableArray *Razaonlineuser;
extern NSString *STRUSER;
extern NSString  *ENGINEACTIVEMODE;
extern NSMutableArray  *ENGINEACTIVEMODEARRAY;
extern  NSMutableDictionary *chatuserlist;
extern NSString *userMode;
extern NSString *serachmodetoaddressbook;
extern NSString *keyfortemprature;
extern NSString *keyforcallbalance;
extern NSString *keyfortempmode;
extern NSString *keyforshowpersonal;
extern NSArray *razaglobalcountryarray;
extern NSString *razaimchatting;
extern NSString *modeofback;
extern NSString *modeofcalldisappear;
extern NSMutableDictionary *contactarray;
extern NSString *pushdevicetoken;
extern NSString *pushcall;
extern NSDictionary *pushdict;
extern NSTimer *basetimer;
extern NSString *lockunlock;
extern NSString *lockunlockfornotification;
extern  NSString *incomingmissed;
extern  NSString *whichtabselected;
extern NSArray *razaglobalcountryarrayrecent;
extern  NSString *tabselected;
extern  NSString *stringnametoselectedmodeselfortable;
extern NSString *moderazauserornot;
extern NSString *selectedmoderaza;
extern NSString *selectedmoderazavideooraodio;
extern NSString *sidebarshowhide;
extern BOOL MODECALLAUDIOVIDEO;
extern NSString *MODEFORCALLAUDIOVIDEO;
