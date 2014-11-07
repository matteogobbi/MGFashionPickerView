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

static const CGFloat kMGPickerViewTitleFontSize = 14.0;
static NSString *const kMGPickerViewTitleFontName = @"HelveticaNeue";

static const CGFloat kMGPickerViewCollectionTextFontSize = 18.0;
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

#pragma mark - MGFashionPickerComponent class
@interface MGFashionPickerComponent ()

@end

@implementation MGFashionPickerComponent

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
    //Empty ATM
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
    if ([self.datasource respondsToSelector:@selector(pickerView:itemsWidthForComponent:)]) {
        for (NSUInteger i = 0; i < numberOfComponent_; i++) {
            arrayComponentItemsWidth_[i] = @([self.datasource pickerView:self itemsWidthForComponent:i]);
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
    [scrollView_ removeFromSuperview];
    
    scrollView_ = nil;
    arrayComponentCollectionView_ = nil;
    numberOfComponent_ = 0;
    arrayComponentNumberOfItems_ = nil;
    arrayComponentHeights_ = nil;
    arrayComponentItemsWidth_ = nil;
    arrayComponentTitles_ = nil;
    selectionColor_ = nil;
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
    
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:collectionView];
    CGFloat itemWidth = [arrayComponentItemsWidth_[component] floatValue];
    CGFloat sideInset = self.bounds.size.width/2.0-itemWidth/2.0;
    
    collectionView.contentInset = (UIEdgeInsets){0, sideInset, 0, sideInset};
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[MGFashionPickerViewCell class] forCellWithReuseIdentifier:kMGPickerViewCollectionCellIdentifier];
}

#pragma mark - Public methods
- (void)reloadData
{
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

/////////////////////////////////////////////////////
//         SCROLLVIEW TO MANAGE SELECTION          //
/////////////////////////////////////////////////////

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:componentDidEndDragging:willDecelerate:)]) {
        [self.delegate pickerView:self componentDidEndDragging:component willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:componentWillBeginDragging:)]) {
        [self.delegate pickerView:self componentWillBeginDragging:component];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //Center value
    //[self mg_centerValueForScrollView:scrollView];
}




#pragma mark - Private methods scrollView selection
//Center the value in the bar selector
- (void)mg_centerValueForScrollView:(UIScrollView *)scrollView {
    NSUInteger component = [arrayComponentCollectionView_ indexOfObject:scrollView];
    
    CGFloat itemWidth = [arrayComponentItemsWidth_[component] floatValue];
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.x;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    int mod = (int)offset%(int)itemWidth;
    float newValue = (mod >= itemWidth/2.0) ? offset+(itemWidth-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSUInteger itemIndex = (int)(newValue/itemWidth);
    
    //Center the cell
    if(itemIndex >= [arrayComponentNumberOfItems_[component] count]) {
        itemIndex = [arrayComponentNumberOfItems_[component] count]-1;
    }
    
    float newOffset = itemIndex*itemWidth;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        //Highlight the cell
        [self mg_highlightItemAtIndex:itemIndex forComponent:component];
    }];
    
    [scrollView setContentOffset:CGPointMake(newOffset, 0.0) animated:YES];
    
    [CATransaction commit];
}

//Dehighlight the last cell
- (void)mg_dehighlightLastCell {

}

//Highlight a cell
- (void)mg_highlightItemAtIndex:(NSUInteger)itemIndex forComponent:(NSUInteger)component {
    UICollectionView *collectionView = [arrayComponentCollectionView_ objectAtIndex:component];
    
    MGFashionPickerViewCell *collectionCell = (MGFashionPickerViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
    collectionCell.label.textColor = selectionColor_;
}

@end
