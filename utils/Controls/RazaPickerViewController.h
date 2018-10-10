//
//  RazaPickerView.h
//  Raza
//
//  Created by Praveen S on 22/01/14.
//  Copyright (c) 2014 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RazaPickerViewDelegate

@required

-(void)razaPickerViewSelected:(NSString *)selectedValue;

@end

@interface RazaPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    UIPickerView *_razaPickerView;
    
    NSDictionary *_recordsInfo;
    NSArray *_keys;
    
    UIToolbar *_toolBarPicker;
    
    NSString *_selectedValue;
}

@property (weak) id<RazaPickerViewDelegate> razapickerdelegate;

-(id)initWithDataDictionary:(NSDictionary *)data;

@end
