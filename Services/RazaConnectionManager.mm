//
//  RazaConnectionManager.m
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaConnectionManager.h"

static NSMutableArray *sharedConnectionList = nil;
@implementation RazaConnectionManager

-(id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start {
    
    container = [[NSMutableData alloc]init];
    
   internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
    
}


#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completitionBlock])
        [self completitionBlock](container,nil);
    
    [sharedConnectionList removeObject:self];
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completitionBlock])
        [self completitionBlock](nil,error);
    
    [sharedConnectionList removeObject:self];
    
}

@end
