//
//  PopoverViewController.h
//  Raza
//
//  Created by Praveen S on 1/22/14.
//  Copyright (c) 2013 Advali. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController
{
    UIView *containerView;
    UIView *contentView;
    UIToolbar *toolbar;
    UILabel *titleLabel;
    
    UIViewController *popoverContentController;
}

@property (nonatomic, strong) NSString* popoverTitle;

- (id)initWithFrame:(CGRect)frame withToolbar:(BOOL)showToolbar;

- (void)addPopoverContent:(UIViewController*)popoverContent;

- (void)presentInViewController:(UIViewController*)parentViewController;

- (void)dismiss;

@end
