//
//  UICollectionView+EmptyState.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <QuartzCore/QuartzCore.h>
#import "UICollectionView+EmptyState.h"
#import "ObjcAssociatedObjectHelpers.h"
#import "EXTSwizzle.h"
#import "EXTScope.h"

@interface UICollectionView (EmptyStatePrivate)
- (void) __empty_layoutSubviews;
- (void) __empty_layoutSubviews_original;
- (void) __empty_layoutAddViewItems:(NSUInteger) items
                            section:(NSUInteger) sections;
- (void) __empty_layoutRemoveView;
@end

@implementation UICollectionView (EmptyState)

SYNTHESIZE_ASC_OBJ_ASSIGN(emptyState_delegate,
                          setEmptyState_delegate)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_showAnimationDuration,
                         setEmptyState_showAnimationDuration,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_hideAnimationDuration,
                         setEmptyState_hideAnimationDuration,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_showDelay,
                         setEmptyState_showDelay,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_hideDelay,
                         setEmptyState_hideDelay,
                         NSTimeInterval)
SYNTHESIZE_ASC_PRIMITIVE(emptyState_shouldRespectSectionHeader,
                         setEmptyState_shouldRespectSectionHeader,
                         BOOL)
SYNTHESIZE_ASC_OBJ_BLOCK(emptyState_view,
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
  // remove any existing view
  [self.emptyState_view removeFromSuperview];
});

- (void) __empty_layoutSubviews {
  [self __empty_layoutSubviews_original];

  // section header respect requires UICollectionViewDelegateFlowLayout right now...
  if (self.emptyState_view && self.emptyState_shouldRespectSectionHeader &&
      ![self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
  {
    [NSException raise:@"UICollectionView+EmptyState Exception"
                format:
     @"Only compatible with %@ when emptyState_shouldRespectSectionHeader = YES." \
     " Cannot be used with %@",
     NSStringFromClass([UICollectionViewFlowLayout class]),
     NSStringFromClass([self.collectionViewLayout class])];
  }

  NSUInteger totalItems = 0;
  NSUInteger numberOfSections = 1;
  if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    numberOfSections = [self.dataSource numberOfSectionsInCollectionView:self];
  }

  for (NSUInteger section = 0; section < numberOfSections; ++section) {
    totalItems += [self.dataSource collectionView:self numberOfItemsInSection:section];
  }

  // view may already be animating
  BOOL animating = [self.emptyState_view.layer.animationKeys containsObject:@"opacity"];

  if (totalItems) {
    // remove
    if (self.emptyState_view.superview && !animating) {
      [self __empty_layoutRemoveView];
    }
  } else {
    if (!self.emptyState_view.superview && !animating) {
      [self __empty_layoutAddViewItems:totalItems section:numberOfSections];
    }
  }
}

- (void) __empty_layoutAddViewItems:(NSUInteger) totalItems
                            section:(NSUInteger) numberOfSections
{
  // show
  CGRect bounds = self.bounds;

  // don't overlay header?
  if (self.emptyState_shouldRespectSectionHeader) {

    id <UICollectionViewDelegateFlowLayout> delegate = (id) self.delegate;
    UICollectionViewFlowLayout *layout = (id) self.collectionViewLayout;

    // is there actually a header to be displayed?
    if (numberOfSections &&
        [self.dataSource collectionView:self
      viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader
                            atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]])
    {
      // reveal the first section's supplementary view
      CGSize size = layout.headerReferenceSize;

      if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        size = [delegate collectionView:self
                                 layout:layout
        referenceSizeForHeaderInSection:0];
      }

      //
      CGRect slice;
      CGRectDivide(bounds, &slice, &bounds, size.height, CGRectMinYEdge);
    }
  }

  // always update bounds
  self.emptyState_view.frame = bounds;

  // add view
  if (self.emptyState_view.superview != self) {

    // pre-display
    if ([self.emptyState_delegate
         respondsToSelector:@selector(collectionView:willAddEmptyStateOverlayView:animated:)])
    {
      [self.emptyState_delegate collectionView:self
                  willAddEmptyStateOverlayView:self.emptyState_view
                                      animated:!!self.emptyState_showAnimationDuration];
    }

    // not visible, add
    self.emptyState_view.alpha = 0.0;
    [self addSubview:self.emptyState_view];

    @weakify(self)
    [UIView animateWithDuration:self.emptyState_showAnimationDuration
                          delay:self.emptyState_showDelay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
    {
      @strongify(self)
      self.emptyState_view.alpha = 1.0;
    } completion:^(BOOL finished) {
      @strongify(self)
      if ([self.emptyState_delegate
           respondsToSelector:@selector(collectionView:didAddEmptyStateOverlayView:)])
      {
        [self.emptyState_delegate collectionView:self
                     didAddEmptyStateOverlayView:self.emptyState_view];
      }
    }];
  }
}

- (void)__empty_layoutRemoveView {
  if ([self.emptyState_delegate
       respondsToSelector:@selector(collectionView:willRemoveEmptyStateOverlayView:animated:)])
  {
    [self.emptyState_delegate collectionView:self
             willRemoveEmptyStateOverlayView:self.emptyState_view
                                    animated:!!self.emptyState_hideAnimationDuration];
  }

  @weakify(self)
  [UIView animateWithDuration:self.emptyState_hideAnimationDuration
                        delay:self.emptyState_hideDelay
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^
  {
    @strongify(self)
    self.emptyState_view.alpha = 0.0;
  } completion:^(BOOL finished) {
    @strongify(self)
    [self.emptyState_view removeFromSuperview];
    if ([self.emptyState_delegate respondsToSelector:@selector(collectionView:didRemoveEmptyStateOverlayView:)]) {
      [self.emptyState_delegate collectionView:self
                didRemoveEmptyStateOverlayView:self.emptyState_view];
    }
  }];
}

- (UIImageView*) setEmptyStateImageViewWithImage:(UIImage*) image
{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.contentMode = UIViewContentModeCenter;
  self.emptyState_view = imageView;
  return imageView;
}

@end
