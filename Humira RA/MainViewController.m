//
//  ViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-20.
//  Copyright (c) 2012 . All rights reserved.
//

#import "MainViewController.h"
#import "PDFViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize topBackgroundImageView = _topBackgroundImageView;
@synthesize bottomBackgroundImageView = _bottomBackgroundImageView;
@synthesize centerButton = _centerButton;
@synthesize wheel = _wheel;
@synthesize transitionToMain = _transitionToMain;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.centerButton.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidUnload
{
    [self setTopBackgroundImageView:nil];
    [self setBottomBackgroundImageView:nil];
    [self setCenterButton:nil];
    [self setWheel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self closeBackground];
    [self retrieveWheel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - rotating wheel delegate

- (void)rotatingWheel:(RotatingWheel *)rotatingWheel tappedSection:(WheelSection)section {
    [self performSegueWithIdentifier:[self segueForCurrentSection] sender:self];
}

#pragma mark - animations

- (IBAction)centerTapped:(id)sender {
    [self closeBackground];
    [self retrieveWheel];
}

- (void)openBackground {
    CGFloat dx = 600;
    if (self.topBackgroundImageView.frame.origin.y != 0) {
        return;
    }
    //top
    CGPoint topCenter = self.topBackgroundImageView.center;
    topCenter.y -= dx;
    //bottom
    CGPoint bottomCenter = self.bottomBackgroundImageView.center;
    bottomCenter.y += dx;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.topBackgroundImageView.center = topCenter;
        self.bottomBackgroundImageView.center = bottomCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeBackground {
    CGFloat dx = 600;
    if (self.topBackgroundImageView.frame.origin.y == 0) {
        return;
    }    
    //top
    CGPoint topCenter = self.topBackgroundImageView.center;
    topCenter.y += dx;
    
    //bottom
    CGPoint bottomCenter = self.bottomBackgroundImageView.center;
    bottomCenter.y -= dx;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.topBackgroundImageView.center = topCenter;
        self.bottomBackgroundImageView.center = bottomCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeWheel:(BOOL)visible withCompletion:(void(^)(BOOL))completion {
    if (visible) {
        [self animateWheelSection];
    }
    
    CGPoint center = self.wheel.center;
    CGPoint buttonCenter = self.centerButton.center;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.wheel.bounds = CGRectZero;
        self.wheel.center = center;
        self.centerButton.bounds = CGRectZero;
        self.centerButton.center = buttonCenter;
    } completion:completion];
}

- (void)retrieveWheel {
    CGPoint center = self.wheel.center;
    CGRect wheelBounds = CGRectMake(0, 0, 427, 427);
    CGRect centerButtonBounds = CGRectMake(0, 0, 213, 213);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.wheel.bounds = wheelBounds;
        self.wheel.center = center;
        self.centerButton.bounds = centerButtonBounds;
        self.centerButton.center = center;
    } completion:^(BOOL finished) {
        NSLog(@"%@\n%@", self.wheel, self.centerButton);
    }];    
}

- (void)animateWheelSection {
    CGPoint wheelCenter = self.wheel.center;
    
    UIImageView *highlight = [[UIImageView alloc] initWithFrame:self.wheel.frame];
    highlight.image = [self imageForCurrentSection];
    highlight.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:highlight];
    
    wheelCenter.y += 1600;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        highlight.bounds = CGRectMake(0, 0, 4000, 4000);
        highlight.center = wheelCenter;
        highlight.alpha = 0.0;
    } completion:^(BOOL finished) {
        [highlight removeFromSuperview];
    }];
}

- (UIImage *)imageForCurrentSection {
    switch (self.wheel.currentSection) {
        case SectionPower:
            return [UIImage imageNamed:@"arrow_red.png"];
        case SectionCommitment:
            return [UIImage imageNamed:@"arrow_green.png"];
        case SectionDream:
            return [UIImage imageNamed:@"arrow_grey.png"];
        default:
            return nil;
    }
}

- (NSString *)segueForCurrentSection {
    switch (self.wheel.currentSection) {
        case SectionPower:
            return @"Power";
        case SectionCommitment:
            return @"Commitment";
        case SectionDream:
            return @"Dream";
        default:
            return nil;
    }    
}

- (UIImage *)previewImageForCurrentSection {
    switch (self.wheel.currentSection) {
        case SectionPower:
            return [UIImage imageNamed:@"preview_power.png"];
        case SectionCommitment:
            return [UIImage imageNamed:@"preview_commitment.jpg"];
        case SectionDream:
            return [UIImage imageNamed:@"preview_dream.png"];
        default:
            return nil;
    }
}

#pragma mark - segue stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PDFViewController class]]) {
        [(PDFViewController *)segue.destinationViewController setPdfFileName:segue.identifier];
    }
}

#pragma mark - section segue delegate

- (void)willTransitionToMainViewController {

}

- (void)willTransitionFromMainViewController:(BOOL)animateWheel {
    [self fadeWheel:animateWheel withCompletion:nil];
    [self openBackground];
}

//- (void)presentViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
////    UIImageView *imageView = [self configureBackgroundImageViewWithViewController:viewController];
//    
////    imageView.frame = CGRectZero;
////    imageView.center = self.view.center;
////    imageView.alpha = 0.0;
//    
//    void (^completionHandler)(void) = [completion copy];
//
//    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{        
////        imageView.bounds = self.view.bounds;
////        imageView.center = self.view.center;
////        imageView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        if (completionHandler) {
//            completionHandler();
//        }
//    }];
//}
//
//- (void)dismissViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
//    void (^completionHandler)(void) = [completion copy];
//    
////    self.backgroundImageView.alpha = 1.0;
//    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{        
////        self.backgroundImageView.bounds = CGRectZero;
////        self.backgroundImageView.center = self.view.center;
////        self.backgroundImageView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [self closeBackground];
//        [self retrieveWheel];
//        if (completionHandler) {
//            completionHandler();
//        }
//    }];
//}

//- (UIImageView *)configureBackgroundImageViewWithViewController:(UIViewController *)presenter {
////    UIView *parentView = presenter.view;
////    parentView.transform = self.view.transform;
////    UIGraphicsBeginImageContext(parentView.bounds.size);
////    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    self.backgroundImageView.image = [self previewImageForCurrentSection];
//    
//    //add translucent layer on top of backgroundImageView
////    CALayer *tlLayer = [CALayer layer];
////    tlLayer.frame = CGRectMake(0, 0, 1024, 768);
////    tlLayer.backgroundColor = [[UIColor blackColor] CGColor];
////    tlLayer.opacity = 0.75;
////    [self.backgroundImageView.layer addSublayer:tlLayer];
//    
//    return self.backgroundImageView;
//}

@end
