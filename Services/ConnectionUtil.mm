//
//  ConnectionUtil.m
//  Raza
//
//  Created by Dhanendra Singh on 5/21/10.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "ConnectionUtil.h"
#import "LinphoneAppDelegate.h"

@implementation ConnectionUtil

-(void)initConnection:(NSString *)parsingString withProtocol:(id<NSConnectionProt>)objADoerImpl withResultType:(NSString *)resType withMethod:(NSString *)methodName {
    
    self.resultType=resType;
    self.Methodtype=methodName;
    self.objprot =	objADoerImpl;
    NSString *soapMessage=parsingString;
    internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    
    if((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN) ){
        //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
        //														message:@"Network not available."
        //													   delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
        //
        //		[alert show];
        //[objprot getCallBackResponse:@"error" withResultType:nil];
        //	[internetReach stopNotifer];
        // [RAZA_APPDELEGATE showMessage:NETWORK_UNAVAILABLE withMode:MBProgressHUDModeText withDelay:2.0 withShortMessage:YES];
        
        //  [RAZA_APPDELEGATE hideIndeterminateIndicator:YES];
        
        return;
    }
    
    //NSURL *url = [NSURL URLWithString:RAZA_APPDELEGATE.baseURL];
    //NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:RAZA_APPDELEGATE.baseURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    NSMutableURLRequest *theRequest;
    if ([methodName isEqualToString:DEFAULT_SIP_ADDRESS]) {
        NSURL *sipurl = [NSURL URLWithString:[DEFAULT_SIP_ADDRESS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        theRequest = [NSMutableURLRequest requestWithURL:sipurl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    }
    else
        theRequest = [NSMutableURLRequest requestWithURL:RAZA_APPDELEGATE.baseURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: methodName forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    ///NSLog(@"theRequest %@ -%@", theRequest,RAZA_APPDELEGATE.baseURL);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        self.webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
    if ([self.Methodtype isEqualToString:DEFAULT_SIP_ADDRESS]) {
        NSError *error;
        
        NSString *json_string = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
        NSString *newStr = [json_string substringWithRange:NSMakeRange(2, [json_string length]-2)];
        NSData* data = [newStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        // NSLog(@"%@", jsonDict);
        
        [self.objprot getCallBackResponseNewsip:jsonDict withResultType:self.resultType];
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //[objprot getCallBackResponse:@"error"];
    //	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
    //													message:@"Network not available"
    //												   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //
    //	[alert show];
    
    //    if (!RAZA_APPDELEGATE.appIndicator.hidden) {
    //        [RAZA_APPDELEGATE.appIndicator hide:YES];
    //        RAZA_APPDELEGATE.appIndicator = nil;
    //        if(![self.resultType isEqualToString:@"add_subscriber"])
    //        [RAZA_APPDELEGATE showMessage:NETWORK_UNAVAILABLE withMode:MBProgressHUDModeText withDelay:2.0 withShortMessage:YES];
    //
    //        [RAZA_APPDELEGATE.appIndicator hide:YES];
    //        RAZA_APPDELEGATE.appIndicator = nil;
    //    }
    //
    
    
    
    
    if([self.resultType isEqualToString:@"add_subscriber"]|| [ self.resultType isEqualToString:@"update_subscriber"])
    {
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"ERROR",@"ERROR", nil];
        [self.objprot getCallBackResponseNewsip:dict withResultType:self.resultType];
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *theXML = [[NSString alloc] initWithBytes: [self.webData mutableBytes] length:[self.webData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"The %@", theXML);
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:self.webData];
    [self.xmlParser setDelegate:self];
    [self.xmlParser setShouldResolveExternalEntities: YES];
    bool parse=[self.xmlParser parse];
    NSLog(@"%d",parse);
    //NSString* newStr = [NSString stringWithUTF8String:[self.webData bytes]];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error %li, Description: %@, Line: %li, Column: %li", (long)[parseError code],
          [[parser parserError] localizedDescription], (long)[parser lineNumber],
          (long)[parser columnNumber]);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError{
    NSLog(@"valid: %@", validError);
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    
    if( [elementName isEqualToString:self.resultType])
    {
        if(!self.soapResults)
        {
            self.soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //[objprot encodeWithCoder:@"hello"];
    if( recordResults )
    {
        [self.soapResults appendString:string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"---incoming %@======= need Result  %@",elementName,self.resultType);
    //    if ([self.resultType isEqualToString:@"Customer_SignUp_Eligible"]) {
    //
    //    }
    if( [elementName isEqualToString:self.resultType])
    {
        recordResults = FALSE;
        [self.objprot getCallBackResponse:self.soapResults withResultType:self.resultType];
        //greeting.text = soapResults;
        self.soapResults = nil;
    }
    else if([elementName isEqualToString:@"faultcode"]){
        [self.objprot getCallBackResponse:self.soapResults withResultType:@"faultcode"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    	return NO;
}

+ (void)asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *,NSURLResponse *))successBlock_ failure:(void(^)(NSData *,NSError *))failureBlock_
{
    [NSThread detachNewThreadSelector:@selector(backgroundSync:) toTarget:[NSURLConnection class]
                           withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       request,@"request",
                                       successBlock_,@"success",
                                       failureBlock_,@"failure",
                                       nil]];
}

#pragma mark Private
+ (void)backgroundSync:(NSDictionary *)dictionary
{
    @autoreleasepool {
        void(^success)(NSData *,NSURLResponse *) = [dictionary objectForKey:@"success"];
        void(^failure)(NSData *,NSError *) = [dictionary objectForKey:@"failure"];
        NSURLRequest *request = [dictionary objectForKey:@"request"];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(error)
        {
            failure(data,error);
        }
        else
        {
            success(data,response);
        }
    }
    
}

@end
NSString *checkforrecent=nil;
NSString *checkforstate=nil;
NSMutableArray   *checkforrecentmessage;
NSMutableDictionary *dictforsignupsms;
NSString *checkfornetworktype;
NSString *checkforcallvia;
NSString *checkfor_availablenetwork;
NSString *checkfor_useingnetwork;
NSString *firstbtn;
NSString *secondbtn;
NSString *sthirdbtn;
NSString *stringforsegmentmedia=@"img";
UIImage *imgforprofile;
NSMutableDictionary *cellthumbnail;
NSMutableArray *isuploading;
NSString *shoulddelete;
NSMutableDictionary *personalinfo;
NSString *refreshtablewhilegalary;
NSMutableArray *Razaonlineuser;
NSString *STRUSER;
NSString  *ENGINEACTIVEMODE;
NSMutableArray  *ENGINEACTIVEMODEARRAY;
NSMutableDictionary *chatuserlist;
NSString *checkuservibrate;
NSString *userMode;
NSString *serachmodetoaddressbook;
NSString *keyfortemprature;
NSString *keyforcallbalance;
NSString *keyfortempmode;
NSArray *razaglobalcountryarray;
NSArray *razaglobalcountryarrayrecent;
NSString *keyforshowpersonal;
NSString *razaimchatting;
NSString *modeofback;
NSString *modeofcalldisappear;
NSMutableDictionary *contactarray;
NSString *pushdevicetoken;
NSString *pushcall;
NSDictionary *pushdict;
NSTimer *basetimer;
NSString *lockunlock;
NSString *lockunlockfornotification;
NSString *incomingmissed;
NSString *whichtabselected;
NSString *tabselected;
NSString *stringnametoselectedmodeselfortable;
NSString *moderazauserornot;
NSString *selectedmoderaza;
NSString *selectedmoderazavideooraodio;
NSString *sidebarshowhide;
BOOL MODECALLAUDIOVIDEO;
NSString *MODEFORCALLAUDIOVIDEO;
