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

SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(emptyStateView, setEmptyStateView, ^{}, ^{
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
    [self.emptyStateView removeFromSuperview];
  } else {
    // show
    self.emptyStateView.frame = self.bounds;
    [self addSubview:self.emptyStateView];
  }
}

@end
