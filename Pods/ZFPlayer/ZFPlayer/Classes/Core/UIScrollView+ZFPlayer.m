//
//  UIScrollView+ZFPlayer.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIScrollView+ZFPlayer.h"
#import <objc/runtime.h>
#import "ZFReachabilityManager.h"
#import "ZFPlayer.h"
#import "ZFKVOController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface UIScrollView ()

@property (nonatomic) CGFloat zf_lastOffsetY;
@property (nonatomic) CGFloat zf_lastOffsetX;
@property (nonatomic) ZFPlayerScrollDerection zf_scrollDerection;

@end

@implementation UIScrollView (ZFPlayer)

#pragma mark - private method

- (void)_scrollViewDidStopScroll {
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.zf_scrollViewDidStopScrollCallback) self.zf_scrollViewDidStopScrollCallback(indexPath);
        if (self.scrollViewDidStopScroll) self.scrollViewDidStopScroll(indexPath);
    }];
}

- (void)_scrollViewBeginDragging {
    if (self.zf_scrollViewDerection == ZFPlayerScrollViewDerectionVertical) {
        self.zf_lastOffsetY = self.contentOffset.y;
    } else {
        self.zf_lastOffsetX = self.contentOffset.x;
    }
}

/**
  The percentage of scrolling processed in vertical scrolling.
 */
