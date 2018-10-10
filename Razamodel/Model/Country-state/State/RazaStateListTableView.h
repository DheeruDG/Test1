//
//  RazaStateListTableView.h
//  Raza
//
//  Created by Praveen S on 04/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RazaStateTableViewDelegate <NSObject>

-(void)selectedRowForState:(NSString *)value withKey:(NSString *)key;

-(void)updateStateInfoAndShowStateList:(NSString *)stateID withStateName:(NSString *)stateName;

@end


@interface RazaStateListTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
    NSDictionary *_states;
    NSArray *_keys;
    
}

@property (weak, nonatomic) id <RazaStateTableViewDelegate> statedelegate;
-(id)initWithFrame:(CGRect)frame withDelegate:(id <RazaStateTableViewDelegate>)statedelegate;

@end
