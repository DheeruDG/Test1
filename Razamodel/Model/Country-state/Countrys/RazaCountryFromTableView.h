//
//  RazaCountryFromTableView.h
//  Raza
//
//  Created by Praveen S on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RazaCountryTableViewDelegate <NSObject>

-(void)selectedRowForCountry:(RazaCountryFromModel *)countryFromModel;

@end

@interface RazaCountryFromTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *records;
}

@property (weak, nonatomic) id <RazaCountryTableViewDelegate> countrydelegate;
@property (nonatomic)RazaCountryFromModel *countryModel;

-(id)initWithFrame:(CGRect)frame withDelegate:(id <RazaCountryTableViewDelegate>)countrydelegate;
@end
