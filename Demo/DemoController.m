//
//  JCViewController.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "DemoController.h"
#import "DemoCell.h"

@interface DemoController ()

@end

@implementation DemoController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
  return 5;
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
  cell.imageView.image = [UIImage imageNamed:images[indexPath.section]];

  return cell;
}

@end
