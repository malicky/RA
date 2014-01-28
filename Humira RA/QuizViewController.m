//
//  QuizViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-24.
//  Copyright (c) 2012 . All rights reserved.
//

#import "QuizViewController.h"
#import "QuizPageControl.h"

@interface QuizViewController ()

@end

@implementation QuizViewController
@synthesize answered = _answered;
@synthesize delegate = _delegate;
@synthesize firstPage = _firstPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<QuizViewControllerDelegate>)delegate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_firstPage > 0) {
        CGRect pageFrame = [self frameForPageAtIndex:_firstPage];
        [self.pagingScrollView scrollRectToVisible:pageFrame animated:NO];
        _firstPage = 0;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - overrides

- (UIView *)newPage {
    QuizPageControl *page = [[QuizPageControl alloc] initWithDelegate:self];
    return page;
}

- (void)configurePage:(UIView<PageControlBehaviour> *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    page.imageData = [self.pageData objectAtIndex:index];
    
    NSNumber *answer = [self.answered objectForKey:[NSNumber numberWithInteger:index]];
    if (answer) {
        [(QuizPageControl *)page setAnswer:answer.integerValue];
    }
}

- (CGFloat)padding {
    return 0.0f;
}

- (void)didSelectPageControl:(UIView<PageControlBehaviour> *)pageControl withUserInfo:(NSDictionary *)userInfo {
    NSInteger index = pageControl.index;
    NSLog(@"selected page control at index:%d, userinfo:%@", index, userInfo);
    
    NSString *action = [userInfo valueForKey:@"action"];
    if ([action isEqualToString:@"close"]) {
        [self.delegate shouldCloseQuizViewController:self];
    } else if ([action isEqualToString:@"selected"]) {
        NSNumber *selected= [userInfo valueForKey:@"selected"];
        [self.delegate quizViewController:self didSelectAnswer:selected.integerValue atIndex:index];
    }
    
    //a bit hack-ish but I don't want another delegate pointer to an object I already know
//    id<HorizontalScrollViewDelegate> delegate = (id)self.parentViewController;
//    [delegate horizontalScrollViewController:self didSelectPageControl:pageControl atIndex:pageControl.index];
}

@end
