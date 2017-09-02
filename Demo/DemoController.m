//
//  JCViewController.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "DemoController.h"
#import "DemoCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <UICollectionViewEmptyState/UICollectionView+EmptyState.h>

@interface DemoController () <UICollectionViewDelegateFlowLayout, UICollectionViewEmptyStateDelegate>
@end

@implementation DemoController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.emptyState_delegate = self;

  self.navigationItem.titleView = self.topToolbar;
  [self.topToolbar setBackgroundImage:[[UIImage alloc] init]
                   forToolbarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];

  [@[self.sectionStepper, self.itemStepper, self.headerSwitch]
   enumerateObjectsUsingBlock:^(UIControl *control, NSUInteger idx, BOOL *stop) {
     [control addTarget:self.collectionView
                 action:@selector(reloadData)
       forControlEvents:UIControlEventValueChanged];
   }];

  {
    [self.respectHeaderSwitch bk_addEventHandler:^(id sender) {
      self.collectionView.emptyState_shouldRespectSectionHeader =
      !self.collectionView.emptyState_shouldRespectSectionHeader;
      [self.collectionView.collectionViewLayout invalidateLayout];
    } forControlEvents:UIControlEventValueChanged];

    [self.insetsSwitch bk_addEventHandler:^(id sender) {
      self.edgesForExtendedLayout = (self.edgesForExtendedLayout == UIRectEdgeNone ?
                                     UIRectEdgeTop & UIRectEdgeBottom :
                                     UIRectEdgeNone);
      [self.collectionView reloadData];
    } forControlEvents:UIControlEventValueChanged];
  }

  {
    id(^flexibleSpace)(void) = ^{
      return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                           target:nil
                                                           action:nil];
    };

    id(^title)(NSString*) = ^(NSString *title) {
      return [[UIBarButtonItem alloc] initWithTitle:title
                                              style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    };

    id(^customView)(id) = ^(id view) {
      return [[UIBarButtonItem alloc] initWithCustomView:view];
    };

    self.toolbarItems = @[flexibleSpace(),
                          title(@"Sections:"),
                          customView(self.sectionStepper),
                          flexibleSpace(),
                          title(@"Rows:"),
                          customView(self.itemStepper),
                          flexibleSpace(),
                          title(@"Header:"),
                          customView(self.headerSwitch),
                          flexibleSpace()];
  }

  // configure empty view
  self.collectionView.emptyState_view = self.emptyView;
  self.collectionView.emptyState_showAnimationDuration = 0.3;
  self.collectionView.emptyState_hideAnimationDuration = 0.3;
}

#pragma mark Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.sectionStepper.value;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
  return self.itemStepper.value;
}

- (CGSize)        collectionView:(UICollectionView *)collectionView
                          layout:(UICollectionViewLayout *)collectionViewLayout
 referenceSizeForFooterInSection:(NSInteger)section
{
  if (self.headerSwitch.isOn) {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 50);
  } else {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 0);
  }
}

- (CGSize)        collectionView:(UICollectionView *)collectionView
                          layout:(UICollectionViewLayout *)collectionViewLayout
 referenceSizeForHeaderInSection:(NSInteger)section
{
  if (self.headerSwitch.isOn) {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 50);
  } else {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 0);
  }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
  static NSDictionary *dict = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dict = @{UICollectionElementKindSectionHeader : @"Header",
             UICollectionElementKindSectionFooter : @"Footer"};
  });

  return [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                            withReuseIdentifier:dict[kind]
                                                   forIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCell" forIndexPath:indexPath];

  static NSArray *images = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    images = @[@"bird-1368498135Eqm.jpg",
               @"chess.jpg",
               @"empire-state-building-1368498219KmC.jpg",
               @"goose-1368497908c6H.jpg",
               @"sun-1368498327ZH8.jpg"];
  });
  cell.imageView.image = [UIImage imageNamed:images[indexPath.section % images.count]];
  
  return cell;
}

#pragma mark Empty state delegate

- (void)				collectionView:(UICollectionView *)collectionView
	willAddEmptyStateOverlayView:(UIView *)view
  		                animated:(BOOL)animated
{
  NSLog(@"%@:%@", NSStringFromSelector(_cmd), view);
}

- (void)				 collectionView:(UICollectionView *)collectionView
willRemoveEmptyStateOverlayView:(UIView *)view
                 			 animated:(BOOL)animated
{
  NSLog(@"%@:%@", NSStringFromSelector(_cmd), view);
}

- (CGRect) collectionView:(UICollectionView*) collectionView
             willSetFrame:(CGRect) proposed
 forEmptyStateOverlayView:(UIView*) view
{
  NSLog(@"%@:%@", NSStringFromSelector(_cmd), view);
  return proposed;
}

@end
