//
//  CommitmentViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollViewController.h"
#import "QuizViewController.h"

@interface CommitmentViewController : UIViewController <HorizontalScrollViewDelegate, QuizViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIViewController *bottomViewController;
@property (strong, nonatomic) UIViewController *popupViewController;

@property (strong, nonatomic) NSMutableDictionary *answered;

- (IBAction)selectSection:(UIButton *)sender;

@end
