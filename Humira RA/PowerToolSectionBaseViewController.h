//
//  PowerToolSectionBaseViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-01.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionSlideDelegate.h"
#import <QuartzCore/QuartzCore.h>

@protocol PowerToolScrollDelegate <NSObject>
@required
- (void)answerBoxWillMove;
- (void)answerBoxDidMove;
- (void)shouldScrollToSection:(NSInteger)section;
@end

@protocol PowerToolSectionAnswerDelegate <NSObject>
@required
- (void)didAnswerPowerToolSection:(NSInteger)section;

@end

@protocol PowerToolSectionBaseViewControllerDelegate <NSObject>
@required
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id<PowerToolScrollDelegate> delegate;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) BOOL alreadyAnswered;
@end

@interface PowerToolSectionBaseViewController : UIViewController <SectionSlideDelegate>

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;

@property (weak, nonatomic) IBOutlet UIView *answerDockButtonTop;
@property (weak, nonatomic) IBOutlet UIView *answerDockButtonBottom;

@property (weak, nonatomic) IBOutlet UIView *topCheck;
@property (weak, nonatomic) IBOutlet UIView *bottomCheck;

@property (assign, nonatomic) NSInteger section;
@property (strong, nonatomic) NSArray *popupButtons;
@property (assign, nonatomic) BOOL alreadyAnswered;

@property (weak, nonatomic) id<PowerToolScrollDelegate, PowerToolSectionAnswerDelegate> delegate;

@end
