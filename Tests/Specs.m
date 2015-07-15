//
//  Specs.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 24/02/2014.
//  Copyright (c) 2014 Jon Crooke. All rights reserved.
//

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"
#import "UICollectionView+EmptyState.h"
#import "SpecClasses.h"

#pragma mark -

SpecBegin(Specs);

describe(@"simple case", ^{

  __block SpecCollectionController *controller = nil;
  __block SpecCallBackController *callbacks = nil;

  UICollectionViewFlowLayout*(^layout)(void) = ^{
    return (UICollectionViewFlowLayout*) controller.collectionViewLayout;
  };

  UIView*(^emptyView)(void) = ^ {
    return controller.collectionView.emptyState_view;
  };

  beforeAll(^{
    [UIView setAnimationsEnabled:NO];
  });

  beforeEach(^{
    controller = [[SpecCollectionController alloc]
                  initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];

    callbacks = [[SpecCallBackController alloc] init];

    [controller.collectionView registerClass:[UICollectionViewCell class]
                  forCellWithReuseIdentifier:@"Foo"];
    [controller.collectionView registerClass:[UICollectionReusableView class]
                  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                         withReuseIdentifier:@"Bar"];

    controller.collectionView.emptyState_view = [[SpecView alloc] init];
  });

  it(@"should be set up correctly for testing", ^{
    expect(layout()).to.beInstanceOf([UICollectionViewFlowLayout class]);
    expect(controller.collectionView.emptyState_view).to.equal(emptyView());
    expect(controller.isViewLoaded).to.beTruthy();
  });

  it(@"should not display overlay with content", ^{
    controller.numberOfSectionItems = 10;
    controller.numberOfSections = 10;
    [controller.collectionView layoutSubviews];
    expect(emptyView().superview).toNot.equal(controller.collectionView);
  });

  it(@"should nil the empty view if not required", ^{
    controller.collectionView.emptyState_shouldNilViewIfNotRequired = YES;
    controller.numberOfSectionItems = 10;
    controller.numberOfSections = 10;
    [controller.collectionView layoutSubviews];
    expect(controller.collectionView.emptyState_view).to.beNil();
  });

  it(@"should display overlay with no content, covering entire collection view", ^{
    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 0;
    [controller.collectionView layoutSubviews];

    expect(emptyView().superview).equal(controller.collectionView);
    expect(emptyView().frame).to.equal(controller.collectionView.bounds);
  });

  it(@"should not overlay the first section header if option is set", ^{
    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 10;
    controller.collectionView.emptyState_shouldRespectSectionHeader = YES;
    controller.displaysSectionHeader = YES;
    [controller.collectionView layoutSubviews];

    expect(emptyView().superview).to.equal(controller.collectionView);

    expect(emptyView().frame.origin).notTo.equal(controller.collectionView.bounds.origin);
    UICollectionReusableView *headerView = [controller collectionView:controller.collectionView
                                    viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    expect(CGRectIntersectsRect(headerView.frame, emptyView().frame)).to.beFalsy();
  });

  it(@"should call delegate methods", ^{
    controller.collectionView.emptyState_delegate = callbacks;
    callbacks.didReceiveWillRemoveCallBack =
    callbacks.didReceiveWillAddCallBack =
    callbacks.didReceiveDidAddCallBack =
    callbacks.didReceiveDidRemoveCallBack =
    callbacks.didReceiveFrameSetCallBack = NO;
    callbacks.shouldModifyFrameInSetDelegateMethod = YES;
    expect(CGRectEqualToRect(controller.collectionView.emptyState_view.frame, CGRectZero)).to.beTruthy();

    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 0;
    [controller.collectionView layoutSubviews];

    expect(callbacks.didReceiveWillAddCallBack).to.beTruthy();
    expect(callbacks.didReceiveWillRemoveCallBack).to.beFalsy();
    expect(callbacks.didReceiveDidAddCallBack).to.beFalsy();
    expect(callbacks.didReceiveDidRemoveCallBack).to.beFalsy();
    expect(callbacks.didReceiveFrameSetCallBack).to.beTruthy();
    expect(CGRectEqualToRect(controller.collectionView.emptyState_view.frame,
                             CGRectMake(10, 20, 30, 40))).to.beTruthy();

    callbacks.didReceiveWillRemoveCallBack =
    callbacks.didReceiveWillAddCallBack =
    callbacks.didReceiveDidAddCallBack =
    callbacks.didReceiveDidRemoveCallBack =
    callbacks.didReceiveFrameSetCallBack = NO;
    callbacks.shouldModifyFrameInSetDelegateMethod = NO;

    controller.numberOfSectionItems = 10;
    controller.numberOfSections = 10;
    [controller.collectionView layoutSubviews];

    expect(callbacks.didReceiveWillAddCallBack).to.beFalsy();
    expect(callbacks.didReceiveWillRemoveCallBack).to.beTruthy();
    expect(callbacks.didReceiveDidAddCallBack).to.beFalsy();
    expect(callbacks.didReceiveDidRemoveCallBack).to.beFalsy();
    expect(callbacks.didReceiveFrameSetCallBack).to.beTruthy();
    expect(CGRectEqualToRect(controller.collectionView.emptyState_view.frame,
                             controller.collectionView.frame)).to.beTruthy();
  });
});

SpecEnd


