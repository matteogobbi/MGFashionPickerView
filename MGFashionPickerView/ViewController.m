//
//  ViewController.m
//  MGFashionPickerView
//
//  Created by Matteo Gobbi on 06/11/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "ViewController.h"
#import "MGFashionPickerView.h"

@interface ViewController () <MGFashionPickerViewDatasource, MGFashionPickerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MGFashionPickerView *fashionPicker = [[MGFashionPickerView alloc] initWithFrame:CGRectMake(20, 20, 280, 250)];
    fashionPicker.datasource = self;
    fashionPicker.delegate = self;
    [self.view addSubview:fashionPicker];
}

- (NSUInteger)numberOfComponentsForPickerView:(MGFashionPickerView *)pickerView
{
    return 4;
}

- (NSUInteger)pickerView:(MGFashionPickerView *)pickerView numberOfRowsForComponent:(NSUInteger)component
{
    return 10;
}

- (NSString *)pickerView:(MGFashionPickerView *)pickerView titleForComponent:(NSUInteger)component
{
    return [NSString stringWithFormat:@"Title %lu", (unsigned long)component];
}

- (NSString *)pickerView:(MGFashionPickerView *)pickerView textForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
