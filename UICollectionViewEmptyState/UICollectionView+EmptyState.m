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
#import <Aspects/Aspects.h>
#import "UICollectionView+EmptyState.h"
#import "ObjcAssociatedObjectHelpers.h"

@interface UICollectionView (EmptyStatePrivate)
@property (nonatomic, strong) id <AspectToken> __empty_swizzleToken;
- (void) __empty_layoutSubviews;
- (void) __empty_layoutAddViewItems:(NSUInteger) items
                            section:(NSUInteger) sections;
- (void) __empty_layoutRemoveView;
- (NSUInteger) __empty_numberOfSections;
- (NSUInteger) __empty_totalNumberOfItems;
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
SYNTHESIZE_ASC_OBJ(__empty_swizzleToken, set__empty_swizzleToken)
SYNTHESIZE_ASC_PRIMITIVE_BLOCK(emptyState_shouldRespectSectionHeader,
                               setEmptyState_shouldRespectSectionHeader,
                               BOOL,
                               ^(BOOL v) { return v; },
                               ^(BOOL v) { return v; })
SYNTHESIZE_ASC_OBJ_BLOCK(emptyState_view,
                         setEmptyState_view,
                         ^(UIView *view) { return view; },
                         ^(UIView *view)
{
  if (view && !self.__empty_swizzleToken) {
    NSError *e = nil;
    self.__empty_swizzleToken = [self aspect_hookSelector:@selector(layoutSubviews)
                                              withOptions:AspectPositionAfter
                                               usingBlock:^
                                 {
                                   [self __empty_layoutSubviews];
                                 } error:&e];
    NSAssert(!e, e.localizedDescription);
  }

  else if (!view && self.__empty_swizzleToken) {
    [self.__empty_swizzleToken remove];
    self.__empty_swizzleToken = nil;
  }

  // remove any existing view
  [self.emptyState_view removeFromSuperview];

  return view;
});

- (void) __empty_layoutSubviews {
  [self __empty_layoutHeader];

  // view may already be animating
  BOOL animating = [self.emptyState_view.layer.animationKeys containsObject:@"opacity"];

  NSUInteger totalItems = self.__empty_totalNumberOfItems;
  if (totalItems) {
    // remove
    if (self.emptyState_view.superview && !animating) {
      [self __empty_layoutRemoveView];
    }
  } else {
    // add
    if (self.emptyState_view && self.emptyState_view.superview != self && !animating) {
      [self __empty_layoutAddViewItems:totalItems section:self.__empty_numberOfSections];
    }
  }
}

- (NSUInteger)__empty_numberOfSections {
  if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
    return [self.dataSource numberOfSectionsInCollectionView:self];
  }
  return 1;
}

- (NSUInteger)__empty_totalNumberOfItems {
  NSUInteger totalItems = 0;
  NSUInteger numberOfSections = self.__empty_numberOfSections;

  for (NSUInteger section = 0; section < numberOfSections; ++section) {
    totalItems += [self.dataSource collectionView:self numberOfItemsInSection:section];
  }

  return totalItems;
}

- (void) __empty_layoutHeader {
  CGRect bounds = self.bounds;

  // section header respect requires UICollectionViewDelegateFlowLayout right now...
  if (self.emptyState_view && self.emptyState_shouldRespectSectionHeader) {
    UICollectionViewFlowLayout *layout = (id) self.collectionViewLayout;
    NSAssert2([layout isKindOfClass:[UICollectionViewFlowLayout class]],
              @"Only compatible with %@ when emptyState_shouldRespectSectionHeader = YES." \
              " Cannot be used with %@",
              NSStringFromClass([UICollectionViewFlowLayout class]),
              NSStringFromClass([self.collectionViewLayout class]));


    // is there actually a header to be displayed?
    if (self.__empty_numberOfSections &&
        [self.dataSource
         respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
    {
      CGSize headerSize = layout.headerReferenceSize;

      if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        headerSize = [(id <UICollectionViewDelegateFlowLayout>) self.delegate
                      collectionView:self
                      layout:layout
                      referenceSizeForHeaderInSection:0];
      }

      CGRect slice;
      CGRectDivide(bounds, &slice, &bounds, headerSize.height, CGRectMinYEdge);
    }
  }

  // always update frame
  self.emptyState_view.frame = UIEdgeInsetsInsetRect(bounds, self.contentInset);
}

- (void) __empty_layoutAddViewItems:(NSUInteger) totalItems
                            section:(NSUInteger) numberOfSections
{
  // add view
  if (self.emptyState_view.superview != self) {
    // not visible, add
    self.emptyState_view.alpha = 0.0;
    [self addSubview:self.emptyState_view];

    [UIView animateWithDuration:self.emptyState_showAnimationDuration
                          delay:self.emptyState_showDelay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
       // pre-display
       if ([self.emptyState_delegate
            respondsToSelector:@selector(collectionView:willAddEmptyStateOverlayView:animated:)])
       {
         [self.emptyState_delegate collectionView:self
                     willAddEmptyStateOverlayView:self.emptyState_view
                                         animated:!!self.emptyState_showAnimationDuration];
       }

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
  [UIView animateWithDuration:self.emptyState_hideAnimationDuration
                        delay:self.emptyState_hideDelay
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^
   {
     if ([self.emptyState_delegate
          respondsToSelector:@selector(collectionView:willRemoveEmptyStateOverlayView:animated:)])
     {
       [self.emptyState_delegate collectionView:self
                willRemoveEmptyStateOverlayView:self.emptyState_view
                                       animated:!!self.emptyState_hideAnimationDuration];
     }

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
