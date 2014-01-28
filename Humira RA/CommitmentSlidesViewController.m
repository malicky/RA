//
//  CommitmentSlidesViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-28.
//  Copyright (c) 2012 . All rights reserved.
//

#import "CommitmentSlidesViewController.h"

#ifndef COMMITMENT_APP
#import "Commitment0ViewController.h"
#endif

#import "Commitment1ViewController.h"
#import "Commitment2ViewController.h"
#import "Commitment3ViewController.h"
#import "Commitment4ViewController.h"
#import "Commitment5ViewController.h"
#import "PDFViewController.h"

@interface CommitmentSlidesViewController ()
@property (strong, nonatomic) NSArray *vcs;
@property (strong, nonatomic) NSArray *thumbnails;

- (void)configureThumbnailScrollView;
- (void)selectThumbnailAtIndex:(NSInteger)index;
- (UIViewController *)viewControllerBefore:(BOOL)before viewController:(UIViewController *)viewController;
- (UIViewController *)viewControllerForSection:(NSInteger)section;

@end

@implementation CommitmentSlidesViewController
@synthesize pageViewController = _pageViewController;
@synthesize contentView = _contentView;
@synthesize pageControl = _pageControl;
@synthesize thumbnailScrollView = _thumbnailScrollView;
@synthesize vcs = _vcs;
@synthesize thumbnails = _thumbnails;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
#ifndef COMMITMENT_APP    
    //regular Committment
    self.vcs = [NSArray arrayWithObjects:@"Commitment0ViewController", /*@"Commitment1ViewController", @"Commitment2ViewController", @"Commitment3ViewController", @"Commitment4ViewController", @"Commitment5ViewController", */nil];
    
    Commitment0ViewController *vc = [[Commitment0ViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [self configureThumbnailScrollView];
    [self selectThumbnailAtIndex:0];
    return;
#endif    
    //commitment app
    self.vcs = [NSArray arrayWithObjects:@"Commitment1ViewController", @"Commitment2ViewController", @"Commitment3ViewController", @"Commitment4ViewController", @"Commitment5ViewController", nil];
    
    self.pageControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl 
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal 
                                                                            options:options];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.contentView.bounds;
    
    [self addChildViewController:self.pageViewController];
    [self.contentView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerForSection:1]];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageControl.currentPage = 0;
    
    [self addChildViewController:self.pageViewController];
    [self.contentView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self configureThumbnailScrollView];
    [self selectThumbnailAtIndex:0];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setPageControl:nil];
    [self setThumbnailScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentView setGestureRecognizers:self.pageViewController.gestureRecognizers];
    for (UIGestureRecognizer *gr in self.contentView.gestureRecognizers) {
        gr.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIGestureRecognizer *recognizer in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:recognizer];
    }
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        UIViewController *topVC = [self.pageViewController.viewControllers lastObject];
        if ([topVC respondsToSelector:@selector(popupButton)]) {
            UIButton *button = [topVC performSelector:@selector(popupButton)];
            CGPoint location = [touch locationInView:topVC.view];
            if (CGRectContainsPoint(button.frame, location)) {
                return NO;
            }
        }
        
        if ([topVC respondsToSelector:@selector(popupButtons)]) {
            NSArray *popupButtons = [topVC performSelector:@selector(popupButtons)];
            for (UIButton *button in popupButtons) {
                CGPoint location = [touch locationInView:topVC.view];
                if (CGRectContainsPoint(button.frame, location)) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);;
}

#pragma mark - pageviewcontroller datasource & delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self viewControllerBefore:YES viewController:viewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self viewControllerBefore:NO viewController:viewController];
}

- (UIViewController *)viewControllerBefore:(BOOL)before viewController:(UIViewController *)viewController {
    NSInteger index = self.pageControl.currentPage;
    
    index = before ? index - 1 : index + 1;
    
    if (index >= 0 && index < self.vcs.count) {
        NSString *className = [self.vcs objectAtIndex:index];
        id controllerClass = NSClassFromString(className);
        id controller = [[controllerClass alloc] initWithNibName:nil bundle:nil];
        NSAssert(controller, @"controller = nil!");
        return controller;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self.vcs indexOfObject:[[[pageViewController.viewControllers lastObject] class] description]];
    self.pageControl.currentPage = index;
    [self selectThumbnailAtIndex:index];
}

- (UIViewController *)viewControllerForSection:(NSInteger)section {
    //not sure why but I started the tags for the buttons at 1 and not at 0
    NSString *className = [self.vcs objectAtIndex:section-1];
    id controllerClass = NSClassFromString(className);
    id controller = [[controllerClass alloc] initWithNibName:nil bundle:nil];
    NSAssert(controller, @"controller = nil!");
    return controller;
}

- (void)selectViewControllerAtIndex:(NSInteger)index {
    UIViewController *viewController = [self.pageViewController.viewControllers lastObject];
    NSInteger currentIndex = [self.vcs indexOfObject:[viewController class].description];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerForSection:index+1]];
    [self.pageViewController setViewControllers:viewControllers direction:index > currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        [self.pageViewController.delegate pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:nil transitionCompleted:finished];
    }];
}

#pragma mark - thumbnail scroll view

- (void)configureThumbnailScrollView {
//    self.thumbnailScrollView.delegate = self;
    self.thumbnailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th_holder"]];
#ifndef COMMITMENT_APP
    self.thumbnails = [NSArray arrayWithObjects:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_0"]], nil];
#endif
    self.thumbnails = [NSArray arrayWithObjects:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_1"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_2_fr"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_3_fr"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_4_fr"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Commitment_5_fr"]], nil];
    
    [self.thumbnails enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = [self frameForThumbnailAtIndex:idx];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.tag = idx;
        view.userInteractionEnabled = YES;
        
        view.layer.borderColor = [[UIColor blackColor] CGColor];
        view.layer.borderWidth = 1.5f;
        
        view.layer.cornerRadius = 3.0f;
        
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, 5);
        view.layer.shadowOpacity = 1.0f;
        view.layer.shadowRadius = 5.0f;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailSelectedByRecognizer:)];
        [view addGestureRecognizer:recognizer];
        
        [self.thumbnailScrollView addSubview:view];
    }];
}

- (void)selectThumbnailAtIndex:(NSInteger)index {
    [self.thumbnails enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.layer.shadowColor = idx == index ? [[UIColor redColor] CGColor] : [[UIColor blackColor] CGColor];
    }];
}

- (void)thumbnailSelectedByRecognizer:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        UIView *sender = recognizer.view;
        [self selectViewControllerAtIndex:sender.tag];
    }
}

#define PADDING     4.0f
#define PAGEWIDTH   140.0f
#define PAGEHEIGHT  80.0f

- (CGRect)frameForThumbnailAtIndex:(NSInteger)index {
    CGRect pageFrame = CGRectMake(0, 0, PAGEWIDTH, PAGEHEIGHT);
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (PAGEWIDTH * index) + PADDING;
    pageFrame.origin.y = PADDING;
    pageFrame.size.height -= (2 * PADDING);
    return pageFrame;
}

#pragma mark - segue stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PDFViewController class]]) {
        [(PDFViewController *)segue.destinationViewController setPdfFileName:segue.identifier];
    }
}

@end
