//
//  HBScrollBannerView.m
//  demo
//
//  Created by liuchunxi on 2018/10/12.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import "GTScrollBannerView.h"
#import "GTBannerCollectionViewFlowLayout.h"
#import "GTBannerCollectionViewCell.h"
#import "GTBannerPageControlView.h"

const CGFloat KControlViewHeight = 5.0;
const CGFloat KControlViewMarginTop = 12.0;

@interface GTScrollBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GTBannerPageControlView *controlView;
@property (nonatomic, strong) GTBannerCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GTScrollBannerView

#pragma mark - public method
+ (instancetype)scrollBannerViewWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images {
    GTScrollBannerView *bannerView = [[GTScrollBannerView alloc] initWithFrame:frame images:images];
    return bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSpacing = 0.0;
        self.autoScrollDelayTime = 3.0;
        self.itemWidth = [UIScreen mainScreen].bounds.size.width;
        self.images = images;
        [self addSubview:self.collectionView];
        
        if (images.count > 1) {
            [self addSubview:self.controlView];
        }
    }
    
    return self;
}

- (void)refreshView {
    if (self.images.count > 0) {
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
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
    if (self.images.count > 1) {
        NSInteger nextRow = (self.currentIndexPath.row + 1) % self.images.count;
        self.currentIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:self.currentIndexPath.section];
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)startTimer {
    if (![self.timer isValid]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollDelayTime target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - getter && setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - KControlViewHeight - KControlViewMarginTop) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.clipsToBounds = NO;
        [_collectionView registerClass:[GTBannerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GTBannerCollectionViewCell class])];
    }
    return _collectionView;
}

- (UIView *)controlView {
    if (!_controlView) {
        _controlView = [[GTBannerPageControlView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - KControlViewHeight, self.frame.size.width, KControlViewHeight) indexCount:self.images.count currentIndex:0];
    }
    
    return _controlView;
}

- (GTBannerCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[GTBannerCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.scale = 0.9;
    }
    
    return _flowLayout;
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.collectionView.frame.size.height);
    self.flowLayout.minimumLineSpacing = self.itemSpacing - self.flowLayout.itemSize.width * (1 - _flowLayout.scale) * 0.5;
    
    CGFloat edgeInsets = (self.frame.size.width - itemWidth) / 2;
    if (edgeInsets > 0) {
        _collectionView.contentInset = UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    self.flowLayout.minimumLineSpacing = self.itemSpacing - self.flowLayout.itemSize.width * (1 - _flowLayout.scale) * 0.5;
}

- (void)setAutoScrollEnable:(BOOL)autoScrollEnable {
    _autoScrollEnable = autoScrollEnable;
    
    if (autoScrollEnable) {
        [self startTimer];
    }
    else {
        [self stopTimer];
    }
}

#pragma mark - uicollection datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTBannerCollectionViewCell class]) forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    cell.cornerRadius = 10;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

#pragma mark - uicollection delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger maxIndex = self.images.count - 1;
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
       self.currentIndexPath.row < self.images.count &&
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
    if (self.images.count > 1) {
        CGFloat currentProgress = (scrollView.contentOffset.x + scrollView.contentInset.left) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
        self.controlView.progress = currentProgress;
    }
}

@end
