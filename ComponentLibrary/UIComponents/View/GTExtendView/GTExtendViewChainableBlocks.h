//
//  GTExtendViewChainableBlocks.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/5.
//  Copyright © 2018年 imera. All rights reserved.
//

#ifndef GTExtendViewChainableBlocks_h
#define GTExtendViewChainableBlocks_h

@class GTExtendView;

typedef GTExtendView *(^GTExtendViewChainableFloat)(CGFloat f);
#define GTExtendViewChainableFloat(f) ^GTExtendView * (CGFloat f)

typedef GTExtendView *(^GTExtendViewChainableSize)(CGSize size);
#define GTExtendViewChainableSize(size) ^GTExtendView * (CGSize size)

typedef GTExtendView *(^GTExtendViewChainableColor)(CGColorRef color);
#define GTExtendViewChainableColor(color) ^GTExtendView * (CGColorRef color)

typedef GTExtendView *(^GTExtendViewChainablePoint)(CGPoint point);
#define GTExtendViewChainablePoint(point) ^GTExtendView * (CGPoint point)

typedef GTExtendView *(^GTExtendViewChainableArray)(NSArray *array);
#define GTExtendViewChainableArray(array) ^GTExtendView * (NSArray *array)

typedef GTExtendView *(^GTExtendViewChainablePath)(CGPathRef path);
#define GTExtendViewChainablePath(path) ^GTExtendView * (CGPathRef path)

#endif /* GTExtendViewChainableBlocks_h */
