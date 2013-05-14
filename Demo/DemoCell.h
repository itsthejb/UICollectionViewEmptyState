//
//  DemoCell.h
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@interface Header : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UISwitch *testControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@interface Footer : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
