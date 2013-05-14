//
//  UICollectionView+EmptyState.h
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (EmptyState)

@property (nonatomic, strong) UIView *emptyState_view;
@property (nonatomic, assign) BOOL emptyState_shouldRespectSectionHeader;
@property (nonatomic, assign) NSTimeInterval emptyState_showAnimationDuration;
@property (nonatomic, assign) NSTimeInterval emptyState_hideAnimationDuration;

@end
