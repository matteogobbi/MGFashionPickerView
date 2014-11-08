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

@implementation ViewController {
    MGFashionPickerView *fashionPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    fashionPicker = [[MGFashionPickerView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, self.view.bounds.size.height-250.0)];
    fashionPicker.datasource = self;
    fashionPicker.delegate = self;
    [self.view addSubview:fashionPicker];
    
    [fashionPicker reloadData];
    
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    reloadButton.backgroundColor = [UIColor redColor];
    [reloadButton setTitle:@"RELOAD" forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton];
}

- (NSUInteger)numberOfComponentsForPickerView:(MGFashionPickerView *)pickerView
{
    return 20;
}

- (NSUInteger)pickerView:(MGFashionPickerView *)pickerView numberOfItemsForComponent:(NSUInteger)component
{
    return 10;
}

- (NSString *)pickerView:(MGFashionPickerView *)pickerView textForItem:(NSInteger)Item forComponent:(NSInteger)component
{
    return @"Text";
}

- (NSString *)pickerView:(MGFashionPickerView *)pickerView titleForComponent:(NSUInteger)component
{
    return [NSString stringWithFormat:@"Title %lu", (unsigned long)component];
}

- (void)pickerView:(MGFashionPickerView *)pickerView didSelectItem:(NSUInteger)item forComponent:(NSUInteger)component
{
    NSLog(@"COMPONENT: %lu; ITEM: %lu", (unsigned long)component, (unsigned long)item);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload
{
    [fashionPicker reloadData];
}

@end
