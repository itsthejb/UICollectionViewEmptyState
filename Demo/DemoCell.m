//
//  DemoCell.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "DemoCell.h"

@implementation DemoCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.contentView.backgroundColor = [UIColor purpleColor];
  self.imageView.image = [UIImage imageNamed:@"flower.jpg"];
}

@end
