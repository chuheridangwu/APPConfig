//
//  DSRPreviewFlowLayout.m
//  MLLive
//
//  Created by daiyufeng on 2020/10/14.
//  Copyright © 2020 TianGe. All rights reserved.
//

#import "DSRPreviewFlowLayout.h"

@implementation DSRPreviewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    CGFloat offsetAdjustment = MAXFLOAT;
    // collectionView落在屏幕中点的x坐标
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
         // 找出离中心点最近的
        
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    CGFloat activeDistance = 600.f; //垂直缩放除以系数
    CGFloat scaleFactor  = 0.5; //缩放系数  越大缩放越大
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat normalizedDistance = ABS(distance / activeDistance);
        CGFloat zoom = 1 - scaleFactor * normalizedDistance;
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        //透明度
        CGFloat alpha = 1 - normalizedDistance;
        attributes.alpha = alpha;
        //层级
        attributes.zIndex = 10 - normalizedDistance * 6;
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{ //滑动放大缩小  需要实时刷新layout
    return YES;
}

@end
