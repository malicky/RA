//
//  QuizPageControl.h
//  Humira RA
//
//  Created by Developer on 12-02-24.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControlDelegate.h"

@interface QuizPageControl : UIView<PageControlBehaviour>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *imageData;
@property (weak, nonatomic) id<PageControlDelegate> delegate;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *qImageButton;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *closeButton;

@property (assign, nonatomic) NSInteger answer;
@property (strong, nonatomic) NSMutableArray *answerButtons;

- (id)initWithDelegate:(id)delegate;
- (void)addAnswerButtonsFrom:(NSArray *)answers;
- (CGRect)frameForAnswerButtonAtIndex:(NSInteger)index;
- (UIImage *)imageForAnswerButtonAtIndex:(NSInteger)index;

@end
