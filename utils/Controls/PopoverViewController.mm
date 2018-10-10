//
//  PopoverViewController.m
//  Raza
//
//  Created by Praveen S on 1/22/14.
//  Copyright (c) 2013 Advali. All rights reserved.
//

#import "PopoverViewController.h"
#import "BackgroundLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation PopoverViewController

@synthesize popoverTitle;

- (id)initWithFrame:(CGRect)frame withToolbar:(BOOL)showToolbar
{
    self = [super init];
    
    if (self) {
        // Initialization code
        self.view.frame = frame;
        [self.view setBackgroundColor:[UIColor clearColor]];
       
        // Add container
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, frame.size.width, frame.size.height+20)];
        [containerView setBackgroundColor:[UIColor clearColor]];
       // [containerView.layer setCornerRadius:5];
        containerView.clipsToBounds = YES;
        UIImageView *bgImgView=[[UIImageView alloc]initWithFrame:containerView.frame];
        bgImgView.image=[UIImage imageNamed:@"Raza_BGImage.png"];
        [containerView addSubview:bgImgView];
        if (showToolbar)
        {
            // Add toolbar
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, 64)];
            
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
           
            UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
            
            NSArray *items = [NSArray arrayWithObjects:flex, dismissButton, nil];
            [toolbar setItems:items];
            
            // Add title label
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(toolbar.frame.size.width/2 - 110, 20, 220, 44)];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
          
         //   titleLabel.backgroundColor = UIColorFromRGBA(215, 236, 250, 1);
         
            [titleLabel setFont:[UIFont fontWithName:@"SourceSansPro" size:18.0]];
            [titleLabel setTextColor:[UIColor whiteColor]];
            //titleLabel.textAlignment=NSTextAlignmentCenter;
            
             [toolbar addSubview:[self SetDoneButton]];
            [toolbar addSubview:titleLabel];

            [containerView addSubview:toolbar];
        }
        //toolbar.barTintColor = UIColorFromRGBA(239 , 239, 244, 1);
      //  UIImage *Image = [UIImage imageNamed:@"Color.png"];
        [toolbar setTintColor:[UIColor whiteColor]];
       // [[UIToolbar appearance]setBackgroundImage:Image  forToolbarPosition: UIToolbarPositionAny barMetrics: UIBarMetricsDefault];
        [UIToolbar appearance].barTintColor = [UIColor whiteColor];
        CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
        gradient.frame = toolbar.bounds;
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(0.0, 1.0);
        gradient.locations = @[@0.0,@1.0];
        [toolbar.layer insertSublayer:gradient atIndex:0];
        
        // Add content area (showToolbar ? 44 : 0)
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (showToolbar ? 64 : 0), containerView.frame.size.width, containerView.frame.size.height - (showToolbar ? 64 : 0))];
        [contentView setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:contentView];
               //[toolbar setBarStyle:UIBarStyleDefault];

        
        [self.view addSubview:containerView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withToolbar:YES];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, APP_FRAME.size.width, APP_FRAME.size.height)];
}

- (void)setPopoverTitle:(NSString *)popoverTitleVal
{
    popoverTitle = popoverTitleVal;
    
    [titleLabel setText:popoverTitle];
}

- (void)addPopoverContent:(UIViewController*)popoverContent
{
    popoverContentController = popoverContent;
    
    popoverContentController.view.frame = contentView.bounds;
    
    [self addChildViewController:popoverContentController];
    
    [popoverContentController didMoveToParentViewController:self];
    
    [contentView addSubview:popoverContentController.view];
}

- (void)presentInViewController:(UIViewController*)parentViewController
{
    if ([parentViewController.childViewControllers containsObject:self])
    	return;
    
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    
    [self didMoveToParentViewController:parentViewController];

    // Animation
    [popoverContentController beginAppearanceTransition:YES animated:NO];
    
    CGAffineTransform trans = CGAffineTransformMakeScale(0.01, 0.01);
    containerView.transform = trans;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         containerView.transform = CGAffineTransformScale(containerView.transform, 100.0, 100.0);
                     }
                     completion:^(BOOL finished) {
                         [popoverContentController endAppearanceTransition];
                     }
     ];
}

- (void)dismiss
{
    
    [popoverContentController beginAppearanceTransition:NO animated:NO];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         containerView.transform = CGAffineTransformScale(containerView.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                         [self.view removeFromSuperview];
                         
                         [popoverContentController endAppearanceTransition];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(UILabel*)SetDoneButton
{
    UILabel   *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-100, 20, 100, 44)];
    [titleLabel2 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel2 setBackgroundColor:[UIColor clearColor]];
    
    //   titleLabel.backgroundColor = UIColorFromRGBA(215, 236, 250, 1);
    titleLabel2.text=@"Dismiss";
    [titleLabel2 setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18.0]];
    [titleLabel2 setTextColor:[UIColor whiteColor]];
    return titleLabel2;
}
@end
