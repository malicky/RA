//
//  QuizPageControl.m
//  Humira RA
//
//  Created by Developer on 12-02-24.
//  Copyright (c) 2012 . All rights reserved.
//

#define PADDING         20.0f
#define ANSWER_HEIGHT   44.0f
#define CLOSE_WIDTH     86.0f
#define CLOSE_HEIGHT    87.0f

#import "QuizPageControl.h"
#import "QuizViewController.h"

@implementation QuizPageControl
@synthesize index = _index;
@synthesize imageData = _imageData;
@synthesize delegate = _delegate;
@synthesize answer = _answer;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize qImageButton = _qImageButton;
@synthesize questionLabel = _questionLabel;
@synthesize closeButton = _closeButton;
@synthesize answerButtons = _answerButtons;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        _answer = -1;
        self.answerButtons = [NSMutableArray arrayWithCapacity:5];
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundImageView];
        
        self.qImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.qImageButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        self.qImageButton.userInteractionEnabled = NO;
        self.qImageButton.titleLabel.textAlignment = UITextAlignmentCenter;
        self.qImageButton.titleEdgeInsets = UIEdgeInsetsMake(3, 5, 0, 0);
        [self.qImageButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.7] forState:UIControlStateNormal];
        self.qImageButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        self.qImageButton.titleLabel.shadowOffset = CGSizeMake(-1, -1);
        self.qImageButton.titleLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.7];
        self.qImageButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
        [self addSubview:self.qImageButton];
        
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.questionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.questionLabel.numberOfLines = 5;
        self.questionLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        self.questionLabel.textColor = [UIColor darkGrayColor];
        self.questionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.questionLabel];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    self.backgroundImageView.frame = frame;
    
    CGRect iconFrame = CGRectMake(PADDING, PADDING + 35.0f, 80, 80);
    self.qImageButton.frame = iconFrame;
    
    CGRect questionLabelFrame = CGRectInset(frame, PADDING, PADDING);
    CGFloat newX = self.qImageButton.frame.origin.x + self.qImageButton.frame.size.width + 8.0f;
    questionLabelFrame.origin.x = newX;
    questionLabelFrame.size.width -= (newX - PADDING);
    questionLabelFrame.size.height = 150.0f;
    self.questionLabel.frame = questionLabelFrame;
    
    self.closeButton.frame = CGRectMake(frame.size.width - CLOSE_WIDTH - 14.0f, frame.size.height - CLOSE_HEIGHT - 12.0f, CLOSE_WIDTH, CLOSE_HEIGHT);
}

- (void)setImageData:(NSDictionary *)imageData {
    if (_imageData != imageData) {
        _imageData = imageData;
    }
    //remove old buttons
    for (UIButton *button in self.answerButtons) {
        [button removeFromSuperview];
    }
    [self.answerButtons removeAllObjects];
    _answer = -1;
        
    //populate title and qimage
    NSString *obj = [imageData valueForKey:@"icon"];
    NSString *title = [imageData valueForKey:@"icon_title"];
    UIImage *iconImage = [UIImage imageNamed:obj];
    [self.qImageButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    [self.qImageButton setTitle:title forState:UIControlStateNormal];
    
    obj = [imageData valueForKey:@"question"];
    self.questionLabel.text = obj;
    
    //background image
    obj = [imageData valueForKey:@"background"];
    self.backgroundImageView.image = [UIImage imageNamed:obj];
    
    //generate answer buttons
    NSArray *answers = [imageData objectForKey:@"answers"];
    [self addAnswerButtonsFrom:answers];
}

- (void)addAnswerButtonsFrom:(NSArray *)answers {
    [answers enumerateObjectsUsingBlock:^(NSString *answer, NSUInteger idx, BOOL *stop) {
        CGRect frame = [self frameForAnswerButtonAtIndex:idx];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.tag = idx;
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        button.titleLabel.numberOfLines = 3;
        button.adjustsImageWhenHighlighted = YES;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
//        button.titleLabel.shadowColor = [UIColor lightGrayColor];
//        button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [button setImage:[self imageForAnswerButtonAtIndex:idx] forState:UIControlStateNormal];
        [button setTitle:answer forState:UIControlStateNormal];
        [button addTarget:self action:@selector(answerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self.answerButtons addObject:button];
    }];
}

- (CGRect)frameForAnswerButtonAtIndex:(NSInteger)index {
    CGRect frame = CGRectInset(self.bounds, PADDING * 2, PADDING);
    frame.size.height = ANSWER_HEIGHT;
    CGFloat origin = 220.0f;

    frame.origin.y = origin + (index * ANSWER_HEIGHT) + (12.0f * index);
    
    return frame;
}

- (UIImage *)imageForAnswerButtonAtIndex:(NSInteger)index {
    NSString *name = [NSString stringWithFormat:@"question%d.png", index];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

- (void)setAnswer:(NSInteger)answer {
    _answer = answer;
    
    [self.answerButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (idx != answer) {
            button.hidden = YES;
        }
    }];
    
    if (_answer >= 0) {
        NSString *answeredImageName = [self.imageData valueForKey:@"correct_image"];
        UIImage *answeredImage = [UIImage imageNamed:answeredImageName];
        self.backgroundImageView.image = answeredImage;
    }
}

- (void)answerSelected:(id)sender {
    NSLog(@"selected:%d", [sender tag]);
    NSInteger selectedAnswer = [sender tag];
    NSInteger correctAnswer = [[self.imageData valueForKey:@"correct"] integerValue];
    if (selectedAnswer == correctAnswer) {
        self.answer = correctAnswer;
        [self.delegate didSelectPageControl:self withUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:correctAnswer], @"selected", @"selected", @"action", nil]];
    }
}

- (void)closeView:(id)sender {
    NSLog(@"close! (to delegate)");
    [self.delegate didSelectPageControl:self withUserInfo:[NSDictionary dictionaryWithObject:@"close" forKey:@"action"]];
}

@end
