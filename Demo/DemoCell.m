//
//  DemoCell.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import "DemoCell.h"
#import "BlocksKit.h"

@implementation DemoCell
@end

@implementation Header
- (void)awakeFromNib {
  [super awakeFromNib];

  [self.testControl addEventHandler:^(UISwitch *control) {
    if (control.on) {
      self.imageView.alpha = 0.25;
      self.backgroundColor = [UIColor yellowColor];
    } else {
      self.imageView.alpha = 1.0;
    }
  } forControlEvents:UIControlEventValueChanged];

  [self.testControl sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)prepareForReuse {
  [super prepareForReuse];
  self.testControl.on = NO;
}
@end

@implementation Footer

@end