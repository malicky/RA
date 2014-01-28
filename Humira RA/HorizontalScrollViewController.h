//
//  HorizontalScrollViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControlDelegate.h"
#import "PageControl.h"

@class HorizontalScrollViewController;

@protocol HorizontalScrollViewDelegate <NSObject>
@required
- (void)horizontalScrollViewController:(HorizontalScrollViewController *)controller didSelectPageControl:(UIView<PageControlBehaviour> *)pageControl atIndex:(NSInteger)index;

@end

@interface HorizontalScrollViewController : UIViewController <UIScrollViewDelegate, PageControlDelegate>

@property (strong, nonatomic) NSArray *pageData;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) UIScrollView *pagingScrollView;

- (void)configurePage:(UIView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)configurePagingScrollView;
- (void)tilePages;
- (UIView *)dequeueRecycledPage;
- (UIView *)newPage;
- (CGFloat)padding;

@end
