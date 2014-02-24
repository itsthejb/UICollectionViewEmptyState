//
//  SpecClasses.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 24/02/2014.
//  Copyright (c) 2014 Jon Crooke. All rights reserved.
//

#import "SpecClasses.h"

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
