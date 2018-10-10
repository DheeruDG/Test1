//
//  RazaPickerView.m
//  Raza
//
//  Created by Praveen S on 22/01/14.
//  Copyright (c) 2014 Raza. All rights reserved.
//

#import "RazaPickerViewController.h"
#import "BackgroundLayer.h"
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHIGHT  [UIScreen mainScreen].bounds.size.height
@implementation RazaPickerViewController

#pragma mark -
#pragma mark init methods

-(id)initWithDataDictionary:(NSDictionary *)data {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    _recordsInfo = data;
    _keys = [_recordsInfo allKeys];
    
    _keys = [_keys sortedArrayUsingFunction:floatSort context:NULL];
    
    _razaPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (SCREENHIGHT-272)/2, SCREENWIDTH, 250)];

    _toolBarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];

    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18]];
    
    button.frame=CGRectMake(SCREENWIDTH-60, 20, 50, 44);
    [button addTarget:self action:@selector(doneButtonAction:)  forControlEvents:UIControlEventTouchUpInside];
    
   // UIBarButtonItem* doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.view addSubview:button];
    _toolBarPicker.items = [NSArray arrayWithObjects:flex, nil];
    
    CAGradientLayer *gradient = [BackgroundLayer navHeaderGradient];
    gradient.frame = _toolBarPicker.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    gradient.locations = @[@0.0,@1.0];
    [_toolBarPicker.layer insertSublayer:gradient atIndex:0];
    
    return  self;
}

#pragma mark - 
#pragma mark View methods

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT);
    self.view.backgroundColor = [UIColor whiteColor];
    _razaPickerView.delegate = self;
    [self.view addSubview:_toolBarPicker];
    [self.view addSubview:_razaPickerView];
}

#pragma mark -
#pragma mark UIPickerViewDatasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_recordsInfo count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [_recordsInfo objectForKey:[_keys objectAtIndex:row]];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectedValue = [_recordsInfo objectForKey:[_keys objectAtIndex:row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 60.0f;
}

#pragma mark -
#pragma mark Button action methods

-(void)doneButtonAction:(UIBarButtonItem *)sender {
    
    if (!_selectedValue) {
        _selectedValue = [_recordsInfo objectForKey:[_keys objectAtIndex:0]];
    }
    
    [self.razapickerdelegate razaPickerViewSelected:_selectedValue];
}

NSInteger floatSort(id num1, id num2, void *context)
{
    float v1 = [num1 floatValue];
    float v2 = [num2 floatValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

@end
