//
//  SnapshotTests.m
//  UICollectionViewEmptyState
//
//  Created by Jonathan Crooke on 24/02/2014.
//  Copyright (c) 2014 Jon Crooke. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "DemoController.h"

@interface SnapshotTests : FBSnapshotTestCase
@property (strong) UIWindow *window;
@property (strong) DemoController *controller;
@end

@implementation SnapshotTests

- (void)setUp {
  [super setUp];

  [UIView setAnimationsEnabled:NO];
  [UIApplication sharedApplication].keyWindow.rootViewController = nil;

  self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                       bundle:[NSBundle bundleWithIdentifier:@"com.joncrooke.Demo"]];
  UINavigationController *navController = (id) storyboard.instantiateInitialViewController;
  self.controller = (id) navController.topViewController;
  [self.controller loadView];
  [self.controller viewDidLoad];
  self.window.rootViewController = navController;
  [self.window makeKeyAndVisible];
}

- (void)testInitialAppearance {
  FBSnapshotVerifyView(self.window, nil);
}

- (void)testAddSection {
  self.controller.sectionStepper.value += 1;
  [self.controller.sectionStepper sendActionsForControlEvents:UIControlEventValueChanged];
  FBSnapshotVerifyView(self.window, nil);
}

- (void)testAddSectionRespectingHeader {
  self.controller.sectionStepper.value += 1;
  [self.controller.sectionStepper sendActionsForControlEvents:UIControlEventValueChanged];
  [self.controller.respectHeaderSwitch setOn:YES];
  [self.controller.respectHeaderSwitch sendActionsForControlEvents:UIControlEventValueChanged];
  FBSnapshotVerifyView(self.window, nil);
}

- (void)testAddSectionAndItem {
  self.controller.sectionStepper.value += 1;
  [self.controller.sectionStepper sendActionsForControlEvents:UIControlEventValueChanged];
  self.controller.itemStepper.value += 1;
  [self.controller.itemStepper sendActionsForControlEvents:UIControlEventValueChanged];
  FBSnapshotVerifyView(self.window, nil);
}

@end
