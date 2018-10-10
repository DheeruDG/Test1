//
//  RazaCountryTableView.h
//  Raza
//
//  Created by Praveen S on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RazaCountryTableViewDelegate <NSObject>

-(void)selectedRowForCountry:(NSString *)value;

@end

@interface RazaCountryTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
    NSIndexPath *selectedRow;
}

@property (weak, nonatomic) id <RazaCountryTableViewDelegate> countrydelegate;
@property (nonatomic)RazaCountryToModel *countryModel;

-(id)initWithFrame:(CGRect)frame withDelegate:(id <RazaCountryTableViewDelegate>)countrydelegate;
@end
