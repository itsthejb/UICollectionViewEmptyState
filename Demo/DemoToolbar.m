//
//  DemoToolbar.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 26/02/2015.
//  Copyright (c) 2015 Jonathan Crooke. All rights reserved.
//

#import "DemoToolbar.h"

@implementation DemoToolbar

- (void)awakeFromNib {
  [super awakeFromNib];

  // #hacky, but this is a demo app, remember ;)
  [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    if ([view isKindOfClass:[UIImageView class]]) {
      view.hidden = YES;
    }
  }];
}

@end
