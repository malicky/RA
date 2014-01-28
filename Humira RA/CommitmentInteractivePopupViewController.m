//
//  CommitmentInteractivePopupViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-13.
//  Copyright (c) 2012 . All rights reserved.
//

#import "CommitmentInteractivePopupViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommitmentInteractivePopupViewController ()

@property (strong, nonatomic) NSArray *optionButtons;
@property (strong, nonatomic) UIView *popoutView;

- (void)popoutAnswerButtonView:(UIButton *)button;
- (UIView *)imageCopyForView:(UIView *)view;
- (UIView *)imageViewFromPopout;

@end

@implementation CommitmentInteractivePopupViewController
@synthesize answerDock = _answerDock;
@synthesize questionLabel;
@synthesize option1;
@synthesize option2;
@synthesize option3;
@synthesize question, answers, questionIndex;
@synthesize delegate;
@synthesize optionButtons;
@synthesize alreadyAnswered, alreadyAnsweredCorrectly;
@synthesize popoutView;

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
    // Do any additional setup after loading the view from its nib.
    self.optionButtons = [NSArray arrayWithObjects:self.option1, self.option2, self.option3, nil];
    self.questionLabel.text = self.question;
    NSAssert(self.answers.count > 3, @"too few answers");
    [self.answers enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
        if (idx < 3) {
            UIButton *button = [self.optionButtons objectAtIndex:idx];
            [button setTitle:value forState:UIControlStateDisabled];
        }
    }];
    self.answerDock.tag = [[self.answers lastObject] integerValue];
}

- (void)viewDidUnload
{
    [self setAnswerDock:nil];
    [self setQuestionLabel:nil];
    [self setOption1:nil];
    [self setOption2:nil];
    [self setOption3:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)close:(id)sender {
    [self.delegate shouldClosePopupViewController:self];
}

#pragma mark - dragging

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    NSLog(@"began: %@", NSStringFromCGPoint(location));
    BOOL answerButtonTouched = NO;
    UIButton *tappedButton = nil;
    for (UIButton *answerButton in self.optionButtons) {
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
    UIView *answerImageView = [self imageViewFromPopout];
    //check if popoutView's center intersects one of the answerDock views
    if (CGRectContainsPoint(self.answerDock.frame, self.popoutView.center)) {
        [self addView:answerImageView toAnswerDock:self.answerDock];
    }
    [self.popoutView removeFromSuperview];
}

- (void)popoutAnswerButtonView:(UIButton *)button {
    CGFloat aspect = button.bounds.size.width / button.bounds.size.height;
    CGFloat scaleFactor = 5.0f;
    CGRect newFrame = CGRectInset(button.frame, -scaleFactor * aspect, -scaleFactor);
    self.popoutView = [[UIView alloc] initWithFrame:newFrame];
    self.popoutView.backgroundColor = [UIColor yellowColor];
    self.popoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView *bg = [self imageCopyForView:button];
    bg.frame = popoutView.bounds;
    [self.popoutView addSubview:bg];
    self.popoutView.alpha = 0.5;
    self.popoutView.tag = button.tag;
    
    self.popoutView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.popoutView.layer.shadowOffset = CGSizeMake(0, 4);
    self.popoutView.layer.shadowOpacity = 0.75f;
    self.popoutView.layer.shadowRadius = 4.0f;
    
    NSLog(@"tag:%d", button.tag);
    
    [self.view addSubview:self.popoutView];
}

- (UIView *)imageCopyForView:(UIView *)view {
    CGSize size = [view bounds].size;
    UIGraphicsBeginImageContext(size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = buttonImage;
    UIGraphicsEndImageContext();
    
    return imageView;
}

- (UIView *)imageViewFromPopout {
    if (self.popoutView && self.popoutView.subviews.count > 0) {
        return [self.popoutView.subviews objectAtIndex:0];
    }
    return nil;
}

- (void)addView:(UIView *)view toAnswerDock:(UIView *)answerDock {
    for (UIView *subview in answerDock.subviews) {
        [subview removeFromSuperview];
    }
    
    [answerDock addSubview:view];
    CGFloat aspect = answerDock.bounds.size.width / answerDock.bounds.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        view.frame = CGRectInset(answerDock.bounds, 5.0f, 5.0f / aspect);
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        BOOL correct = self.popoutView.tag == answerDock.tag;
        [self.delegate didAnswerQuestionAtIndex:self.questionIndex withCorrectAnswer:correct];
        [self.delegate shouldClosePopupViewController:self];
    }];
}

- (UIView *)correctAnswerViewForDock:(UIView *)dock {
    for (UIButton *button in self.optionButtons) {
        if (button.tag == dock.tag) {
            return [self imageCopyForView:button];
        }
    }
    return nil;
}

@end
