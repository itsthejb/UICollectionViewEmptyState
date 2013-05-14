//
//  UICollectionView+EmptyState.h
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (EmptyState)

/** The view to be displayed when content is empty */
@property (nonatomic, strong) UIView *emptyState_view;

/** 
 If YES and section 0 contains a supplementary header view,
 don't overlay it. Useful if you have important controls in
 this header
 */
@property (nonatomic, assign) BOOL emptyState_shouldRespectSectionHeader;

/** Fade in animation duration. 0.0 = no animation */
@property (nonatomic, assign) NSTimeInterval emptyState_showAnimationDuration;

/** Fade out animation duration. 0.0 = no animation */
@property (nonatomic, assign) NSTimeInterval emptyState_hideAnimationDuration;

@end
