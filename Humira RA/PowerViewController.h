//
//  PowerViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-21.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PowerViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *clinicalResponseButton;
@property (weak, nonatomic) IBOutlet UIButton *remissionButton;
@property (weak, nonatomic) IBOutlet UIButton *radiographicProgressionButton;
@property (weak, nonatomic) IBOutlet UIButton *powerToolButton;
@property (weak, nonatomic) IBOutlet UIScrollView *thumbnailScrollView;

- (void)selectCurrentSection;

- (IBAction)selectSection:(id)sender;

@end
