//
//  Dream4ViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DreamSlideBaseViewController.h"

@interface Dream4ViewController : DreamSlideBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;
@property (weak, nonatomic) IBOutlet UIButton *answerButton5;

@property (weak, nonatomic) IBOutlet UIView *answerDockLeft;
@property (weak, nonatomic) IBOutlet UIImageView *checkLeft;

@property (weak, nonatomic) IBOutlet UIView *answerDockRight;
@property (weak, nonatomic) IBOutlet UIImageView *checkRight;

@end
