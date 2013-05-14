//
//  Tests.m
//  Tests
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TestPilot.h"
#import "Specta.h"
#import "UICollectionView+EmptyState.h"

#import "BlocksKit.h"

@interface SpecCollectionController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSUInteger numberOfSections;
@property (nonatomic, assign) NSUInteger numberOfSectionItems;
@property (nonatomic, assign) BOOL displaysSectionHeader;
@end
@implementation SpecCollectionController
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.numberOfSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
  return self.numberOfSectionItems;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [collectionView dequeueReusableCellWithReuseIdentifier:@"Foo"
                                                   forIndexPath:indexPath];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
  if (self.displaysSectionHeader) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:@"Bar"
                                                     forIndexPath:indexPath];
  }
  return nil;
}
- (CGSize)        collectionView:(UICollectionView *)collectionView
                          layout:(UICollectionViewLayout *)collectionViewLayout
 referenceSizeForHeaderInSection:(NSInteger)section
{
  return CGSizeMake(320, 50);
}
@end

#pragma mark -

@interface SpecCallBackController : NSObject <UICollectionViewEmptyStateDelegate>
@property (nonatomic, assign) BOOL didReceiveWillAddCallBack;
@property (nonatomic, assign) BOOL didReceiveDidAddCallBack;
@property (nonatomic, assign) BOOL didReceiveWillRemoveCallBack;
@property (nonatomic, assign) BOOL didReceiveDidRemoveCallBack;
@end
@implementation SpecCallBackController
- (void)collectionView:(UICollectionView *)collectionView didAddEmptyStateOverlayView:(UIView *)view {
  self.didReceiveDidAddCallBack = YES;
}
- (void)collectionView:(UICollectionView *)collectionView didRemoveEmptyStateOverlayView:(UIView *)view {
  self.didReceiveDidRemoveCallBack = YES;
}
- (void)collectionView:(UICollectionView *)collectionView willAddEmptyStateOverlayView:(UIView *)view animated:(BOOL)animated {
  self.didReceiveWillAddCallBack = YES;
}
- (void)collectionView:(UICollectionView *)collectionView willRemoveEmptyStateOverlayView:(UIView *)view animated:(BOOL)animated
{
  self.didReceiveWillRemoveCallBack = YES;
}
@end

#pragma mark -

SpecBegin(Specs);

describe(@"simple case", ^{

  __block SpecCollectionController *controller = nil;
  __block UICollectionViewFlowLayout *layout = nil;
  __block UIView *emptyView = nil;
  __block SpecCallBackController *callbacks = nil;

  before(^{
    layout = [[UICollectionViewFlowLayout alloc] init];
    controller = [[SpecCollectionController alloc] initWithCollectionViewLayout:layout];
    callbacks = [[SpecCallBackController alloc] init];

    emptyView = [[UIView alloc] init];

    [controller.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"Foo"];
    [controller.collectionView registerClass:[UICollectionReusableView class]
                  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                         withReuseIdentifier:@"Bar"];

    controller.collectionView.emptyState_view = emptyView;
    expect(controller.collectionView.emptyState_view).to.equal(emptyView);

    expect(controller.isViewLoaded).to.beTruthy;
  });
  after(^{
    controller = nil;
    layout = nil;
    emptyView = nil;
  });

  it(@"should not display overlay with content", ^{
    controller.numberOfSectionItems = 10;
    controller.numberOfSections = 10;
    [controller.collectionView layoutSubviews];

    expect(emptyView.superview).toNot.equal(controller.collectionView);
  });

  it(@"should display overlay with no content, covering entire collection view", ^{
    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 0;
    [controller.collectionView layoutSubviews];

    expect(emptyView.superview).equal(controller.collectionView);
    expect(emptyView.frame).to.equal(controller.collectionView.bounds);
  });

  it(@"should not overlay the first section header if option is set", ^{
    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 10;
    controller.collectionView.emptyState_shouldRespectSectionHeader = YES;
    controller.displaysSectionHeader = YES;
    [controller.collectionView layoutSubviews];

    expect(emptyView.superview).equal(controller.collectionView);

    expect(emptyView.frame).notTo.equal(controller.collectionView.bounds);
    UICollectionReusableView *headerView = [controller collectionView:controller.collectionView
                                    viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    expect(CGRectIntersectsRect(headerView.frame, emptyView.frame)).to.beFalsy;
  });

  it(@"should call delegate methods", ^{
    controller.collectionView.emptyState_delegate = callbacks;
    callbacks.didReceiveWillRemoveCallBack = NO;
    callbacks.didReceiveWillAddCallBack = NO;
    callbacks.didReceiveDidAddCallBack = NO;
    callbacks.didReceiveDidRemoveCallBack = NO;

    controller.numberOfSectionItems = 0;
    controller.numberOfSections = 0;
    [controller.collectionView layoutSubviews];

    expect(callbacks.didReceiveWillAddCallBack).to.beTruthy;
    expect(callbacks.didReceiveWillRemoveCallBack).to.beTruthy;
    expect(callbacks.didReceiveDidAddCallBack).to.beFalsy;
    expect(callbacks.didReceiveDidRemoveCallBack).to.beFalsy;

    callbacks.didReceiveWillRemoveCallBack = NO;
    callbacks.didReceiveWillAddCallBack = NO;
    callbacks.didReceiveDidAddCallBack = NO;
    callbacks.didReceiveDidRemoveCallBack = NO;

    controller.numberOfSectionItems = 10;
    controller.numberOfSections = 10;
    [controller.collectionView layoutSubviews];

    expect(callbacks.didReceiveWillAddCallBack).to.beFalsy;
    expect(callbacks.didReceiveWillRemoveCallBack).to.beFalsy;
    expect(callbacks.didReceiveDidAddCallBack).to.beTruthy;
    expect(callbacks.didReceiveDidRemoveCallBack).to.beTruthy;
  });

});

SpecEnd


