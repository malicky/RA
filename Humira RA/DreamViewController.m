//
//  DreamViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DreamViewController.h"
#import "PDFViewController.h"

@interface DreamViewController ()
@property (strong, nonatomic) NSArray *vcs;
@property (strong, nonatomic) NSArray *submenuButtons;
@property (strong, nonatomic) NSArray *thumbnails;

- (void)selectViewControllerAtIndex:(NSInteger)index;
- (void)configureThumbnailScrollView;
- (void)selectThumbnailAtIndex:(NSInteger)index;
- (UIViewController *)viewControllerBefore:(BOOL)before viewController:(UIViewController *)viewController;
- (UIViewController *)viewControllerForSection:(NSInteger)section;
@end

@implementation DreamViewController
@synthesize contentView;
@synthesize pageControl;
@synthesize dreamToolButton;
@synthesize productivityButton;
@synthesize functionalityButton;
@synthesize thumbnailScrollView;
@synthesize pageViewController = _pageViewController;
@synthesize vcs = _vcs;
@synthesize submenuButtons = _submenuButtons;
@synthesize thumbnails = _thumbnails;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.vcs = [NSArray arrayWithObjects:@"Dream1ViewController", @"Dream2ViewController", @"Dream3ViewController", @"Dream4ViewController", nil];
    self.submenuButtons = [NSArray arrayWithObjects:self.functionalityButton, self.productivityButton, self.dreamToolButton, nil];
    
    self.pageControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.pageControl.numberOfPages = self.vcs.count;
    
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
    
    UIViewController *controller = [self viewControllerForSection:1];
    NSArray *viewControllers = [NSArray arrayWithObject:controller];
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
    [self setDreamToolButton:nil];
    [self setProductivityButton:nil];
    [self setFunctionalityButton:nil];
    [self setThumbnailScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.contentView setGestureRecognizers:self.pageViewController.gestureRecognizers];
    for (UIGestureRecognizer *gr in self.pageViewController.gestureRecognizers) {
        gr.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    for (UIGestureRecognizer *recognizer in self.contentView.gestureRecognizers) {
    //        [self.contentView removeGestureRecognizer:recognizer];
    //    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
    
    UIViewController<SectionSlideDelegate> *topVC = [self.pageViewController.viewControllers lastObject];
    NSArray *popupButtons = topVC.popupButtons;
    for (UIButton *button in popupButtons) {
        CGPoint location = [touch locationInView:topVC.view];
        if (CGRectContainsPoint(button.frame, location)) {
            return NO;
        }
    }
    //    }
    return YES;
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
        self.pageControl.currentPage = index;
        return controller;
    }
    return nil;
}

- (UIViewController *)viewControllerForSection:(NSInteger)section {
    //not sure why but I started the tags for the buttons at 1 and not at 0
    NSString *className = [self.vcs objectAtIndex:section-1];
    id controllerClass = NSClassFromString(className);
    id controller = [[controllerClass alloc] initWithNibName:nil bundle:nil];
    NSAssert(controller, @"controller = nil!");
    return controller;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self.vcs indexOfObject:[[[pageViewController.viewControllers lastObject] class] description]];
    self.pageControl.currentPage = index;
    [self selectThumbnailAtIndex:index];
    [self selectCurrentSection];
}

- (void)selectViewControllerAtIndex:(NSInteger)index {
    UIViewController<SectionSlideDelegate> *viewController = [self.pageViewController.viewControllers lastObject];
    NSInteger currentIndex = [self.vcs indexOfObject:[viewController class].description];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerForSection:index+1]];
    [self.pageViewController setViewControllers:viewControllers direction:index > currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        [self.pageViewController.delegate pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:nil transitionCompleted:finished];
    }];
}

#pragma mark - current section selector

- (void)selectCurrentSection {
    UIViewController<SectionSlideDelegate> *viewController = [self.pageViewController.viewControllers lastObject];
    NSInteger currentSection = viewController.section;
    
    [self.submenuButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = idx == currentSection-1;
    }];
}

- (IBAction)selectSection:(id)sender {
    NSInteger section = [sender tag];
    NSInteger currentSection = self.pageControl.currentPage;
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerForSection:section]];
    [self.pageViewController setViewControllers:viewControllers direction:section > currentSection ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        [self.pageViewController.delegate pageViewController:self.pageViewController didFinishAnimating:YES previousViewControllers:nil transitionCompleted:finished];
    }];
}

#pragma mark - thumbnail scroll view

- (void)configureThumbnailScrollView {
//    self.thumbnailScrollView.delegate = self;
    self.thumbnailScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th_holder"]];
    self.thumbnails = [NSArray arrayWithObjects:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dream1"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dream2_1"]],
                       [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dream2_2"]],nil];
    
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
