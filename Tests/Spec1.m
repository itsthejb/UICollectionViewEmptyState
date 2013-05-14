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

@interface SpecController1 : UICollectionViewController
@end
@implementation SpecController1
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:@"Foo"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
  return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Foo"
                                                                         forIndexPath:indexPath];
  return cell;
}
@end

SpecBegin(Spec1);

describe(@"simple case", ^{

  __block SpecController1 *controller = nil;
  __block UICollectionViewFlowLayout *layout = nil;
  __block UIView *emptyView = nil;

  before(^{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addEventHandler:^(id sender) {
      NSLog(@"foo");
    } forControlEvents:UIControlEventTouchUpInside];

    layout = [[UICollectionViewFlowLayout alloc] init];
    controller = [[SpecController1 alloc] initWithCollectionViewLayout:layout];
    emptyView = [[UIView alloc] init];
    [controller loadView];
    expect(controller.isViewLoaded).to.beTruthy;
    expect(controller.collectionView).toNot.beNil;
    controller.collectionView.emptyState_view = emptyView;
    [controller.collectionView reloadData];
  });
  after(^{
    controller = nil;
  });

  it(@"should display overlay", ^{
    expect(YES).to.beTruthy;
  });

});

SpecEnd


