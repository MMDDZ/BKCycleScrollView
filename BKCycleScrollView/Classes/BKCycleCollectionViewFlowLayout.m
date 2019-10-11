//
//  BKCycleCollectionViewFlowLayout.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleCollectionViewFlowLayout.h"

@implementation BKCycleCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width - self.itemInset.left - self.itemInset.right, self.collectionView.frame.size.height - self.itemInset.top - self.itemInset.bottom);
    self.minimumLineSpacing = self.itemSpace;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = self.itemInset;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    if (_layoutStyle == BKDisplayCellLayoutStyleNormal) {
        return array;
    }
    
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (!CGRectIntersectsRect(visiableRect, attributes.frame)) {
            continue;
        }
        
        CGFloat itemCenterX = attributes.center.x;
        CGFloat gap = fabs(itemCenterX - centerX);
//        除中间原大小外 其余缩放比例相同
//        CGFloat max_gap = self.minimumLineSpacing + self.itemSize.width;
//        if (gap > max_gap) {
//            gap = max_gap;
//        }
        
        CGFloat scale = 1 - (gap / (self.collectionView.frame.size.width/2)) * self.itemReduceScale;
        
        attributes.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
    }
    return array;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (!self.pagingEnabled) {
        return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    
    CGRect lastRect;
    lastRect.origin = self.collectionView.contentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2;
    
    NSArray * array = [self layoutAttributesForElementsInRect:lastRect];
    
    CGFloat adjustOffsetX = FLT_MAX;
    for (UICollectionViewLayoutAttributes * attributes in array) {
        if (adjustOffsetX == FLT_MAX) {
            adjustOffsetX = attributes.center.x - centerX;
        }else{
            CGFloat temp_adjustOffsetX = attributes.center.x - centerX;
            if (velocity.x == 0) {//速度为0时判断 哪个item离中心近
                if (fabs(temp_adjustOffsetX) < fabs(adjustOffsetX)) {
                    adjustOffsetX = temp_adjustOffsetX;
                }
            }else if (velocity.x > 0) {//往左划 选最大
                if (temp_adjustOffsetX > adjustOffsetX) {
                    adjustOffsetX = temp_adjustOffsetX;
                }
            }else if (velocity.x < 0) {//往右划 选最小
                if (temp_adjustOffsetX < adjustOffsetX) {
                    adjustOffsetX = temp_adjustOffsetX;
                }
            }
        }
    }
    
    CGFloat contentOffsetX = self.collectionView.contentOffset.x + adjustOffsetX;
    CGPoint targetContentOffset = CGPointMake(contentOffsetX, self.collectionView.contentOffset.y);

    return targetContentOffset;
}

@end
