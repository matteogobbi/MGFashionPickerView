//
//  MGFashionPickerView.h
//  MGFashionPickerView
//
//  Created by Matteo Gobbi on 06/11/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGFashionPickerView;

#pragma mark - Delegate protocol
@protocol MGFashionPickerViewDelegate <NSObject>

@end

#pragma mark - Datasource protocol
@protocol MGFashionPickerViewDatasource <NSObject>

@required
- (NSUInteger)numberOfComponentsForPickerView:(MGFashionPickerView *)pickerView;
- (NSUInteger)pickerView:(MGFashionPickerView *)pickerView numberOfRowsForComponent:(NSUInteger)component;
- (NSString *)pickerView:(MGFashionPickerView *)pickerView textForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional
- (NSString *)pickerView:(MGFashionPickerView *)pickerView titleForComponent:(NSUInteger)component;
- (CGFloat)pickerView:(MGFashionPickerView *)pickerView rowsWidthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(MGFashionPickerView *)pickerView heightForComponent:(NSInteger)component;
- (UIColor *)selectionColorForPickerView:(MGFashionPickerView *)pickerView;

- (UIView *)pickerView:(MGFashionPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component __attribute__((unavailable));

@end

#pragma mark - MGFashionPickerView Interface
@interface MGFashionPickerView : UIView

@property (weak, nonatomic) id<MGFashionPickerViewDelegate> delegate;
@property (weak, nonatomic) id<MGFashionPickerViewDatasource> datasource;

@property (weak, nonatomic, readonly) UIScrollView *mainVerticalScrollView;

- (instancetype)init __attribute__((unavailable("Use -initWithFrame: instead")));

- (void)reloadData;

@end
