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

static const CGFloat kMGPickerViewCollectionTextFontSize = 17.0;
static NSString *const kMGPickerViewCollectionTextFontName = @"HelveticaNeue-Bold";

static NSString *const kMGPickerViewCollectionCellIdentifier = @"CollectionCell";

static struct DatasourceResponds {
    unsigned int datasourceTitle:1;
    unsigned int datasourceComponentHeight:1;
    unsigned int datasourceItemWidth:1;
} datasourceResponds;

static UIColor *selectionColor;

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
    _label = [[UILabel alloc] initWithFrame:(CGRect){5.0, 0, self.frame.size.width-10.0, self.frame.size.height}];
    _label.font = [UIFont fontWithName:kMGPickerViewCollectionTextFontName size:kMGPickerViewCollectionTextFontSize];
    _label.textColor = kMGPickerViewDefaultTextColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

@end

#pragma mark - MGFashionPickerComponent class
@interface MGFashionPickerComponentView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
@private
    UILabel *label_;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSMutableArray *itemsText;
@property CGFloat componentHeight;
@property CGFloat itemWidth;
@property NSUInteger numberOfItems;

@end

@implementation MGFashionPickerComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemsText = [NSMutableArray new];
    }
    return self;
}

- (void)design
{
    CGFloat componentViewHeight = 0.0;
    
    //Consider the title if exists
    if (datasourceResponds.datasourceTitle) {
        label_ = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, kMGPickerViewComponentTitleHeight}];
        label_.font = [UIFont fontWithName:kMGPickerViewTitleFontName size:kMGPickerViewTitleFontSize];
        label_.textColor = selectionColor;
        label_.textAlignment = NSTextAlignmentCenter;
        label_.text = _title;
        [self addSubview:label_];
        
        componentViewHeight += label_.frame.size.height;
    }

    //Create the collectionView
    CGRect collectionViewRect = (CGRect){0.0, componentViewHeight, self.frame.size.width, _componentHeight};
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:layout];
    [self mg_configureDefaultCollectionView];
    
    [self addSubview:_collectionView];
    componentViewHeight += _collectionView.frame.size.height;
    
    //Set the frame of the componentView
    self.frame = (CGRect){0, 0, self.frame.size.width, componentViewHeight};
}

- (void)mg_configureDefaultCollectionView
{
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    CGFloat sideInset = self.bounds.size.width/2.0-_itemWidth/2.0;
    
    _collectionView.contentInset = (UIEdgeInsets){0, sideInset, 0, sideInset};
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MGFashionPickerViewCell class] forCellWithReuseIdentifier:kMGPickerViewCollectionCellIdentifier];
}

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
    return _numberOfItems;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth, _componentHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGFashionPickerViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kMGPickerViewCollectionCellIdentifier forIndexPath:indexPath];
    collectionViewCell.label.text = _itemsText[indexPath.row];
    collectionViewCell.label.textColor = (indexPath.row == _selectedItemIndex) ? selectionColor : kMGPickerViewDefaultTextColor;
    
    return collectionViewCell;
}

/////////////////////////////////////////////////////
//         SCROLLVIEW TO MANAGE SELECTION          //
/////////////////////////////////////////////////////

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        //Center value
        [self mg_centerValueForScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //Center value
    [self mg_centerValueForScrollView:scrollView];
}

#pragma mark - Private methods scrollView selection
//Center the value in the bar selector
- (void)mg_centerValueForScrollView:(UIScrollView *)scrollView {
    
    //Actual Offset
    CGFloat offset = scrollView.contentOffset.x + scrollView.contentInset.left;
    
    CGFloat mod = offset - (int)(offset/_itemWidth)*_itemWidth;
    
    CGFloat newOffset = (mod <= _itemWidth/2.0) ? offset-mod : offset+(_itemWidth-mod);
    
    NSUInteger itemIndex = (int)(newOffset/_itemWidth);
    
    //Center the cell
    itemIndex = (itemIndex < _numberOfItems) ? itemIndex : _numberOfItems-1;
    
    newOffset -= scrollView.contentInset.left;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        //Highlight the cell
        [self mg_highlightItemAtIndex:itemIndex];
    }];
    
    [scrollView setContentOffset:CGPointMake(newOffset, 0.0) animated:YES];
    
    [CATransaction commit];
}

