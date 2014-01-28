//
//  Commitment0ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Commitment0ViewController.h"

@interface Commitment0ViewController ()
@property (strong, nonatomic) NSArray *questionButtons;
@property (assign, nonatomic) BOOL isPresentingPopup;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;

- (void)addSwipeGestureRecognizer;
- (void)removeSwipeGestureRecognizer;
- (NSArray *)answersForQuestionAtIndex:(NSInteger)index;
- (void)reset;
@end

@implementation Commitment0ViewController
@synthesize question1;
@synthesize question2;
@synthesize question3;
@synthesize question4;
@synthesize question5;
@synthesize question6;
@synthesize dimView;
@synthesize questionButtons;
@synthesize isPresentingPopup;
@synthesize swipeGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isPresentingPopup = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.questionButtons = [NSArray arrayWithObjects:self.question1, self.question2, self.question3, self.question4, self.question5, self.question6, nil];
    [self addSwipeGestureRecognizer];
}

- (void)viewDidUnload
{
    [self setQuestion1:nil];
    [self setQuestion2:nil];
    [self setQuestion3:nil];
    [self setQuestion4:nil];
    [self setQuestion5:nil];
    [self setQuestion6:nil];
    [self setDimView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(IBAction)solve:(id)sender {
    [self.questionButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self didAnswerQuestionAtIndex:idx withCorrectAnswer:YES];
    }];
}

- (IBAction)pickQuestion:(id)sender {
    NSInteger questionIndex = [sender tag];
    
    self.dimView.frame = self.view.bounds;
    [self.view addSubview:self.dimView];
    
    CommitmentInteractivePopupViewController *pvc = [[CommitmentInteractivePopupViewController alloc] initWithNibName:nil bundle:nil];
    pvc.delegate = self;
    pvc.question = [[(UIButton *)sender titleLabel] text];
    pvc.answers = [self answersForQuestionAtIndex:questionIndex];
    pvc.questionIndex = [self.questionButtons indexOfObject:sender];
    
    pvc.view.center = self.view.center;
    [self addChildViewController:pvc];
    self.isPresentingPopup = YES;
    
    //animate view transition:
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self.view addSubview:pvc.view];
    } completion:^(BOOL finished) {
        [pvc didMoveToParentViewController:self];
        [self removeSwipeGestureRecognizer];
    }];
}

- (NSArray *)answersForQuestionAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [NSArray arrayWithObjects:@"500,000", @"950,000", @"> 1.6 million", [NSNumber numberWithInt:2], nil];
        case 1:
            return [NSArray arrayWithObjects:@"100,000", @"300,000", @"> 500,000", [NSNumber numberWithInt:2], nil];
        case 2:
            return [NSArray arrayWithObjects:@"7 years", @"14 years", @"20 years", [NSNumber numberWithInt:1], nil];
        case 3:
            return [NSArray arrayWithObjects:@"10,000", @"15,000", @"19,000", [NSNumber numberWithInt:2], nil];
        case 4:
            return [NSArray arrayWithObjects:@"5 years", @"7 years", @"9 years", [NSNumber numberWithInt:1], nil];
        case 5:
            return [NSArray arrayWithObjects:@"5", @"6", @"7", [NSNumber numberWithInt:0], nil];
        default:
            break;
    }
    return nil;
}

- (void)didAnswerQuestionAtIndex:(NSInteger)qIndex withCorrectAnswer:(BOOL)correct {
    UIButton *answeredQuestion = [self.questionButtons objectAtIndex:qIndex];
    NSString *beforeAnswer = answeredQuestion.titleLabel.text;
    
    UIImage *image = [UIImage imageNamed:correct ? @"commitment_check" : @"commitment_cross"];
    [answeredQuestion setImage:image forState:UIControlStateDisabled];
    answeredQuestion.enabled = NO;
    
    NSArray *possibleAnswers = [self answersForQuestionAtIndex:qIndex];
    NSInteger correctIndex = [[possibleAnswers lastObject] integerValue];
    NSString *correctAnswer = [possibleAnswers objectAtIndex:correctIndex];
    if (![answeredQuestion.titleLabel.text hasPrefix:correctAnswer]) {
        [answeredQuestion setTitle:[NSString stringWithFormat:@"%@ %@", correctAnswer, beforeAnswer] forState:UIControlStateDisabled];
    }
}

- (void)shouldClosePopupViewController:(UIViewController *)viewController {
    //animate view transition:
    [self.dimView removeFromSuperview];
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [viewController.view removeFromSuperview];
    } completion:^(BOOL finished) {
        [viewController removeFromParentViewController];
        [self addSwipeGestureRecognizer];
    }];    
}

- (void)addSwipeGestureRecognizer {
    [self removeSwipeGestureRecognizer];
    UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gr.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gr];
}

- (void)removeSwipeGestureRecognizer {
    for (id gr in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gr];
    }    
}

- (void)handleGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Start over?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [self reset];
    }
}

- (void)reset {
    NSLog(@"reset");
    for (UIButton *button in self.questionButtons) {
        button.enabled = YES;
    }
}

@end