- (void)_scrollViewScrollingDerectionVertical {
    CGFloat offsetY = self.contentOffset.y;
    self.zf_scrollDerection = (offsetY - self.zf_lastOffsetY > 0) ? ZFPlayerScrollDerectionUp : ZFPlayerScrollDerectionDown;
    self.zf_lastOffsetY = offsetY;
    
    // Avoid being paused the first time you play it.
    if (self.contentOffset.y < 0) return;
    if (!self.zf_playingIndexPath) return;
    
    UIView *cell = [self zf_getCellForIndexPath:self.zf_playingIndexPath];
    if (!cell) {
        if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        return;
    }
    UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView top to scrollView top space.
    CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
    /// playerView bottom to scrollView bottom space.
    CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.zf_scrollDerection == ZFPlayerScrollDerectionUp) { /// Scroll up
        /// Player is disappearing.
        if (topSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -topSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (topSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (topSpacing > 0 && topSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(topSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (topSpacing <= contentInsetHeight && topSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
        
    } else if (self.zf_scrollDerection == ZFPlayerScrollDerectionDown) { /// Scroll Down
        /// Player is disappearing.
        if (bottomSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -bottomSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (bottomSpacing > 0 && bottomSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(bottomSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (bottomSpacing <= contentInsetHeight && bottomSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
    }
}

/**
 The percentage of scrolling processed in horizontal scrolling.
 */
- (void)_scrollViewScrollingDerectionHorizontal {
    CGFloat offsetX = self.contentOffset.x;
    self.zf_scrollDerection = (offsetX - self.zf_lastOffsetX > 0) ? ZFPlayerScrollDerectionLeft : ZFPlayerScrollDerectionRight;
    self.zf_lastOffsetX = offsetX;
    
    // Avoid being paused the first time you play it.
    if (self.contentOffset.x < 0) return;
    if (!self.zf_playingIndexPath) return;
    
    UIView *cell = [self zf_getCellForIndexPath:self.zf_playingIndexPath];
    if (!cell) {
        if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        return;
    }
    UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView left to scrollView left space.
    CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
    /// playerView bottom to scrollView right space.
    CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetWidth = CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.zf_scrollDerection == ZFPlayerScrollDerectionLeft) { /// Scroll left
        /// Player is disappearing.
        if (leftSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -leftSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (leftSpacing <= 0 && leftSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (leftSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (leftSpacing > 0 && leftSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(leftSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (leftSpacing <= contentInsetWidth && leftSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
        
    } else if (self.zf_scrollDerection == ZFPlayerScrollDerectionRight) { /// Scroll right
        /// Player is disappearing.
        if (rightSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -rightSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (rightSpacing <= 0 && rightSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (rightSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (rightSpacing > 0 && rightSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(rightSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (rightSpacing <= contentInsetWidth && rightSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
    }
}

/**
 Find the playing cell while the scrollDerection is vertical.
 */
- (void)_findCorrectCellWhenScrollViewDerectionVertical:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.y <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.y <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = collectionView.indexPathsForVisibleItems.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.zf_scrollDerection == ZFPlayerScrollDerectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidY = CGRectGetHeight(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(self.frame);
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        NSIndexPath *indexPath = [self zf_getIndexPathForCell:cell];
        /// Play when the video playback section is visible.
        if ((topSpacing >= -CGRectGetHeight(rect)/2) && (bottomSpacing >= -CGRectGetHeight(rect)/2)) {
            /// If you have a cell that is playing, stop the traversal.
            if (self.zf_playingIndexPath) {
                indexPath = self.zf_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.zf_shouldPlayIndexPath = finalIndexPath;
    }
}

/**
 Find the playing cell while the scrollDerection is horizontal.
 */
- (void)_findCorrectCellWhenScrollViewDerectionHorizontal:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.x <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.x <= 0 && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = collectionView.indexPathsForVisibleItems.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.zf_playingIndexPath || [indexPath compare:self.zf_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.zf_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.zf_scrollDerection == ZFPlayerScrollDerectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidX = CGRectGetWidth(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
        CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(self.frame);
        CGFloat centerSpacing = ABS(scrollViewMidX - CGRectGetMidX(rect));
        NSIndexPath *indexPath = [self zf_getIndexPathForCell:cell];
        /// Play when the video playback section is visible.
        if ((leftSpacing >= -CGRectGetWidth(rect)/2) && (rightSpacing >= -CGRectGetWidth(rect)/2)) {
            /// If you have a cell that is playing, stop the traversal.
            if (self.zf_playingIndexPath) {
                indexPath = self.zf_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.zf_shouldPlayIndexPath = finalIndexPath;
    }
}

- (BOOL)isTableView {
    if ([self isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCollectionView {
    if ([self isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - public method

- (void)zf_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    if (self.zf_scrollViewDerection == ZFPlayerScrollViewDerectionVertical) {
        [self _findCorrectCellWhenScrollViewDerectionVertical:handler];
    } else {
        [self _findCorrectCellWhenScrollViewDerectionHorizontal:handler];
    }
}

- (void)zf_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.zf_shouldAutoPlay) return;
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        @strongify(self)
        if ([ZFReachabilityManager sharedManager].isReachableViaWWAN && !self.zf_WWANAutoPlay) {
            /// 移动网络
            self.zf_shouldPlayIndexPath = indexPath;
            return;
        }
        if (!self.zf_playingIndexPath) {
            if (handler) handler(indexPath);
            self.zf_playingIndexPath = indexPath;
        }
    }];
}

- (UIView *)zf_getCellForIndexPath:(NSIndexPath *)indexPath {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (NSIndexPath *)zf_getIndexPathForCell:(UIView *)cell {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];
        return indexPath;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)cell];
        return indexPath;
    }
    return nil;
}

- (void)zf_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler {
    [UIView animateWithDuration:0.6 animations:^{
        if ([self isTableView]) {
            UITableView *tableView = (UITableView *)self;
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } else if ([self isCollectionView]) {
            UICollectionView *collectionView = (UICollectionView *)self;
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
    } completion:^(BOOL finished) {
        if (completionHandler) completionHandler();
    }];
}

- (void)zf_scrollViewDidEndDecelerating {
    BOOL scrollToScrollStop = !self.tracking && !self.dragging && !self.decelerating;
    if (scrollToScrollStop) {
        [self _scrollViewDidStopScroll];
    }
}

- (void)zf_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = self.tracking && !self.dragging && !self.decelerating;
        if (dragToDragStop) {
            [self _scrollViewDidStopScroll];
        }
    }
}

- (void)zf_scrollViewDidScrollToTop {
    [self _scrollViewDidStopScroll];
}

- (void)zf_scrollViewDidScroll {
    if (self.zf_scrollViewDerection == ZFPlayerScrollViewDerectionVertical) {
        [self _scrollViewScrollingDerectionVertical];
    } else {
        [self _scrollViewScrollingDerectionHorizontal];
    }
}

- (void)zf_scrollViewWillBeginDragging {
    [self _scrollViewBeginDragging];
}

#pragma mark - getter

- (NSIndexPath *)zf_playingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSIndexPath *)zf_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)zf_containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (ZFPlayerScrollDerection)zf_scrollDerection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)zf_stopWhileNotVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)zf_isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)zf_shouldAutoPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.zf_shouldAutoPlay = YES;
    return YES;
}

- (ZFPlayerScrollViewDerection)zf_scrollViewDerection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (CGFloat)zf_lastOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)zf_lastOffsetX {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void (^)(NSIndexPath * _Nonnull))zf_scrollViewDidStopScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_shouldPlayIndexPathCallback {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setZf_playingIndexPath:(NSIndexPath *)zf_playingIndexPath {
    objc_setAssociatedObject(self, @selector(zf_playingIndexPath), zf_playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (zf_playingIndexPath) self.zf_shouldPlayIndexPath = zf_playingIndexPath;
}

- (void)setZf_shouldPlayIndexPath:(NSIndexPath *)zf_shouldPlayIndexPath {
    if (self.zf_shouldPlayIndexPathCallback) self.zf_shouldPlayIndexPathCallback(zf_shouldPlayIndexPath);
    objc_setAssociatedObject(self, @selector(zf_shouldPlayIndexPath), zf_shouldPlayIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.shouldPlayIndexPath = zf_shouldPlayIndexPath;
}

- (void)setZf_containerViewTag:(NSInteger)zf_containerViewTag {
    objc_setAssociatedObject(self, @selector(zf_containerViewTag), @(zf_containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_scrollDerection:(ZFPlayerScrollDerection)zf_scrollDerection {
    objc_setAssociatedObject(self, @selector(zf_scrollDerection), @(zf_scrollDerection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_stopWhileNotVisible:(BOOL)zf_stopWhileNotVisible {
    objc_setAssociatedObject(self, @selector(zf_stopWhileNotVisible), @(zf_stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_WWANAutoPlay:(BOOL)zf_WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(zf_isWWANAutoPlay), @(zf_WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_scrollViewDerection:(ZFPlayerScrollViewDerection)zf_scrollViewDerection {
    objc_setAssociatedObject(self, @selector(zf_scrollViewDerection), @(zf_scrollViewDerection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_shouldAutoPlay:(BOOL)zf_shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(zf_shouldAutoPlay), @(zf_shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_lastOffsetY:(CGFloat)zf_lastOffsetY {
    objc_setAssociatedObject(self, @selector(zf_lastOffsetY), @(zf_lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_lastOffsetX:(CGFloat)zf_lastOffsetX {
    objc_setAssociatedObject(self, @selector(zf_lastOffsetX), @(zf_lastOffsetX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZf_scrollViewDidStopScrollCallback:(void (^)(NSIndexPath * _Nonnull))zf_scrollViewDidStopScrollCallback {
    objc_setAssociatedObject(self, @selector(zf_scrollViewDidStopScrollCallback), zf_scrollViewDidStopScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_shouldPlayIndexPathCallback:(void (^)(NSIndexPath * _Nonnull))zf_shouldPlayIndexPathCallback {
    objc_setAssociatedObject(self, @selector(zf_shouldPlayIndexPathCallback), zf_shouldPlayIndexPathCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIScrollView (ZFPlayerCannotCalled)

#pragma mark - getter

- (void (^)(NSIndexPath * _Nonnull, CGFloat))zf_playerDisappearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))zf_playerAppearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerWillAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))zf_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setZf_playerDisappearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))zf_playerDisappearingInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDisappearingInScrollView), zf_playerDisappearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerAppearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))zf_playerAppearingInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerAppearingInScrollView), zf_playerAppearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDidAppearInScrollView), zf_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerWillDisappearInScrollView), zf_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerWillAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerWillAppearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerWillAppearInScrollView), zf_playerWillAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZf_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))zf_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(zf_playerDidDisappearInScrollView), zf_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIScrollView (ZFPlayerDeprecated)

#pragma mark - getter

- (NSIndexPath *)shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))scrollViewDidStopScroll {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setShouldPlayIndexPath:(NSIndexPath *)shouldPlayIndexPath {
    objc_setAssociatedObject(self, @selector(shouldPlayIndexPath), shouldPlayIndexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setScrollViewDidStopScroll:(void (^)(NSIndexPath * _Nonnull))scrollViewDidStopScroll {
    objc_setAssociatedObject(self, @selector(scrollViewDidStopScroll), scrollViewDidStopScroll, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma clang diagnostic pop
