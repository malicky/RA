//
//  HorizontalScrollViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import "HorizontalScrollViewController.h"

@interface HorizontalScrollViewController () {
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    CGFloat pageWidth;
}

@end

@implementation HorizontalScrollViewController
@synthesize pagingScrollView = _pagingScrollView;
@synthesize pageData = _imageData;
@synthesize numberOfPages = _numberOfPages;

- (id)init {
    self = [super init];
    if (self) {
        _numberOfPages = 0;
    }
    return self;
}

- (void)loadView 
{    
    // Step 1: make the outer paging scroll view
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.backgroundColor = [UIColor blackColor];
    self.pagingScrollView.showsVerticalScrollIndicator = NO;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.view = self.pagingScrollView;
    
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pagingScrollView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pagingScrollView.frame = self.view.superview.bounds;
    [self configurePagingScrollView];
    [self tilePages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)setImageData:(NSArray *)imageData {
    if (_imageData != imageData) {
        _imageData = imageData;
    }
}

//- (void)didMoveToParentViewController:(UIViewController *)parent {
//
//}

#pragma mark - Tiling and page configuration

- (void)configurePagingScrollView {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    if (self.numberOfPages == 0) {
        self.numberOfPages = 1;
    }
    pageWidth = pagingScrollViewFrame.size.width / self.numberOfPages;
    
    CGSize contentSize = CGSizeMake(pageWidth * self.pageData.count, pagingScrollViewFrame.size.height);
    self.pagingScrollView.contentSize = contentSize;
}

- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
    int lastNeededPageIndex  = ceilf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.pageData.count - 1);
    
    // Recycle no-longer-visible pages 
    for (UIView <PageControlBehaviour> *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            UIView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [self newPage];
            }
            [self configurePage:page forIndex:index];
            [self.pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (UIView *)dequeueRecycledPage
{
    UIView *page = [recycledPages anyObject];
    if (page) {
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIView<PageControlBehaviour> *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

//override this
- (UIView *)newPage {
    PageControl *page = [[PageControl alloc] initWithDelegate:self];
    return page;
}

//override this
- (void)configurePage:(UIView<PageControlBehaviour> *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    page.imageData = [self.pageData objectAtIndex:index];
}

#pragma mark - ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

#pragma mark - Frame calculations

- (CGFloat)padding {
    return 0.0f;
}

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.pagingScrollView.frame;
    frame.origin.x -= [self padding];
    frame.size.width += (2 * [self padding]);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGRect pageFrame = pagingScrollViewFrame;
    
    pageFrame.origin.x = (pageWidth * index) + [self padding];
    pageFrame.origin.y = 0;
    pageFrame.size.width = pageWidth - (2 * [self padding]);

    return pageFrame;
}

#pragma mark - pageControl delegate 

- (void)didSelectPageControl:(PageControl *)pageControl withUserInfo:(NSDictionary *)userInfo {
    NSInteger index = pageControl.index;
    NSLog(@"selected page control at index:%d", index);
    //a bit hack-ish but I don't want another delegate pointer to an object I already know
    id<HorizontalScrollViewDelegate> delegate = (id)self.parentViewController;
    [delegate horizontalScrollViewController:self didSelectPageControl:pageControl atIndex:pageControl.index];
}

@end
