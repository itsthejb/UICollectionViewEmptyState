//
//  JCViewController.h
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 14/05/2013.
//  Copyright (c) 2013 Jon Crooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoController : UICollectionViewController
@property (strong, nonatomic) IBOutlet UIStepper *sectionStepper;
@property (strong, nonatomic) IBOutlet UIStepper *itemStepper;
@property (strong, nonatomic) IBOutlet UILabel *emptyView;
@property (strong, nonatomic) IBOutlet UISwitch *headerSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *respectHeaderSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *insetsSwitch;
@property (strong, nonatomic) IBOutlet UIToolbar *topToolbar;
@end
