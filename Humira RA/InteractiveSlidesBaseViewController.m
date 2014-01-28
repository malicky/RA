//
//  InteractiveSlidesBaseViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-05.
//  Copyright (c) 2012 . All rights reserved.
//

#import "InteractiveSlidesBaseViewController.h"

@interface InteractiveSlidesBaseViewController ()
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *views;
@property (assign, nonatomic) NSInteger answered;
@property (assign, nonatomic) NSInteger toAnswer;
@property (strong, nonatomic) NSDictionary *aggregatedPreviousAnswers;

- (void)configurePage;
- (UIView *)viewForButton:(UIButton *)button;
- (void)centerMinAndMaxForView:(UIView *)view block:(void(^)(CGPoint centerNotSelected, CGPoint centerSelected))block;
- (NSString *)keyForIndex:(NSInteger)index;
- (NSInteger)answeredQuestions;
- (void)configureView:(UIView *)view selected:(BOOL)selected animated:(BOOL)animated;

@end

@implementation InteractiveSlidesBaseViewController

@synthesize backgroundImageView;
@synthesize titleLabel;
@synthesize subtitleLabel;
@synthesize question;
@synthesize maskImageView;

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize view4;
@synthesize view5;

@synthesize textView;
@synthesize buttons, views;
@synthesize aggregatedPreviousAnswers;
@synthesize index = _index, pageData = _pageData, toAnswer, answered, section = _section;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDelegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.index = 0;
        self.section = 0;
        self.delegate = delegate;
        self.answered = 0;
        self.toAnswer = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.maskImageView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
//    self.maskImageView.layer.shadowOffset = CGSizeMake(2, 2);
//    self.maskImageView.layer.shadowOpacity = 0.75f;
//    self.maskImageView.layer.shadowRadius = 15.0f;
    
    self.buttons = [NSArray arrayWithObjects:self.button1, self.button2, self.button3, self.button4, self.button5, nil];
    self.views = [NSArray arrayWithObjects:self.view1, self.view2, self.view3, self.view4, self.view5, nil];
}

- (void)viewDidUnload
{
    self.backgroundImageView = nil;
    self.maskImageView = nil;
    self.titleLabel = nil;
    self.subtitleLabel = nil;
    self.question = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.view4 = nil;
    self.view5 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pageData) {
        [self configurePage];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)configurePage {
    NSString *bgImageName = [self.pageData valueForKey:@"background"];
    self.backgroundImageView.image = [UIImage imageNamed:bgImageName];
    
    BOOL textOnly = [[self.pageData valueForKey:@"textonly"] boolValue];
    NSString *text = [self.pageData valueForKey:@"text"];
    self.textView.text = text;
    self.textView.hidden = !textOnly;
    
    NSString *iconBg = [self.pageData valueForKey:@"q_icon_background"];
    [self.question setBackgroundImage:[UIImage imageNamed:iconBg] forState:UIControlStateDisabled];
    
    NSString *iconText = [self.pageData valueForKey:@"q_icon_text"];
    [self.question setTitle:iconText forState:UIControlStateDisabled];
    
    NSString *questionText = [self.pageData valueForKey:@"question"];
    self.titleLabel.text = questionText;
    
    NSString *subtitleText = [self.pageData valueForKey:@"subtitle"];
    self.subtitleLabel.text = subtitleText;
    
    self.toAnswer = 0;
    BOOL alreadyAnswered = [[self.delegate answerData] objectForKey:[NSNumber numberWithInteger:self.index]] != nil;
    NSDictionary *values = [self.pageData objectForKey:@"values"];
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = NO;
        button.tag = [[NSNumber numberWithBool:alreadyAnswered] integerValue];
        NSString *key = [self keyForIndex:idx];
        if ([[values valueForKey:key] doubleValue] > 0) {
            button.tag = 1;
            button.selected = alreadyAnswered;
            self.toAnswer++;
        }
    }];
        
    self.aggregatedPreviousAnswers = [self.delegate aggregatedPreviousAnswersForSection:self.index];
    NSLog(@"aggregated:%@", self.aggregatedPreviousAnswers);
    
    //is n bissl scheisse aber gut - das ist ne iteration ueber 5 tupel...
    for (UIView *view in self.views) {
        [self configureView:view selected:alreadyAnswered animated:NO];
    }
}

