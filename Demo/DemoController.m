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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView 
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCell" forIndexPath:indexPath];
  return cell;
}

@end
