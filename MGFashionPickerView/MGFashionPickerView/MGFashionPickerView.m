//
//  MGFashionPickerView.m
//  MGFashionPickerView
//
//  Created by Matteo Gobbi on 06/11/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGFashionPickerView.h"

#define kMGPickerViewSelectionColor [UIColor blueColor];

static const CGFloat kMGPickerViewRowWidth = 80.0;
static const CGFloat kMGPickerViewComponentHeight = 40.0;
static const CGFloat kMGPickerViewComponentTitleHeight = 25.0;
static const CGFloat kMGPickerComponentMargin = 20.0;

static const CGFloat kMGPickerViewTitleFontSize = 16.0;
static NSString *const kMGPickerViewTitleFontName = @"Helevetica-Nueue";

@implementation MGFashionPickerView {
    BOOL considerComponentTitles_;
    
    UIScrollView *scrollView_;
    NSMutableArray *arrayComponentCollectionView_;
    
    NSUInteger numberOfComponent_;
    NSMutableArray *arrayComponentNumberOfRows_;
    NSMutableArray *arrayComponentHeights_;
    NSMutableArray *arrayComponentRowsWidth_;
    NSMutableArray *arrayComponentTitles_;
    UIColor *selectionColor_;
}

#pragma mark - Class and overriding methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mg_setDefaultValue];
        [self mg_constructPicker];
    }
    return self;
}

#pragma mark - Private methods
- (void)mg_setDefaultValue
{
#warning - To implement
}

- (void)mg_loadData
{
    //Get the number of components
    numberOfComponent_ = [self.datasource numberOfComponentsForPickerView:self];
    
    //Init the rows array and get the number of rows for each component
    arrayComponentNumberOfRows_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    for (NSUInteger i = 0; i < numberOfComponent_; i++) {
        arrayComponentNumberOfRows_[i] = @([self.datasource pickerView:self numberOfRowsForComponent:i]);
    }
    
    //Get the height of the component if is implemented the method
    arrayComponentHeights_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    if ([self.datasource respondsToSelector:@selector(pickerView:heightForComponent:)]) {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentHeights_[i] = @([self.datasource pickerView:self heightForComponent:i]);
        }
    } else {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentHeights_[i] = @(kMGPickerViewComponentHeight);
        }
    }
    
    //Get the width of rows in component if is implemented the method
    arrayComponentRowsWidth_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    if ([self.datasource respondsToSelector:@selector(pickerView:rowsWidthForComponent:)]) {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentRowsWidth_[i] = @([self.datasource pickerView:self rowsWidthForComponent:i]);
        }
    } else {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentRowsWidth_[i] = @(kMGPickerViewRowWidth);
        }
    }
    
    //Get title for components if is implemented the method
    if ((considerComponentTitles_ = [self.datasource respondsToSelector:@selector(pickerView:titleForComponent:)])) {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentTitles_[i] = [self.datasource pickerView:self titleForComponent:i];
        }
    }
    
    //Get the selection color
    if ([self.datasource respondsToSelector:@selector(selectionColorForPickerView:)]) {
        selectionColor_ = [self.datasource selectionColorForPickerView:self];
    } else {
        selectionColor_ = kMGPickerViewSelectionColor;
    }
}

- (void)mg_resetData
{
#warning - To implement
}

- (void)mg_constructPicker
{
    scrollView_ = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
    [self mg_configureMainScrollView];
    [self addSubview:scrollView_];
    
    //Get all datas from the datasource before constructing the view
    [self mg_loadData];
    
    //Construct the view
    CGFloat actualContentSizeHeight = 0.0;
    
    for (NSUInteger i = 0; i < numberOfComponent_; i++) {
        UIView *componentView = [self mg_configureComponent:i];
        componentView.frame = (CGRect){0, actualContentSizeHeight, componentView.frame.size.width, componentView.frame.size.height};
        
        [scrollView_ addSubview:componentView];
        
        actualContentSizeHeight += componentView.frame.size.height + ((i == numberOfComponent_-1) ? .0 : kMGPickerComponentMargin);
    }
    
    scrollView_.contentSize = (CGSize){scrollView_.frame.size.width, actualContentSizeHeight};
}

- (UIView *)mg_configureComponent:(NSUInteger)component
{
    UIView *componentView = [[UIView alloc] initWithFrame:(CGRect){0, 0, scrollView_.frame.size.width, 0}];
    
    CGFloat componentViewHeight = 0.0;
    
    //Consider the title if exists
    if (considerComponentTitles_) {
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0, 0, componentView.frame.size.width, kMGPickerViewComponentTitleHeight}];
        [self mg_configureDefaultLabel:label];
        label.text = arrayComponentTitles_[component];
        
        componentViewHeight += label.frame.size.height;
    }
    
    //Get the component height
    CGFloat componentHeight = [arrayComponentHeights_[component] floatValue];
    
    //Create the collectionView
    CGRect collectionViewRect = (CGRect){0.0, componentViewHeight, componentView.frame.size.width, componentHeight};
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect];
    [componentView addSubview:collectionView];
    componentViewHeight += collectionView.frame.size.height;
    
    [arrayComponentCollectionView_ addObject:collectionView];
    
    //Set the frame of the componentView
    componentView.frame = (CGRect){0, 0, componentView.frame.size.width, componentViewHeight};
    
    return componentView;
}

- (void)mg_configureMainScrollView
{
#warning - To implement
}

- (void)mg_configureDefaultLabel:(UILabel *)label
{
    label.font = [UIFont fontWithName:kMGPickerViewTitleFontName size:kMGPickerViewTitleFontSize];
    label.textColor = selectionColor_;
}

#pragma mark - Public methods
- (void)reloadData
{
    [self mg_resetData];
    [self mg_loadData];
}

#warning - Implement backgroundColor, selectionColor

@end
