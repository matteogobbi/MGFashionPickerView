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
    
    fashionPicker = [[MGFashionPickerView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.height-400.0)];
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

- (NSString *)pickerView:(MGFashionPickerView *)pickerView textForItem:(NSInteger)item forComponent:(NSInteger)component
{
    NSString *value = @"";
    
    switch (component) {
        case 0:
            
            value = [NSString stringWithFormat:@"%ld", 18+item];
            break;
            
        case 1:
            switch (item) {
                case 0:
                    
                    value = @"Italy";
                    break;
                
                case 1:
                    
                    value = @"UK";
                    break;
                    
                case 2:
                    
                    value = @"USA";
                    break;
                    
                case 3:
                    
                    value = @"Australia";
                    break;
                    
                case 4:
                    
                    value = @"Germany";
                    break;
                    
                default:
                    value = @"value";
                    break;
            }
            
            break;
        
        case 2:
            switch (item) {
                case 0:
                    
                    value = @"Italian";
                    break;
                    
                case 1:
                    
                    value = @"English";
                    break;
                    
                case 2:
                    
                    value = @"French";
                    break;
                    
                case 3:
                    
                    value = @"Spanish";
                    break;
                    
                case 4:
                    
                    value = @"Portoguese";
                    break;
                    
                default:
                    value = @"value";
                    break;
            }
            
            break;
            
        default:
            value = @"value";
            break;
    }
    
    return value;
}

- (NSString *)pickerView:(MGFashionPickerView *)pickerView titleForComponent:(NSUInteger)component
{
    NSString *value = @"";
    
    switch (component) {
        case 0:
            value = @"Age";
            break;
        case 1:
            value = @"From";
            break;
        case 2:
            value = @"Language";
            break;
        default:
            value = @"Title";
            break;
    }
    
    return value;
}

- (void)pickerView:(MGFashionPickerView *)pickerView didSelectItem:(NSUInteger)item forComponent:(NSUInteger)component
{
    NSLog(@"COMPONENT: %lu; ITEM: %lu", (unsigned long)component, (unsigned long)item);
}

- (UIColor *)selectionColorForPickerView:(MGFashionPickerView *)pickerView
{
    return [UIColor colorWithRed:62.0/255.0 green:116.0/255.0 blue:1.0 alpha:1.0];
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
