//
//  Specs.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 24/02/2014.
//  Copyright (c) 2014 Jon Crooke. All rights reserved.
//

#import "SpecClasses.h"
#import "UICollectionView+EmptyState.h"

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

SpecBegin(Specs)

__block SpecCollectionController *controller = nil;
__block SpecCallBackController *callbacks = nil;

__block UICollectionViewFlowLayout *layout = nil;
__block UIView *emptyView = nil;

before(^{
  controller = [[SpecCollectionController alloc]
                initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
  layout = (id) controller.collectionView.collectionViewLayout;
  [controller loadView];

  return ;
  callbacks = [[SpecCallBackController alloc] init];

  emptyView = [[UIView alloc] init];

  [controller.collectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:@"Foo"];
  [controller.collectionView registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:@"Bar"];

  //\    controller.collectionView.emptyState_view = emptyView;
});

it(@"should", ^{
  expect(YES).to.equal(YES);
});

SpecEnd
