//
//  SectionSegueDelegate.h
//  Humira RA
//
//  Created by Developer on 12-02-21.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SectionSegueDelegate <NSObject>
@required
//- (void)presentViewController:(UIViewController *)viewController completion:(void(^)(void))completion;
//- (void)dismissViewController:(UIViewController *)viewController completion:(void(^)(void))completion;

- (void)willTransitionFromMainViewController:(BOOL)animateWheel;
- (void)willTransitionToMainViewController;

@optional

@property (assign, nonatomic) BOOL transitionToMain;

@end