- (IBAction)selectAnswer:(id)sender {
    NSInteger tag = [sender tag];
    UIButton *button = (UIButton *)sender;
    if (tag != 0) {
        button.selected = !button.selected;
        if ([self answeredQuestions] == self.toAnswer) {
            [self.delegate viewController:self didSelectAnswersWithValues:[self.pageData objectForKey:@"values"] inSection:self.index];
            NSLog(@"did answer:%@", [self.delegate answerData]);
        } else {
            [self.delegate viewController:self mightHaveDeselectedAnAnswerInSection:self.index];
        }
        UIView *view = [self viewForButton:button];
        [self configureView:view selected:button.selected animated:YES];
    }
}

- (UIView *)viewForButton:(UIButton *)button {
    NSInteger buttonIndex = [self.buttons indexOfObject:button];
    return [self.views objectAtIndex:buttonIndex];
}

- (void)configureView:(UIView *)view selected:(BOOL)selected animated:(BOOL)animated {
    [self centerMinAndMaxForView:view block:^(CGPoint centerNotSelected, CGPoint centerSelected) {
        CGPoint center = selected ? centerSelected : centerNotSelected;
        [UIView animateWithDuration:animated ? 1.0 : 0.0 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            view.center = center;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (NSString *)keyForIndex:(NSInteger)index {
    NSArray *data = [NSArray arrayWithObjects:@"humira", @"simponi", @"remicade", @"enbrel", @"cimza", nil];
    return [data objectAtIndex:index];
}

- (void)centerMinAndMaxForView:(UIView *)view block:(void(^)(CGPoint ns, CGPoint s))block {
    NSDictionary *values = [self.pageData objectForKey:@"values"];

    CGFloat humiraBase = 565.0f;
    CGFloat simponiBase = 514.0f;
    CGFloat remicadeBase = 485.0f;
    CGFloat enbrelBase = 458.0f;
    CGFloat cimzaBase = 433.0f;
    
    CGFloat humiraPrevious = [[self.aggregatedPreviousAnswers valueForKey:@"humira"] doubleValue];
    CGFloat simponiPrevious = [[self.aggregatedPreviousAnswers valueForKey:@"simponi"] doubleValue];
    CGFloat remicadePrevious = [[self.aggregatedPreviousAnswers valueForKey:@"remicade"] doubleValue];
    CGFloat enbrelPrevious = [[self.aggregatedPreviousAnswers valueForKey:@"enbrel"] doubleValue];
    CGFloat cimzaPrevious = [[self.aggregatedPreviousAnswers valueForKey:@"cimza"] doubleValue];
    humiraBase-=humiraPrevious;
    simponiBase-=simponiPrevious;
    remicadeBase-=remicadePrevious;
    enbrelBase-=enbrelPrevious;
    cimzaBase-=cimzaPrevious;
    
    CGFloat humiraAdd = [[values valueForKey:@"humira"] doubleValue];
    CGFloat simponiAdd = [[values valueForKey:@"simponi"] doubleValue];
    CGFloat remicadeAdd = [[values valueForKey:@"remicade"] doubleValue];
    CGFloat enbrelAdd = [[values valueForKey:@"enbrel"] doubleValue];
    CGFloat cimzaAdd = [[values valueForKey:@"cimza"] doubleValue];
    
    CGPoint humiraNS = CGPointMake(928.0f, humiraBase);
    CGPoint humiraS = CGPointMake(928.0f, humiraBase - humiraAdd);
    CGPoint simponiNS = CGPointMake(834.0f, simponiBase);
    CGPoint simponiS = CGPointMake(834.0f, simponiBase - simponiAdd);
    CGPoint remicadeNS = CGPointMake(743.0f, remicadeBase);
    CGPoint remicadeS = CGPointMake(743.0f, remicadeBase - remicadeAdd);
    CGPoint enbrelNS = CGPointMake(659.0f, enbrelBase);
    CGPoint enbrelS = CGPointMake(659.0f, enbrelBase - enbrelAdd);
    CGPoint cimzaNS = CGPointMake(578.0f, cimzaBase);
    CGPoint cimzaS = CGPointMake(578.0f, cimzaBase - cimzaAdd);
    NSInteger idx = [self.views indexOfObject:view];
    switch (idx) {
        case 0:
            block(humiraNS, humiraS);
            break;
        case 1:
            block(simponiNS, simponiS);
            break;
        case 2:
            block(remicadeNS, remicadeS);
            break;
        case 3:
            block(enbrelNS, enbrelS);
            break;
        case 4:
            block(cimzaNS, cimzaS);
            break;
        default:
            break;
    }
}

- (NSInteger)answeredQuestions {
    NSInteger count = 0;
    for (UIButton *button in self.buttons) {
        count += [[NSNumber numberWithBool:button.selected] integerValue];
    }
    return count;
}

@end
