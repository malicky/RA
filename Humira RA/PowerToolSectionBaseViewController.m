//
//  PowerToolSectionBaseViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-01.
//  Copyright (c) 2012 . All rights reserved.
//

#import "PowerToolSectionBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PowerToolSectionBaseViewController ()
@property (strong, nonatomic) UIView *popoutView;
@property (assign, nonatomic) CGRect popoutViewOriginFrame;

- (void)popoutAnswerButtonView:(UIButton *)button;
- (UIView *)imageViewFromPopout;
- (void)addView:(UIView *)view toAnswerDock:(UIView *)answerDock;
- (UIView *)correctAnswerViewForDock:(UIView *)dock;
- (UIView *)imageCopyForView:(UIView *)view;
- (UIView *)checkForDock:(UIView *)dock;
- (void)returnAnswerToOrigin;

@end

@implementation PowerToolSectionBaseViewController
@synthesize index = _index;
@synthesize section;
@synthesize answerButton1;
@synthesize answerButton2;
@synthesize answerButton3;
@synthesize answerButton4;
@synthesize answerDockButtonTop;
@synthesize answerDockButtonBottom;
@synthesize popupButtons;
@synthesize delegate;
@synthesize popoutView = _popoutView;
@synthesize popoutViewOriginFrame = _popoutViewFrame;
@synthesize topCheck = _topCheck;
@synthesize bottomCheck = _bottomCheck;
@synthesize alreadyAnswered = _alreadyAnswered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.popupButtons = [NSArray arrayWithObjects:self.answerButton1, self.answerButton2, self.answerButton3, self.answerButton4, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)setAlreadyAnswered:(BOOL)alreadyAnswered {
    _alreadyAnswered = alreadyAnswered;
    if (alreadyAnswered) {
        UIView *correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockButtonTop];
        [self addView:correctAnswerImageView toAnswerDock:self.answerDockButtonTop];
        correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockButtonBottom];
        [self addView:correctAnswerImageView toAnswerDock:self.answerDockButtonBottom];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    NSLog(@"began: %@", NSStringFromCGPoint(location));
    BOOL answerButtonTouched = NO;
    UIButton *tappedButton = nil;
    for (UIButton *answerButton in self.popupButtons) {
        if (CGRectContainsPoint(answerButton.frame, location)) {
            answerButtonTouched = YES;
            tappedButton = answerButton;
            break;
        }
    }
    
    if (answerButtonTouched) {
        [self popoutAnswerButtonView:tappedButton];
        [self.delegate answerBoxWillMove];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    // get delta
//    CGPoint previousLocation = [touch previousLocationInView:self.view];
//    CGFloat delta_x = location.x - previousLocation.x;
//    CGFloat delta_y = location.y - previousLocation.y;    
    
    // move button
    self.popoutView.center = location;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL (^answerIsCorrectFor)(UIView *) = ^(UIView *dockView) {
        BOOL result = dockView.tag == self.popoutView.tag;
        return result;
    };
    UIView *answerImageView = [self imageViewFromPopout];
    //check if popoutView's center intersects one of the answerDock views
    if (CGRectContainsPoint(self.answerDockButtonBottom.frame, self.popoutView.center)) {
        //check if the answer is correct
        BOOL correct = answerIsCorrectFor(self.answerDockButtonBottom);
        if (correct) {
            [self addView:answerImageView toAnswerDock:self.answerDockButtonBottom];
            [self.popoutView removeFromSuperview];
            self.popoutViewOriginFrame = CGRectZero;
        } else {
//            UIView *correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockButtonBottom];
//            [self addView:correctAnswerImageView toAnswerDock:self.answerDockButtonBottom];
            [self returnAnswerToOrigin];
        }
    } else if (CGRectContainsPoint(self.answerDockButtonTop.frame, self.popoutView.center)) {
        //correct?
        BOOL correct = answerIsCorrectFor(self.answerDockButtonTop);
        if (correct) {
            [self addView:answerImageView toAnswerDock:self.answerDockButtonTop];
            [self.popoutView removeFromSuperview];
            self.popoutViewOriginFrame = CGRectZero;
        } else {
//            UIView *correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockButtonTop];
//            [self addView:correctAnswerImageView toAnswerDock:self.answerDockButtonTop];
            [self returnAnswerToOrigin];
        }
    } else {
        [self.popoutView removeFromSuperview];
        self.popoutViewOriginFrame = CGRectZero;        
    }
    
    [self.delegate answerBoxDidMove];
}

- (void)addView:(UIView *)view toAnswerDock:(UIView *)answerDock {
    for (UIView *subview in answerDock.subviews) {
        [subview removeFromSuperview];
    }
    
    [answerDock addSubview:view];
    
    [UIView animateWithDuration:0.4 animations:^{
        view.frame = CGRectInset(answerDock.bounds, 5, 5);
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[self checkForDock:answerDock] setHidden:NO];
        if (!self.topCheck.hidden && !self.bottomCheck.hidden) {
            [self.delegate didAnswerPowerToolSection:self.section];
        }
    }];
}

- (UIView *)imageViewFromPopout {
    if (self.popoutView && self.popoutView.subviews.count > 0) {
        return [self.popoutView.subviews objectAtIndex:0];
    }
    return nil;
}

- (UIView *)imageCopyForView:(UIView *)view {
    CGSize size = [view bounds].size;
    UIGraphicsBeginImageContext(size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = buttonImage;
    UIGraphicsEndImageContext();
    
    return imageView;
}

- (void)popoutAnswerButtonView:(UIButton *)button {
    self.popoutViewOriginFrame = button.frame;
    self.popoutView = [[UIView alloc] initWithFrame:CGRectInset(button.frame, -10, -10)];
    [self.popoutView addSubview:[self imageCopyForView:button]];
    self.popoutView.alpha = 0.5;
    self.popoutView.tag = button.tag;
    
    NSLog(@"tag:%d", button.tag);
    
    [self.view addSubview:self.popoutView];
}

- (UIView *)correctAnswerViewForDock:(UIView *)dock {
    for (UIButton *button in self.popupButtons) {
        if (button.tag == dock.tag) {
            return [self imageCopyForView:button];
        }
    }
    return nil;
}

- (UIView *)checkForDock:(UIView *)dock {
    if (dock == self.answerDockButtonTop) {
        return self.topCheck;
    } else {
        return self.bottomCheck;
    }
}

- (void)returnAnswerToOrigin {
    if (CGRectIsEmpty(self.popoutViewOriginFrame)) {
        return;
    }
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05f],
                   [NSNumber numberWithFloat:0.05f],
                   nil];
    anim.duration = 0.05f;// + ((tileIndex % 10) * 0.01f);
    anim.autoreverses = NO;
    anim.repeatCount = 6;
    
    [self.popoutView.layer addAnimation:anim forKey:@"shake"];
    
    [UIView animateWithDuration:0.7 delay:0.4 options:UIViewAnimationCurveEaseInOut animations:^{
        self.popoutView.frame = self.popoutViewOriginFrame;
        self.popoutView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.popoutView.layer removeAnimationForKey:@"shake"];
        [self.popoutView removeFromSuperview];
        self.popoutViewOriginFrame = CGRectZero;
    }];
}

@end
