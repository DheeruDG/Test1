//
//  RazaNotificationObject.h
//  Raza
//
//  Created by umenit on 10/1/16.
//  Copyright © 2016 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaNotificationObject : NSObject
+(RazaNotificationObject*)SharedInstance;
-(NSDate*)backtonsdate:(NSString*)dateString;
-(NSString*)getTime;
-(NSTimeInterval)compareTimeSlot:(NSString*)prevtime;
-(NSString*)GettrimmedPush:(NSString*)pushstring;
-(void)setnotificationformiisedcall;
-(int)getnotifationformissedcall;
-(void)setnotificationforchat;
-(int)getnotifationforchat;
-(void)removekeyfornotifity:(NSString*)keyremoval;
-(NSArray*)modeofpushmsg:(NSString*)pushmsgformat;
- (BOOL) containsString: (NSString*) substring andmainstringcontains:(NSString*)mainstring;
-(NSArray*)checkstringpushmessage:(NSString*)msgstring;
@end

