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
#import "JRSwizzle.h"
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
SYNTHESIZE_ASC_PRIMITIVE_BLOCK(emptyState_shouldRespectSectionHeader,
                               setEmptyState_shouldRespectSectionHeader,
                               BOOL,
                               ^{},
                               ^{ [self reloadData]; })
SYNTHESIZE_ASC_OBJ_BLOCK(emptyState_view,
                         setEmptyState_view,
                         ^{},
                         ^
{
  static BOOL __segue_swizzled = NO;
  if (!__segue_swizzled) {
    NSError *e = nil;
    [UICollectionView jr_swizzleMethod:@selector(layoutSubviews)
                            withMethod:@selector(__empty_layoutSubviews)
                                 error:&e];
    NSAssert(!e, e.localizedDescription);
    __segue_swizzled = YES;
  }
  // remove any existing view
  [self.emptyState_view removeFromSuperview];
});

- (void) __empty_layoutSubviews {
  [self __empty_layoutSubviews];

  CGRect bounds = self.bounds;

  NSUInteger totalItems = 0;
  NSUInteger numberOfSections = 1;
  if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    numberOfSections = [self.dataSource numberOfSectionsInCollectionView:self];
  }

  for (NSUInteger section = 0; section < numberOfSections; ++section) {
    totalItems += [self.dataSource collectionView:self numberOfItemsInSection:section];
  }


  // section header respect requires UICollectionViewDelegateFlowLayout right now...
  if (self.emptyState_view && self.emptyState_shouldRespectSectionHeader) {
    NSAssert2([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]],
              @"Only compatible with %@ when emptyState_shouldRespectSectionHeader = YES." \
              " Cannot be used with %@",
              NSStringFromClass([UICollectionViewFlowLayout class]),
              NSStringFromClass([self.collectionViewLayout class]));


    // is there actually a header to be displayed?
    if (numberOfSections &&
        [self.dataSource
         respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
    {
      UIView *headerView = [self.dataSource collectionView:self
                         viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader
                                               atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
      if (headerView) {
        CGRect slice;
        CGRectDivide(bounds,
                     &slice,
                     &bounds,
                     CGRectGetMaxY(headerView.frame),
                     CGRectMinYEdge);
      }
    }
  }

  // always update frame
  self.emptyState_view.frame = UIEdgeInsetsInsetRect(bounds, self.contentInset);

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

    [UIView animateWithDuration:self.emptyState_showAnimationDuration
                          delay:self.emptyState_showDelay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
       self.emptyState_view.alpha = 1.0;
     } completion:^(BOOL finished) {
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

  [UIView animateWithDuration:self.emptyState_hideAnimationDuration
                        delay:self.emptyState_hideDelay
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^
   {
     self.emptyState_view.alpha = 0.0;
   } completion:^(BOOL finished) {
     [self.emptyState_view removeFromSuperview];
     if ([self.emptyState_delegate respondsToSelector:@selector(collectionView:didRemoveEmptyStateOverlayView:)]) {
       [self.emptyState_delegate collectionView:self
                 didRemoveEmptyStateOverlayView:self.emptyState_view];
     }
   }];
}

#pragma mark -

- (UIImageView*) setEmptyStateImageViewWithImage:(UIImage*) image {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.contentMode = UIViewContentModeCenter;
  self.emptyState_view = imageView;
  return imageView;
}

@end
