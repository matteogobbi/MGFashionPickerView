//
//  MGFashionPickerView.m
//  MGFashionPickerView
//
//  Created by Matteo Gobbi on 06/11/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGFashionPickerView.h"

#define kMGPickerViewDefaultTextColor [UIColor blackColor]
#define kMGPickerViewSelectionTextColor [UIColor blueColor]

static const CGFloat kMGPickerViewItemWidth = 80.0;
static const CGFloat kMGPickerViewComponentHeight = 40.0;
static const CGFloat kMGPickerViewComponentTitleHeight = 25.0;
static const CGFloat kMGPickerComponentMargin = 20.0;

static const CGFloat kMGPickerViewTitleFontSize = 15.0;
static NSString *const kMGPickerViewTitleFontName = @"HelveticaNeue";

static const CGFloat kMGPickerViewCollectionTextFontSize = 16.0;
static NSString *const kMGPickerViewCollectionTextFontName = @"HelveticaNeue-Bold";

static NSString *const kMGPickerViewCollectionCellIdentifier = @"CollectionCell";


#pragma mark - MGFashionPickerViewCell class
@interface MGFashionPickerViewCell ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation MGFashionPickerViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mg_initialize];
    }
    return self;
}

- (void)mg_initialize
{
    _label = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
    _label.font = [UIFont fontWithName:kMGPickerViewCollectionTextFontName size:kMGPickerViewCollectionTextFontSize];
    _label.textColor = kMGPickerViewDefaultTextColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

@end


#pragma mark - MGFashionPickerView class
@interface MGFashionPickerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MGFashionPickerView {
    BOOL considerComponentTitles_;
    
    UIScrollView *scrollView_;
    NSMutableArray *arrayComponentCollectionView_;
    
    NSUInteger numberOfComponent_;
    NSMutableArray *arrayComponentNumberOfItems_;
    NSMutableArray *arrayComponentHeights_;
    NSMutableArray *arrayComponentItemsWidth_;
    NSMutableArray *arrayComponentTitles_;
    UIColor *selectionColor_;
}


/////////////////////////////////////////////////////
//           ASPECT AND MAIN FUNCTIONS             //
/////////////////////////////////////////////////////

#pragma mark - Class and overriding methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mg_setDefaultValue];
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
    
    //Init the Items array and get the number of Items for each component
    arrayComponentNumberOfItems_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    for (NSUInteger i = 0; i < numberOfComponent_; i++) {
        arrayComponentNumberOfItems_[i] = @([self.datasource pickerView:self numberOfItemsForComponent:i]);
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
    
    //Get the width of Items in component if is implemented the method
    arrayComponentItemsWidth_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    if ([self.datasource respondsToSelector:@selector(pickerView:ItemsWidthForComponent:)]) {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentItemsWidth_[i] = @([self.datasource pickerView:self ItemsWidthForComponent:i]);
        }
    } else {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentItemsWidth_[i] = @(kMGPickerViewItemWidth);
        }
    }
    
    //Get title for components if is implemented the method
    if ((considerComponentTitles_ = [self.datasource respondsToSelector:@selector(pickerView:titleForComponent:)])) {
        arrayComponentTitles_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentTitles_[i] = [self.datasource pickerView:self titleForComponent:i];
        }
    }
    
    //Get the selection color
    if ([self.datasource respondsToSelector:@selector(selectionColorForPickerView:)]) {
        selectionColor_ = [self.datasource selectionColorForPickerView:self];
    } else {
        selectionColor_ = kMGPickerViewSelectionTextColor;
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
    
    arrayComponentCollectionView_ = [NSMutableArray arrayWithCapacity:numberOfComponent_];
    
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
        [self mg_configureDefaultTitleLabel:label];
        label.text = arrayComponentTitles_[component];
        [componentView addSubview:label];
        
        componentViewHeight += label.frame.size.height;
    }
    
    //Get the component height
    CGFloat componentHeight = [arrayComponentHeights_[component] floatValue];
    
    //Create the collectionView
    CGRect collectionViewRect = (CGRect){0.0, componentViewHeight, componentView.frame.size.width, componentHeight};
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:layout];
    [arrayComponentCollectionView_ addObject:collectionView];
    [self mg_configureDefaultCollectionView:collectionView];
    
    [componentView addSubview:collectionView];
    componentViewHeight += collectionView.frame.size.height;
    
    //Set the frame of the componentView
    componentView.frame = (CGRect){0, 0, componentView.frame.size.width, componentViewHeight};
    
    return componentView;
}

- (void)mg_configureMainScrollView
{
    scrollView_.bounces = NO;
}

- (void)mg_configureDefaultTitleLabel:(UILabel *)label
{
    label.font = [UIFont fontWithName:kMGPickerViewTitleFontName size:kMGPickerViewTitleFontSize];
    label.textColor = selectionColor_;
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)mg_configureDefaultCollectionView:(UICollectionView *)collectionView
{
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[MGFashionPickerViewCell class] forCellWithReuseIdentifier:kMGPickerViewCollectionCellIdentifier];
}

#pragma mark - Public methods
- (void)reloadData
{
#warning - To review
    [self mg_resetData];
    [self mg_constructPicker];
}

- (UIScrollView *)mainVerticalScrollView
{
    return scrollView_;
}

#warning - Implement backgroundColor, selectionColor, textColor (use a component object including title and collectionView)


/////////////////////////////////////////////////////
//      COLLECTION VIEW DELEGATE/DATASOURCE        //
/////////////////////////////////////////////////////

#pragma mark - UICollectionView Delegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:collectionView];
    return [arrayComponentNumberOfItems_[component] integerValue];;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:collectionView];
    return CGSizeMake([arrayComponentItemsWidth_[component] floatValue], [arrayComponentHeights_[component] floatValue]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:collectionView];
    
    MGFashionPickerViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kMGPickerViewCollectionCellIdentifier forIndexPath:indexPath];
    
    collectionViewCell.label.text = [self.datasource pickerView:self textForItem:indexPath.row forComponent:component];
    
    return collectionViewCell;
}

@end
