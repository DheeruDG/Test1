//
//  raza_chat_imageViewController.h
//  Raza
//
//  Created by umenit on 8/22/15.
//  Copyright (c) 2015 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalnetworkclass.h"
#import "UICompositeView.h"
@interface raza_chat_imageViewController : UIViewController<UIScrollViewDelegate,UICompositeViewDelegate>
{
    NSMutableDictionary *dictofchatwallpaper;
    NSString *dictofchatwallpaperpath;
    UIView *containerViewmy;
}
-(void)setstrinmagearray:(NSArray*)strimage;
@property(nonatomic, strong)  UIImageView *imageView;
@property(nonatomic, strong)  NSArray *strofimg;

- (IBAction)bntbackClicked:(id)sender;
- (IBAction)btnchooseclicked:(id)sender;


@end