//Dehighlight the last cell
- (void)mg_dehighlightLastCell {
    
}

//Highlight a cell
- (void)mg_highlightItemAtIndex:(NSUInteger)itemIndex {
    NSUInteger oldSelected = _selectedItemIndex;
    _selectedItemIndex = itemIndex;
    
    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldSelected inSection:0], [NSIndexPath indexPathForRow:itemIndex inSection:0]]];
    
}

@end


#pragma mark - MGFashionPickerView class
@interface MGFashionPickerView ()

@end

@implementation MGFashionPickerView {
    NSMutableArray *arrayComponent_;
    UIScrollView *scrollView_;
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

- (void)setDatasource:(id<MGFashionPickerViewDatasource>)datasource
{
    if (_datasource != datasource) {
        _datasource = datasource;
        
        datasourceResponds.datasourceTitle = [_datasource respondsToSelector:@selector(pickerView:titleForComponent:)];
        datasourceResponds.datasourceItemWidth = [_datasource respondsToSelector:@selector(pickerView:itemsWidthForComponent:)];
        datasourceResponds.datasourceComponentHeight = [_datasource respondsToSelector:@selector(pickerView:heightForComponent:)];
    }
}

#pragma mark - Private methods
- (void)mg_setDefaultValue
{
    //Empty ATM
}

- (void)mg_createComponents
{
    //Get the selection color
    if ([self.datasource respondsToSelector:@selector(selectionColorForPickerView:)]) {
        selectionColor = [self.datasource selectionColorForPickerView:self];
    } else {
        selectionColor = kMGPickerViewSelectionTextColor;
    }
    
    //Get the number of components
    NSUInteger numberOfComponent = [self.datasource numberOfComponentsForPickerView:self];
    
    //ScrollView content size height
    CGFloat actualContentSizeHeight = 0.0;
    
    //Configure each component
    for (NSUInteger i = 0; i < numberOfComponent; i++) {
        @autoreleasepool {
            MGFashionPickerComponentView *pickerComponent = [[MGFashionPickerComponentView alloc] initWithFrame:(CGRect){0, 0, scrollView_.frame.size.width, 0}];;
            pickerComponent.numberOfItems = [self.datasource pickerView:self numberOfItemsForComponent:i];
            pickerComponent.componentHeight = (datasourceResponds.datasourceComponentHeight) ? [self.datasource pickerView:self heightForComponent:i] : kMGPickerViewComponentHeight;
            pickerComponent.itemWidth = (datasourceResponds.datasourceItemWidth) ? [self.datasource pickerView:self itemsWidthForComponent:i] : kMGPickerViewItemWidth;
            pickerComponent.title = (datasourceResponds.datasourceTitle) ? [self.datasource pickerView:self titleForComponent:i] : nil;
            
            for (NSUInteger o = 0; o < pickerComponent.numberOfItems; o++) {
                [pickerComponent.itemsText addObject:[self.datasource pickerView:self textForItem:o forComponent:i]];
            }
            
            [pickerComponent design];
            
            [scrollView_ addSubview:pickerComponent];
            arrayComponent_[i] = pickerComponent;
            pickerComponent.frame = (CGRect){0, actualContentSizeHeight, pickerComponent.frame.size.width, pickerComponent.frame.size.height};
            
            actualContentSizeHeight += pickerComponent.frame.size.height + ((i == numberOfComponent-1) ? .0 : kMGPickerComponentMargin);
        }
    }

    //Set the scrollView content size
    scrollView_.contentSize = (CGSize){scrollView_.frame.size.width, actualContentSizeHeight};
}

- (void)mg_resetData
{
    [scrollView_ removeFromSuperview];
    
    scrollView_ = nil;
    arrayComponent_ = nil;
    selectionColor = nil;
}

- (void)mg_constructPicker
{
    scrollView_ = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
    [self mg_configureMainScrollView];
    [self addSubview:scrollView_];
    
    //Get all datas from the datasource before constructing the view
    [self mg_createComponents];
}

- (void)mg_configureMainScrollView
{
    scrollView_.bounces = NO;
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

@end
