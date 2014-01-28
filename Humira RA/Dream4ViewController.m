//
//  Dream4ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Dream4ViewController.h"

@interface Dream4ViewController ()
@property (strong, nonatomic) UIView *popoutView;

- (void)addView:(UIView *)view toAnswerDock:(UIView *)answerDock;
- (UIView *)imageViewFromPopout;
- (UIView *)imageCopyForView:(UIView *)view;
- (UIView *)correctAnswerViewForDock:(UIView *)dock;
- (UIView *)checkForDock:(UIView *)dock;
@end

@implementation Dream4ViewController
@synthesize answerButton1;
@synthesize answerButton2;
@synthesize answerButton3;
@synthesize answerButton4;
@synthesize answerButton5;
@synthesize answerDockLeft;
@synthesize checkLeft;
@synthesize answerDockRight;
@synthesize checkRight;
@synthesize popoutView = _popoutView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.section = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popupButtons = [NSArray arrayWithObjects:self.answerButton1, self.answerButton2, self.answerButton3, self.answerButton4, self.answerButton5,nil];
}

- (void)viewDidUnload
{
    [self setAnswerButton1:nil];
    [self setAnswerButton2:nil];
    [self setAnswerButton3:nil];
    [self setAnswerButton4:nil];
    [self setAnswerButton5:nil];
    [self setAnswerDockLeft:nil];
    [self setCheckLeft:nil];
    [self setAnswerDockRight:nil];
    [self setCheckRight:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
    if (CGRectContainsPoint(self.answerDockLeft.frame, self.popoutView.center)) {
        //check if the answer is correct
        BOOL correct = answerIsCorrectFor(self.answerDockLeft);
        if (correct) {
            [self addView:answerImageView toAnswerDock:self.answerDockLeft];
        } else {
            UIView *correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockLeft];
            [self addView:correctAnswerImageView toAnswerDock:self.answerDockLeft];            
        }
    } else if (CGRectContainsPoint(self.answerDockRight.frame, self.popoutView.center)) {
        //correct?
        BOOL correct = answerIsCorrectFor(self.answerDockRight);
        if (correct) {
            [self addView:answerImageView toAnswerDock:self.answerDockRight];
        } else {
            UIView *correctAnswerImageView = [self correctAnswerViewForDock:self.answerDockRight];
            [self addView:correctAnswerImageView toAnswerDock:self.answerDockRight];
        }
    }
    [self.popoutView removeFromSuperview];
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
    if (dock == self.answerDockLeft) {
        return self.checkLeft;
    } else {
        return self.checkRight;
    }
}

@end
