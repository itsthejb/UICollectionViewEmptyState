//
//  UICollectionView+EmptyState.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "UICollectionView+EmptyState.h"
#import "ObjcAssociatedObjectHelpers.h"

@interface UICollectionView (EmptyStatePrivate)
@end

@implementation UICollectionView (EmptyState)

SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(emptyStateView, setEmptyStateView, ^{}, ^{
  NSLog(@"foo");
});

+ (void)initialize {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
  });
}

@end
