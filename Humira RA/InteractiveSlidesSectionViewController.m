//
//  InteractiveSlidesSectionViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-05.
//  Copyright (c) 2012 . All rights reserved.
//

#import "InteractiveSlidesSectionViewController.h"
#import "InteractiveSlidesViewController.h"

@interface InteractiveSlidesSectionViewController () {
    NSMutableSet *visibleViewControllers;
    NSMutableSet *recycledViewControllers;
}

@property (strong, nonatomic) NSArray *configuredViewControllers;
@property (strong, nonatomic) NSMutableSet *sectionsAnswered;

- (void)configurePagingScrollView;
- (void)configurePagingScrollViewContentSizeForNumberOfSections:(NSInteger)sections;
- (void)tilePages;
- (void)configureViewController:(UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)viewController forIndex:(NSUInteger)index;
- (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)dequeueRecycledViewController;
- (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)viewControllerAtIndex:(NSInteger)index;
- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

@end

@implementation InteractiveSlidesSectionViewController
@synthesize contentView;
@synthesize pageControl;
@synthesize pagingScrollView;
@synthesize configuredViewControllers;
@synthesize sectionsAnswered;
@synthesize answerData;

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
    self.sectionsAnswered = [NSMutableSet setWithCapacity:3];
    self.answerData = [NSMutableDictionary dictionaryWithCapacity:5];
    
    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"interactive_slides" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    NSString *error = nil;
    id plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&error];
    NSAssert(error == nil, @"error:%@", error);
    self.configuredViewControllers = plist;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"move");
    [self configurePagingScrollView];
    [self tilePages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setPageControl:nil];
    [self setPagingScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning remove after re-integration
    [self configuredViewControllers];
    [self tilePages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - paging scrollview (horizontal scrolling of pages)

- (void)configurePagingScrollView {
    self.pagingScrollView.delegate = self;
    //    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    self.pagingScrollView.minimumZoomScale = 1.0;
    //    self.pagingScrollView.maximumZoomScale = 4.0;
    [self configurePagingScrollViewContentSizeForNumberOfSections:1];
}

- (void)configurePagingScrollViewContentSizeForNumberOfSections:(NSInteger)sections {
    if (sections <= 0) {
        sections = 1;
    }
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGSize contentSize = CGSizeMake(pagingScrollViewFrame.size.width * (MIN(sections, self.configuredViewControllers.count)), pagingScrollViewFrame.size.height);
    self.pagingScrollView.contentSize = contentSize;
    self.pagingScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
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
    for (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *page in visibleViewControllers) {
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
            UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *page = [self viewControllerAtIndex:index];
            
            [self configureViewController:page forIndex:index];
            
            [self addChildViewController:page];
            [self.pagingScrollView addSubview:page.view];
            [page didMoveToParentViewController:self];
            [visibleViewControllers addObject:page];
        }
    }
}

- (void)configureViewController:(UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)viewController forIndex:(NSUInteger)index {
    viewController.index = index;
    viewController.pageData = [self.configuredViewControllers objectAtIndex:index];
    viewController.view.frame = [self frameForPageAtIndex:index];
//    if ([self.sectionsAnswered containsObject:[NSNumber numberWithInteger:viewController.index]]) {
//        viewController.alreadyAnswered = YES;
//    }
}

- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *page in visibleViewControllers) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)viewControllerAtIndex:(NSInteger)index {
    UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *viewController = [self dequeueRecycledViewController];
    if (!viewController) {
        viewController = [[InteractiveSlidesViewController alloc] initWithNibName:nil bundle:nil andDelegate:self];
    }
//    viewController.delegate = self;
    return viewController;
}

- (UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *)dequeueRecycledViewController
{
    UIViewController<InteractiveSlidesBaseViewControllerBehaviour> *page = [recycledViewControllers anyObject];
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
    CGRect visibleBounds = self.pagingScrollView.bounds;
    NSInteger currentPage = visibleBounds.origin.x / visibleBounds.size.width;
    self.pageControl.currentPage = currentPage;
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [[visibleViewControllers anyObject] view];
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"scroll view: %@", NSStringFromCGRect(self.pagingScrollView.frame));
//    NSLog(@"scroll view: %@", NSStringFromCGSize(self.pagingScrollView.contentSize));
//    
//    UIView *visibleView = [[visibleViewControllers anyObject] view];
//    NSLog(@"visible view: %@", NSStringFromCGRect(visibleView.frame));
//}

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

#pragma mark - InteractiveSlidesBaseViewController delegate

- (void)viewController:(UIViewController *)viewController didSelectAnswersWithValues:(NSDictionary *)answerValues inSection:(NSInteger)section {
    if (answerValues) {
        [self.answerData setObject:answerValues forKey:[NSNumber numberWithInteger:section]];
    }
    self.pageControl.numberOfPages = MIN(self.configuredViewControllers.count, self.answerData.allKeys.count +1);
    [self configurePagingScrollViewContentSizeForNumberOfSections:self.pageControl.numberOfPages];
}

- (void)viewController:(UIViewController *)viewController mightHaveDeselectedAnAnswerInSection:(NSInteger)section {
    NSDictionary *sectionData = [self.answerData objectForKey:[NSNumber numberWithInteger:section]];
    if (sectionData) {
        [self.answerData removeObjectForKey:[NSNumber numberWithInteger:section]];
        self.pageControl.numberOfPages = MIN(self.configuredViewControllers.count, section+1);
        [self configurePagingScrollViewContentSizeForNumberOfSections:section+1];
    }
}

- (NSDictionary *)aggregatedPreviousAnswersForSection:(NSInteger)section {
    NSMutableDictionary *result = nil;
    if (section > 0) {
        result = [NSMutableDictionary dictionaryWithCapacity:section];
        
        for (int i=0; i<section; i++) {
            NSDictionary *aDict = [self.answerData objectForKey:[NSNumber numberWithInteger:i]];
            [aDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *value, BOOL *stop) {
                NSNumber *oldValue = [result valueForKey:key];
                NSNumber *newValue = [NSNumber numberWithInteger:oldValue.integerValue + value.integerValue];
                [result setValue:newValue forKey:key];
            }];
        }
    }
    return result;
}

@end
