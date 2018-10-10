//
//  ConnectionUtil2.m
//  Raza
//
//  Created by Dhanendra Singh on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConnectionUtil2.h"


@implementation ConnectionUtil2

@synthesize webData, soapResults, xmlParser,resultType,objprot2;
@synthesize internetConnectionStatus;
@synthesize remoteHostStatus;

-(void)initConnection:(NSString *)parsingString andsecond:(id <NSConnectionProt2>) objADoerImpl andthird:(NSString *)resType andforth:(NSString *)methodName
{
	resultType=resType;
	
	objprot2=	objADoerImpl;
	NSString *soapMessage=parsingString;

	internetReach = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
	
	if((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
														message:@"Network not available."
													   delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
		
		
		[alert show];
		
        [objprot2 getData:nil andsecond:@"error"];
		return;
		
	}

	NSURL *url = [NSURL URLWithString:APIRAZABASEURL];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: methodName forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		webData = [NSMutableData data];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
    theConnection = nil;
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [objprot2 getData:nil andsecond:@"error"];
	NSLog(@"ERROR with theConenction");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Network not available"
												   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[alert show];
    self.webData = nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *testXMLString = [[NSMutableString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    
    [XMLConverter convertXMLString:testXMLString completion:^(BOOL success, NSDictionary *dictionary, NSError *error)
     {
         if (error==nil) {
             NSDictionary *resString=[[[[dictionary objectForKey:@"soap:Envelope"]objectForKey:@"soap:Body"]objectForKey:[NSString stringWithFormat:@"%@Response",resultType]]objectForKey:[NSString stringWithFormat:@"%@Result",resultType]];
             [objprot2 getData:resString andsecond:resultType];
         }else{
             [objprot2 getData:nil andsecond:@"error"];
         }
         NSLog(@"%@", success ? dictionary : error);
     }];

	self.webData=nil;
	self.xmlParser=nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
