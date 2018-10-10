//
//  RazaConnectionManager.h
//  Raza
//
//  Created by Praveen S on 11/18/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RazaConnectionManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection * internalConnection;
    NSMutableData * container;
}

-(id)initWithRequest:(NSURLRequest *)req;

//@property (nonatomic,copy)NSURLConnection *internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completitionBlock) (id obj, NSError * err);


-(void)start;

@end
