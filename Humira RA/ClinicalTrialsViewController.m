//
//  ClinicalTrialsViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ClinicalTrialsViewController.h"
#import "HorizontallyScrollingViewControllerDelegate.h"

@interface ClinicalTrialsViewController () {
    NSMutableSet *visibleViewControllers;
    NSMutableSet *recycledViewControllers;
}

@property (strong, nonatomic) NSArray *configuredViewControllers;

- (void)configurePagingScrollView;
- (void)tilePages;
- (void)configureViewController:(UIViewController<HorizontallyScrollingViewControllerDelegate> *)viewController forIndex:(NSUInteger)index;
- (UIViewController *)dequeueRecycledViewController;
- (UIViewController<HorizontallyScrollingViewControllerDelegate> *)viewControllerAtIndex:(NSInteger)index;
- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)presentPagingScrollViewAtIndex:(NSInteger)index;
- (void)dismissPagingScrollView;

@end

@implementation ClinicalTrialsViewController
@synthesize pagingScrollView;
@synthesize configuredViewControllers;
@synthesize dimView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    visibleViewControllers = [NSMutableSet setWithCapacity:2];
    recycledViewControllers = [NSMutableSet setWithCapacity:2];
    self.configuredViewControllers = [NSArray arrayWithObjects:@"Trials1ViewController", @"Trials2ViewController", @"Trials3ViewController", @"Trials4ViewController", @"Trials5ViewController", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero]; //the center
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidUnload
{
    [self setPagingScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectIndex:(id)sender {
    [self presentPagingScrollViewAtIndex:[sender tag]];
}

#pragma mark - paging scrollview (horizontal scrolling of pages)

- (void)configurePagingScrollView {
    self.pagingScrollView.delegate = self;
    //    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    self.pagingScrollView.minimumZoomScale = 1.0;
    //    self.pagingScrollView.maximumZoomScale = 4.0;
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGSize contentSize = CGSizeMake(pagingScrollViewFrame.size.width * self.configuredViewControllers.count, pagingScrollViewFrame.size.height);
    self.pagingScrollView.contentSize = contentSize;
    self.pagingScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.pagingScrollView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.pagingScrollView.layer.shadowOffset = CGSizeMake(0, 6);
    self.pagingScrollView.layer.shadowOpacity = 0.5f;
    self.pagingScrollView.layer.shadowRadius = 5.0f;
    self.pagingScrollView.layer.masksToBounds = NO;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark Tiling and page configuration

- (void)tilePages {
    // Calculate which pages are visible
    CGRect visibleBounds = self.pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.configuredViewControllers.count - 1);
    
    // Recycle no-longer-visible pages 
    for (UIViewController<HorizontallyScrollingViewControllerDelegate> *page in visibleViewControllers) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledViewControllers addObject:page];
            [page.view removeFromSuperview];
            [page removeFromParentViewController];
        }
    }
    [visibleViewControllers minusSet:recycledViewControllers];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageViewControllerForIndex:index]) {
            UIViewController<HorizontallyScrollingViewControllerDelegate> *page = [self viewControllerAtIndex:index];
            
            [self configureViewController:page forIndex:index];
            
            [self addChildViewController:page];
            [self.pagingScrollView addSubview:page.view];
            [page didMoveToParentViewController:self];
            [visibleViewControllers addObject:page];
        }
    }
}

- (void)configureViewController:(UIViewController<HorizontallyScrollingViewControllerDelegate, TrialsBaseViewControllerDelegate> *)viewController forIndex:(NSUInteger)index {
    viewController.index = index;
    viewController.delegate = self;
    viewController.view.frame = [self frameForPageAtIndex:index];
}

- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIViewController<HorizontallyScrollingViewControllerDelegate> *page in visibleViewControllers) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    UIViewController *viewController = [self dequeueRecycledViewController];
    if (!viewController) {
        NSString *className = [self.configuredViewControllers objectAtIndex:index];
        id controllerClass = NSClassFromString(className);
        id controller = [[controllerClass alloc] initWithNibName:nil bundle:nil];
        NSAssert(controller, @"controller = nil!");
        viewController = controller;
    }
    //    viewController.delegate = self;
    return viewController;
}

- (UIViewController *)dequeueRecycledViewController
{
    [recycledViewControllers removeAllObjects];
    return nil;
    
    UIViewController *page = [recycledViewControllers anyObject];
    if (page) {
        [recycledViewControllers removeObject:page];
    }
    return page;
}

#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGRect visibleBounds = self.pagingScrollView.bounds;
//    NSInteger currentPage = visibleBounds.origin.x / visibleBounds.size.width;
//    self.pageControl.currentPage = currentPage;
}

#pragma mark Frame calculations

#define PADDING  0.0f

- (CGRect)frameForPagingScrollView 
{
    CGRect frame = self.pagingScrollView.frame;
    
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    //    frame.size.height -= 20; //status bar
    //    frame.size.height -= 49; //tab bar   
    //    frame.size.height -= 44; //nav bar   
    
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    pageFrame.origin.y = 0;
    return pageFrame;
}

#pragma mark - present and dismiss paging scroll view

- (void)presentPagingScrollViewAtIndex:(NSInteger)index {
    CGRect pagingScrollViewFrame = CGRectMake(0, 128, 1024, 492);
    self.pagingScrollView.frame = pagingScrollViewFrame;
    
    [self configurePagingScrollView];
    [self tilePages];
    
    [self.pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:index] animated:NO];
    
    self.dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self.view addSubview:self.dimView];
    
//    void (^completionBlock)(void) = [block copy]; //we don't need that - UIView transitionWithView should really take care of this!

    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self.view addSubview:self.pagingScrollView];
    } completion:nil];
}

- (void)dismissPagingScrollView {
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.pagingScrollView removeFromSuperview];
        [self.dimView removeFromSuperview];
    } completion:^(BOOL finished) {
        self.dimView = nil;
    }];
}

#pragma mark - Trial Base View Controller Delegate

- (void)closeTrialViewController {
    [self dismissPagingScrollView];
}

@end
