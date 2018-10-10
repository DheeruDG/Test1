//
//  RazaLinkLabel.m
//  Raza
//
//  Created by Praveen S on 12/24/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import "RazaLinkLabel.h"

@implementation RazaLinkLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    
    CGContextSetRGBStrokeColor(context, 36/255.0f, 60/255.0f, 128/255.0f, 1.0f);
    //CGContextSetRGBStrokeColor(context, [[UIColor redColor] CGColor], 1.0f);
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width - 15, self.bounds.size.height);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
    
}

@end
