//
//  HBScrollBannerView.m
//  demo
//
//  Created by liuchunxi on 2018/10/12.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import "GTCarouselView.h"
#import "GTCarouselCollectionViewFlowLayout.h"
#import "GTCarouselCollectionViewCell.h"
#import "GTCarouselPageControlView.h"
#import "GTTimer.h"

const CGFloat KControlViewHeight = 5.0;
const CGFloat KControlViewMarginTop = 12.0;

@interface GTCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GTCarouselPageControlView *controlView;
@property (nonatomic, strong) GTCarouselCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) GTTimer *timer;

@end

@implementation GTCarouselView

#pragma mark - public method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _autoScrollDelayTime = 3.0;
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - KControlViewHeight - KControlViewMarginTop);
    self.controlView.frame = CGRectMake(0, self.bounds.size.height - KControlViewHeight, self.frame.size.width, KControlViewHeight);
    CGFloat edgeInsets = (self.frame.size.width - self.itemWidth) / 2;
    if (edgeInsets > 0) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
    }
    
    if (self.currentIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)refreshView {
    if (self.pageCount > 0) {
        [self.collectionView reloadData];
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (void)registerCellClass:(Class)itemClass forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.collectionView registerClass:itemClass forCellWithReuseIdentifier:reuseIdentifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

#pragma mark - private method
- (void)adjustErrorCell:(BOOL)isScroll {
    NSArray <NSIndexPath *> *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSMutableArray <UICollectionViewLayoutAttributes *> *attriArr = [NSMutableArray arrayWithCapacity:indexPaths.count];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attri = [self.collectionView layoutAttributesForItemAtIndexPath:obj];
        [attriArr addObject:attri];
    }];
    CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame) * 0.5;
    __block CGFloat minSpace = MAXFLOAT;
    [attriArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(ABS(minSpace) > ABS(obj.center.x - centerX)) {
            minSpace = obj.center.x - centerX;
            self.currentIndexPath = obj.indexPath;
        }
    }];
    if(isScroll) {
        [self scrollViewWillBeginDecelerating:self.collectionView];
    }
}

- (void)autoScroll {
    if (self.pageCount > 1) {
        NSInteger nextRow = (self.currentIndexPath.row + 1) % self.pageCount;
        self.currentIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:self.currentIndexPath.section];
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)startTimer {
    if (self.autoScrollDelayTime == 0) return;
    if (self.timer && self.timer.timerInterval == self.autoScrollDelayTime) return;
    
    [self stopTimer];
    self.timer = [GTTimer timerWithTimerInterval:self.autoScrollDelayTime target:self selector:@selector(autoScroll) repeats:YES];
}

- (void)stopTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSInteger)pageCount {
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfItemsInCarouselView:)]) {
        return [self.datasource numberOfItemsInCarouselView:self];
    }
    
    return 0;
}

#pragma mark - getter && setter
- (void)setDatasource:(id<GTCarouselViewDataSource>)datasource {
    _datasource = datasource;
    
    if (self.controlView) {
        [self.controlView removeFromSuperview];
    }
    
    if (self.pageCount >= 1) {
        self.controlView = [[GTCarouselPageControlView alloc] initWithFrame:CGRectZero indexCount:self.pageCount currentIndex:0];
        [self addSubview:self.controlView];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - KControlViewHeight - KControlViewMarginTop) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[GTCarouselCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GTCarouselCollectionViewCell class])];
    }
    return _collectionView;
}

- (GTCarouselCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[GTCarouselCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.scale = 0.9;
    }
    
    return _flowLayout;
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    
    self.flowLayout.itemWidth = itemWidth;
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    
    self.flowLayout.itemSpacing = itemSpacing;
}

- (void)setAutoScrollEnable:(BOOL)autoScrollEnable {
    _autoScrollEnable = autoScrollEnable;
    
    if (_autoScrollEnable) {
        [self startTimer];
    }
    else {
        [self stopTimer];
    }
}

- (void)setAutoScrollDelayTime:(CGFloat)autoScrollDelayTime {
    _autoScrollDelayTime = autoScrollDelayTime;
    
    if (self.autoScrollEnable) {
        [self startTimer];
    }
}

#pragma mark - uicollection datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [UICollectionViewCell new];
    if ([self.datasource respondsToSelector:@selector(carouselView:cellForRowAtIndex:)]) {
        cell =  [self.datasource carouselView:self cellForRowAtIndex:indexPath.row];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageCount;
}

#pragma mark - uicollection delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger maxIndex = self.pageCount - 1;
    NSInteger minIndex = 0;
    
    if (velocity.x > 0 && self.currentIndexPath.row == maxIndex) {
        return;
    }
    
    if (velocity.x < 0 && self.currentIndexPath.row == minIndex) {
        return;
    }

    if(velocity.x > 0) {
        //左滑,下一张
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:self.currentIndexPath.section];
    }
    else if (velocity.x < 0) {
        //右滑,上一张
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row - 1 inSection:self.currentIndexPath.section];
    }
    else if (velocity.x == 0) {
        [self adjustErrorCell:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(self.currentIndexPath != nil &&
       self.currentIndexPath.row < self.pageCount &&
       self.currentIndexPath.row >= 0) {
        // 中间一张轮播,居中显示
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.autoScrollEnable) {
        [self startTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageCount > 1) {
        CGFloat currentProgress = (scrollView.contentOffset.x + scrollView.contentInset.left) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
        
        if (!isnan(currentProgress)) {
            self.controlView.progress = currentProgress;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectedItemAtIndex:)]) {
        [self.delegate carouselView:self didSelectedItemAtIndex:indexPath.row];
    }
}

@end
