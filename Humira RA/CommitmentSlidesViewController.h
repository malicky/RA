//
//  CommitmentSlidesViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-28.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CommitmentSlidesViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *thumbnailScrollView;

- (void)selectViewControllerAtIndex:(NSInteger)index;

@end
