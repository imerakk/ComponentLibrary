//
//  HBBannerCollectionViewFlowLayout.m
//  demo
//
//  Created by liuchunxi on 2018/10/12.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import "GTBannerCollectionViewFlowLayout.h"

@implementation GTBannerCollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1.获取cell对应的attributes对象
    NSArray* arrayAttrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 2.计算整体的中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // 3.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
        // 3.1 计算每个cell的中心点距离
        CGFloat distance = ABS(attr.center.x - centerX);
        
        // 3.2 距离越大，缩放比越小，距离越小，缩放比越大
        CGFloat scale = 1 - (1 - self.scale) * (distance / (self.itemSize.width + self.minimumLineSpacing));
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        NSLog(@"%f", scale);
    }
    
    [[self.collectionView visibleCells] makeObjectsPerformSelector:@selector(setNeedsLayout)];
    [[self.collectionView visibleCells] makeObjectsPerformSelector:@selector(layoutIfNeeded)];
    
    return arrayAttrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
