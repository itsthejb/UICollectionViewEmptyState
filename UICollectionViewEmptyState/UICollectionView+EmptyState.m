//
//  UICollectionView+EmptyState.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "UICollectionView+EmptyState.h"
#import "ObjcAssociatedObjectHelpers.h"
#import "EXTSwizzle.h"

@interface UICollectionView (EmptyStatePrivate)
- (void) __empty_layoutSubviews;
- (void) __empty_layoutSubviews_original;
@end

@implementation UICollectionView (EmptyState)

SYNTHESIZE_ASC_PRIMITIVE(emptyState_showAnimationDuration,
                         setEmptyState_showAnimationDuration,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_hideAnimationDuration,
                         setEmptyState_hideAnimationDuration,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_shouldRespectSectionHeader,
                         setEmptyState_shouldRespectSectionHeader,
                         BOOL)
SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(emptyState_view,
                                setEmptyState_view,
                                ^{},
                                ^
{
  static BOOL __segue_swizzled = NO;
  if (!__segue_swizzled) {
    EXT_SWIZZLE_INSTANCE_METHODS(UICollectionView,
                                 layoutSubviews,
                                 __empty_layoutSubviews,
                                 __empty_layoutSubviews_original);
    __segue_swizzled = YES;
  }
});

- (void) __empty_layoutSubviews {
  [self __empty_layoutSubviews_original];

  NSUInteger totalItems = 0;
  for (NSUInteger section = 0; section < [self.dataSource numberOfSectionsInCollectionView:self]; ++section) {
    totalItems += [self.dataSource collectionView:self numberOfItemsInSection:section];
  }

  if (totalItems) {
    // remove
    [UIView animateWithDuration:self.emptyState_hideAnimationDuration animations:^{
      self.emptyState_view.alpha = 0.0;
    } completion:^(BOOL finished) {
      [self.emptyState_view removeFromSuperview];
    }];
  } else if (!totalItems && !self.emptyState_view.superview) {
    // show
    CGRect bounds = self.bounds;

    if (self.emptyState_shouldRespectSectionHeader) {
      // reveal the first section's supplementary view
      id <UICollectionViewDelegateFlowLayout> delegate = (id) self.delegate;
      CGSize size = [delegate collectionView:self
                                      layout:self.collectionViewLayout
             referenceSizeForHeaderInSection:0];

      //
      CGRect slice;
      CGRectDivide(bounds, &slice, &bounds, size.height, CGRectMinYEdge);
      self.emptyState_view.frame = bounds;

    } else {
      // cover entire collection view
      self.emptyState_view.frame = bounds;
    }

    self.emptyState_view.alpha = 0.0;
    [self addSubview:self.emptyState_view];
    [UIView animateWithDuration:self.emptyState_showAnimationDuration animations:^{
      self.emptyState_view.alpha = 1.0;
    }];
  }
}

@end
