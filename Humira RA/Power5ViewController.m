//
//  Power5ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-01.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Power5ViewController.h"
#import "PowerToolSection1ViewController.h"
#import "PowerToolSection2ViewController.h"
#import "PowerToolSection3ViewController.h"

@interface Power5ViewController () {
    NSMutableSet *visiblePageViewControllers;
}

@property (strong, nonatomic) NSMutableSet *sectionsAnswered;
@property (strong, nonatomic) NSArray *sectionButtons;

- (void)configurePagingScrollView;
- (void)tilePages;
- (void)configureViewController:(UIViewController<PowerToolSectionBaseViewControllerDelegate> *)viewController forIndex:(NSUInteger)index;
- (UIViewController<PowerToolSectionBaseViewControllerDelegate, SectionSlideDelegate> *)viewControllerAtIndex:(NSInteger)index;
- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (NSInteger)currentlyVisiblePageIndex;

@end

@implementation Power5ViewController
@synthesize pagingScrollView;
@synthesize wallImageView;
@synthesize configuredPageViewControllers;
@synthesize popupButtons;
@synthesize remissionButton;
@synthesize clinicalResponseButton;
@synthesize radiographicProgressionButton;
@synthesize sectionsAnswered;
@synthesize sectionButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.section = 4;
        visiblePageViewControllers = [NSMutableSet setWithCapacity:2];
        self.sectionsAnswered = [NSMutableSet setWithCapacity:3];
        self.popupButtons = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.configuredPageViewControllers = [NSArray arrayWithObjects:@"PowerToolSection1ViewController", @"PowerToolSection2ViewController", @"PowerToolSection3ViewController", nil];
    
    //bottom right buttons:
    self.remissionButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.clinicalResponseButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.radiographicProgressionButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    self.sectionButtons = [NSArray arrayWithObjects:self.remissionButton, self.clinicalResponseButton, self.radiographicProgressionButton, nil];
    [self.popupButtons addObjectsFromArray:self.sectionButtons];
    
    [self configurePagingScrollView];
    [self tilePages];
}

- (void)viewDidUnload
{
    [self setPagingScrollView:nil];
    [self setWallImageView:nil];
    [self setRemissionButton:nil];
    [self setClinicalResponseButton:nil];
    [self setRadiographicProgressionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - paging scrollview (horizontal scrolling of pages)

- (void)configurePagingScrollView {
    self.pagingScrollView.delegate = self;
    //    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    self.pagingScrollView.minimumZoomScale = 1.0;
    //    self.pagingScrollView.maximumZoomScale = 4.0;
    
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    NSUInteger pageCount = self.configuredPageViewControllers.count;
    
    CGSize contentSize = CGSizeMake(pagingScrollViewFrame.size.width * (pageCount), pagingScrollViewFrame.size.height);
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
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.configuredPageViewControllers.count - 1);
    
    NSMutableSet *recycledPages = [NSMutableSet setWithCapacity:2];
    // Recycle no-longer-visible pages 
    for (UIViewController<PowerToolSectionBaseViewControllerDelegate, SectionSlideDelegate> *page in visiblePageViewControllers) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page.view removeFromSuperview];
            [page removeFromParentViewController];
            [self.popupButtons removeObjectsInArray:page.popupButtons];
        }
    }
    [visiblePageViewControllers minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageViewControllerForIndex:index]) {
            UIViewController<PowerToolSectionBaseViewControllerDelegate, SectionSlideDelegate> *page = [self viewControllerAtIndex:index];
            
            [self configureViewController:page forIndex:index];
            
            [self addChildViewController:page];
            [self.pagingScrollView addSubview:page.view];
            [page didMoveToParentViewController:self];
            [visiblePageViewControllers addObject:page];
            [self.popupButtons addObjectsFromArray:page.popupButtons];
        }
    }
}

- (void)configureViewController:(UIViewController<PowerToolSectionBaseViewControllerDelegate> *)viewController forIndex:(NSUInteger)index {
    viewController.index = index;
    viewController.view.frame = [self frameForPageAtIndex:index];
    if ([self.sectionsAnswered containsObject:[NSNumber numberWithInteger:viewController.section]]) {
        viewController.alreadyAnswered = YES;
    }
}

- (BOOL)isDisplayingPageViewControllerForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (UIViewController<PowerToolSectionBaseViewControllerDelegate> *page in visiblePageViewControllers) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (UIViewController<PowerToolSectionBaseViewControllerDelegate, SectionSlideDelegate> *)viewControllerAtIndex:(NSInteger)index {
    NSString *name = [self.configuredPageViewControllers objectAtIndex:index];
    id classObj = NSClassFromString(name);
    NSAssert(classObj, @"no class with name %@", name);
    UIViewController<PowerToolSectionBaseViewControllerDelegate, SectionSlideDelegate> *viewController = [[classObj alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    return viewController;
}

#pragma mark - power tool scroll delegate

- (void)answerBoxWillMove {
    NSLog(@"will move");
//    self.pagingScrollView.scrollEnabled = NO;
}

- (void)answerBoxDidMove {
    NSLog(@"did move");
//    self.pagingScrollView.scrollEnabled = YES;
}

- (void)shouldScrollToSection:(NSInteger)section {
    [self.pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:section] animated:YES];
}

#pragma mark - section answer delegate 

- (void)didAnswerPowerToolSection:(NSInteger)section {
    //build the wall!
    NSNumber *sectionNumber = [NSNumber numberWithInteger:section];
    if (![self.sectionsAnswered containsObject:sectionNumber]) {
        [self.sectionsAnswered addObject:sectionNumber];
    }
    if (self.sectionsAnswered.count == 0) {
        return;
    }
    
    NSString *name = [NSString stringWithFormat:@"wall_stage_%d", self.sectionsAnswered.count+1];
    UIImage *image = [UIImage imageNamed:name];
    self.wallImageView.image = image;
}

#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
    
    NSInteger currentPageIndex = [self currentlyVisiblePageIndex];
    for (UIButton *button in self.sectionButtons) {
        button.selected = button.tag == currentPageIndex;
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGRect visibleBounds = self.pagingScrollView.bounds;
//    NSInteger currentPage = visibleBounds.origin.x / visibleBounds.size.width;
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

- (NSInteger)currentlyVisiblePageIndex {
    CGRect visibleBounds = self.pagingScrollView.bounds;
    NSInteger currentPage = visibleBounds.origin.x / visibleBounds.size.width;
    return currentPage;
}

- (IBAction)selectSubsection:(id)sender {
    NSInteger newPage = [sender tag];
    [self.pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:newPage] animated:NO];
}

@end
