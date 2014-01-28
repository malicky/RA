//
//  CommitmentViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import "CommitmentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommitmentViewController ()

@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UIView *popupView;

- (void)pageDataFromFileName:(NSString *)fileName withResult:(void(^)(NSArray *result, NSError *error))block;

@end

@implementation CommitmentViewController
@synthesize topView;
@synthesize bottomView;
@synthesize topViewController = _topViewController;
@synthesize bottomViewController = _bottomViewController;
@synthesize popupViewController = _popupViewController;
@synthesize answered = _answered;
@synthesize dimView = _dimView;
@synthesize popupView = _popupView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HorizontalScrollViewController *top = [[HorizontalScrollViewController alloc] init];
    [self pageDataFromFileName:@"commitment_top" withResult:^(NSArray *result, NSError *error) {
        top.pageData = result;
        NSAssert(!error, @"error:%@ ", error);
    }];
    top.numberOfPages = 4;
    top.view.backgroundColor = [UIColor clearColor];
    
    self.topViewController = top;
    
    [self addChildViewController:self.topViewController];
    [self.topView addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    
    HorizontalScrollViewController *bottom = [[HorizontalScrollViewController alloc] init];
    [self pageDataFromFileName:@"commitment_bottom" withResult:^(NSArray *result, NSError *error) {
        bottom.pageData = result;
        NSAssert(!error, @"error:%@ ", error);
    }];
    bottom.numberOfPages = 4;
    bottom.view.backgroundColor = [UIColor clearColor];
    
    self.bottomViewController = bottom;
    [self addChildViewController:self.bottomViewController];
    [self.bottomView addSubview:self.bottomViewController.view];
    [self.bottomViewController didMoveToParentViewController:self];
    
    self.answered = [NSMutableDictionary dictionaryWithCapacity:5];
}

- (void)viewDidUnload
{
    [self setTopView:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)pageDataFromFileName:(NSString *)fileName withResult:(void(^)(NSArray *result, NSError *error))block {
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSData *fileData = [NSData dataWithContentsOfFile:file];
    NSError *error = nil;
    NSArray *imageData = [NSPropertyListSerialization propertyListWithData:fileData options:NSPropertyListImmutable format:NULL error:&error];
    NSAssert(block, @"block is nil");
    block(imageData, error);
}

#pragma mark - horizontal scroll view delegate

- (void)horizontalScrollViewController:(HorizontalScrollViewController *)controller didSelectPageControl:(PageControl *)pageControl atIndex:(NSInteger)index {
    self.dimView = [[UIView alloc] initWithFrame:self.view.frame];
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    [self.view addSubview:self.dimView];
    
    self.popupView = [[UIView alloc] initWithFrame:CGRectInset(self.view.frame, 40, 101.5)];
    self.popupView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.popupView];
    
    NSString *fileName = @"abbot_details";
    
//    if (controller == self.topViewController) {
//        fileName = @"abbot_details";
//    } else if (controller == self.bottomViewController) {
//        fileName = @"cra_details";
//    }
    
    QuizViewController *qController = [[QuizViewController alloc] initWithNibName:nil bundle:nil delegate:self];
    [self pageDataFromFileName:fileName withResult:^(NSArray *result, NSError *error) {
        qController.pageData = result;
        qController.numberOfPages = 1; //default
        qController.answered = self.answered;
        qController.firstPage = index;
        NSAssert(!error, @"error:%@ ", error);
    }];
    
    self.popupViewController = qController;
    self.popupViewController.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:qController];
    [self.popupView addSubview:qController.view];
    [qController didMoveToParentViewController:self];
}

#pragma mark - quiz view controller delegate

- (void)quizViewController:(UIViewController *)viewController didSelectAnswer:(NSInteger)answer atIndex:(NSInteger)index {
    [self.answered setObject:[NSNumber numberWithInteger:answer] forKey:[NSNumber numberWithInteger:index]];
    NSLog(@"answered:%@", self.answered);
}

- (void)shouldCloseQuizViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
    [self.popupView removeFromSuperview];
    [self.dimView removeFromSuperview];
    [self.answered removeAllObjects];
}

- (IBAction)selectSection:(UIButton *)sender {
    NSInteger sectionIndex = sender.tag;
    
    self.dimView = [[UIView alloc] initWithFrame:self.view.frame];
    self.dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    [self.view addSubview:self.dimView];
    
    self.popupView = [[UIView alloc] initWithFrame:CGRectInset(self.view.frame, 40, 101.5)];
    self.popupView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.popupView];
    
    NSString *fileName = @"abbot_details_fr";
    
    QuizViewController *qController = [[QuizViewController alloc] initWithNibName:nil bundle:nil delegate:self];
    [self pageDataFromFileName:fileName withResult:^(NSArray *result, NSError *error) {
        qController.pageData = result;
        qController.numberOfPages = 1; //default
        qController.answered = self.answered;
        qController.firstPage = sectionIndex;
        NSAssert(!error, @"error:%@ ", error);
    }];
    
    self.popupViewController = qController;
    self.popupViewController.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:qController];
    [self.popupView addSubview:qController.view];
    [qController didMoveToParentViewController:self];
}

@end
