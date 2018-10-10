//
//  RazaDatePickerView.h
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

@interface RazaDatePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong) NSString *selectedMonth;
@property (nonatomic, strong) NSString *selectedYear;
@property (nonatomic, strong) NSString *selfselectedMonth;
@property (nonatomic, strong) NSString *selfselectedYear;
-(void)selectToday;


@end
