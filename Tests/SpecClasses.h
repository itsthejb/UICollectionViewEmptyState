//
//  SpecClasses.h
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 24/02/2014.
//  Copyright (c) 2014 Jon Crooke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+EmptyState.h"

@interface SpecCollectionController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSUInteger numberOfSections;
@property (nonatomic, assign) NSUInteger numberOfSectionItems;
@property (nonatomic, assign) BOOL displaysSectionHeader;
@end

@interface SpecCallBackController : NSObject <UICollectionViewEmptyStateDelegate>
@property (nonatomic, assign) BOOL didReceiveWillAddCallBack;
@property (nonatomic, assign) BOOL didReceiveDidAddCallBack;
@property (nonatomic, assign) BOOL didReceiveWillRemoveCallBack;
@property (nonatomic, assign) BOOL didReceiveDidRemoveCallBack;
@end

@interface SpecView : UIView
@end
