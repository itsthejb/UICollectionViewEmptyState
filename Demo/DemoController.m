//
//  JCViewController.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "DemoController.h"
#import "DemoCell.h"
#import "BlocksKit+UIKit.h"
#import "UICollectionView+EmptyState.h"

@interface DemoController () <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIStepper *sectionStepper;
@property (strong, nonatomic) IBOutlet UIStepper *itemStepper;
@property (strong, nonatomic) IBOutlet UISwitch *decoratorSwitch;
@property (strong, nonatomic) IBOutlet UILabel *emptyView;
- (IBAction)sectionHeaderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)insetsButtonPressed:(UIBarButtonItem *)sender;
@end

@implementation DemoController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Demo";

  __weak DemoController *weakSelf = self;

  [self.sectionStepper bk_addEventHandler:^(id sender) {
    [weakSelf.collectionView reloadData];
  } forControlEvents:UIControlEventValueChanged];

  [self.itemStepper bk_addEventHandler:^(id sender) {
    [weakSelf.collectionView reloadData];
  } forControlEvents:UIControlEventValueChanged];

  [self.decoratorSwitch bk_addEventHandler:^(id sender) {
    [weakSelf.collectionView reloadData];
  } forControlEvents:UIControlEventValueChanged];

  self.toolbarItems = @[
                        [[UIBarButtonItem alloc] initWithTitle:@"Secs"
                                                         style:UIBarButtonItemStylePlain
                                                        target:nil
                                                        action:nil],
                        [[UIBarButtonItem alloc] initWithCustomView:self.sectionStepper],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                      target:nil
                                                                      action:nil],
                        [[UIBarButtonItem alloc] initWithTitle:@"Rows"
                                                         style:UIBarButtonItemStylePlain
                                                        target:nil
                                                        action:nil],
                        [[UIBarButtonItem alloc] initWithCustomView:self.itemStepper]];

  // configure empty view
  self.collectionView.emptyState_view = self.emptyView;
  self.collectionView.emptyState_showAnimationDuration = 0.3;
  self.collectionView.emptyState_hideAnimationDuration = 0.3;
  self.collectionView.emptyState_shouldRespectSectionHeader = YES;
}

- (IBAction)sectionHeaderButtonPressed:(UIBarButtonItem *)sender {
  self.collectionView.emptyState_shouldRespectSectionHeader =
  !self.collectionView.emptyState_shouldRespectSectionHeader;
}

- (IBAction)insetsButtonPressed:(UIBarButtonItem*)sender {
  self.edgesForExtendedLayout = (self.edgesForExtendedLayout == UIRectEdgeNone ?
                                 UIRectEdgeTop & UIRectEdgeBottom :
                                 UIRectEdgeNone);
  [self.collectionView reloadData];
}

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
  if (self.decoratorSwitch.on) {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 50);
  } else {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 0);
  }
}

- (CGSize)        collectionView:(UICollectionView *)collectionView
                          layout:(UICollectionViewLayout *)collectionViewLayout
 referenceSizeForHeaderInSection:(NSInteger)section
{
  if (self.decoratorSwitch.on) {
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

@end
