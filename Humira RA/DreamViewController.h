//
//  DreamViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SectionSlideDelegate.h"

@interface DreamViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *dreamToolButton;
@property (weak, nonatomic) IBOutlet UIButton *productivityButton;
@property (weak, nonatomic) IBOutlet UIButton *functionalityButton;
@property (weak, nonatomic) IBOutlet UIScrollView *thumbnailScrollView;

- (IBAction)selectSection:(id)sender;

@end
