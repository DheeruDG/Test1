//
//  ConnectionUtil2.h
//  Raza
//
//  Created by Dhanendra Singh on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
@protocol NSConnectionProt2
- (void)getData:(NSDictionary *)resultString andsecond:(NSString *)resultType;

@end
#import "XMLConverter.h"
#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "Reachability.h"


@interface ConnectionUtil2 : NSObject <NSXMLParserDelegate> {

	NSMutableData *webData;
	NSMutableString *soapResults;
	NSString *resultType;
	NSXMLParser *xmlParser;
	int recordResults;
	NetworkStatus internetConnectionStatus;
	NetworkStatus remoteHostStatus;
	Reachability* internetReach;
	
}
@property (weak)id <NSConnectionProt2> objprot2;

-(void)initConnection:(NSString *)parsingString andsecond:(id <NSConnectionProt2>) objADoerImpl andthird:(NSString *)resType andforth:(NSString *)methodName;
//-(void) initConnection:(NSString *) parsingString:(id <NSConnectionProt2>) objADoerImpl;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSString *resultType;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus remoteHostStatus;
@end
