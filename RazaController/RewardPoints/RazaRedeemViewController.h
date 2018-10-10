//
//  RazaRedeemViewController.h
//  Raza
//
//  Created by Praveen S on 12/2/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RazaPickerViewController.h"
#import "PopoverViewController.h"
#import "UICompositeView.h"
@interface RazaRedeemViewController : UIViewController <UITextFieldDelegate, RazaDataModelDelegate, RazaPickerViewDelegate,UICompositeViewDelegate>{
    
    NSArray *_redeemPoints;
    
    __weak IBOutlet UIButton *_redeemButton;
        
    RazaPickerViewController *_redeemPickerVC;
    
    PopoverViewController *_popoverRateList;
    
    __weak IBOutlet UIButton *_buttonAmount;
}

- (IBAction)actionSelectAmount:(id)sender;

- (IBAction)actionRedeemNow:(id)sender;
@end
