//
//  MGFashionPickerView.h
//  MGFashionPickerView
//
//  Created by Matteo Gobbi on 06/11/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGFashionPickerView, MGFashionPickerComponentView;

#pragma mark - MGFashionPickerViewCell class
@interface MGFashionPickerViewCell : UICollectionViewCell

@property (strong, nonatomic, readonly) UILabel *label;

@end


#pragma mark - MGFashionPickerComponentView Delegate protocol
@protocol MGFashionPickerComponentViewDelegate <NSObject>

@optional
- (void)pickerComponentView:(MGFashionPickerComponentView *)componentView didSelectItem:(NSUInteger)item;

@end


@interface MGFashionPickerComponentView : UIView

@property (readonly) NSUInteger selectedItemIndex;

@property (weak, nonatomic) id<MGFashionPickerComponentViewDelegate> delegate;

@end

#pragma mark - Delegate protocol
@protocol MGFashionPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(MGFashionPickerView *)pickerView didSelectItem:(NSUInteger)item forComponent:(NSUInteger)component;

@end

#pragma mark - Datasource protocol
@protocol MGFashionPickerViewDatasource <NSObject>

@required
- (NSUInteger)numberOfComponentsForPickerView:(MGFashionPickerView *)pickerView;
- (NSUInteger)pickerView:(MGFashionPickerView *)pickerView numberOfItemsForComponent:(NSUInteger)component;
- (NSString *)pickerView:(MGFashionPickerView *)pickerView textForItem:(NSInteger)item forComponent:(NSInteger)component;

@optional
- (NSString *)pickerView:(MGFashionPickerView *)pickerView titleForComponent:(NSUInteger)component;
- (CGFloat)pickerView:(MGFashionPickerView *)pickerView itemsWidthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(MGFashionPickerView *)pickerView heightForComponent:(NSInteger)component;
- (UIColor *)selectionColorForPickerView:(MGFashionPickerView *)pickerView;

- (UIView *)pickerView:(MGFashionPickerView *)pickerView viewForItem:(NSInteger *)item forComponent:(NSInteger)component __attribute__((unavailable));

@end

#pragma mark - MGFashionPickerView Interface
@interface MGFashionPickerView : UIView

@property (weak, nonatomic) id<MGFashionPickerViewDelegate> delegate;
@property (weak, nonatomic) id<MGFashionPickerViewDatasource> datasource;

@property (weak, nonatomic, readonly) UIScrollView *mainVerticalScrollView;

- (instancetype)init __attribute__((unavailable("Use -initWithFrame: instead")));

- (void)reloadData;

@end
