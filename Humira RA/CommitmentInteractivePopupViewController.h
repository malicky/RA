//
//  CommitmentInteractivePopupViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-13.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommitmentPopupDelegate <NSObject>

@required
- (void)didAnswerQuestionAtIndex:(NSInteger)qIndex withCorrectAnswer:(BOOL)correct;
- (void)shouldClosePopupViewController:(UIViewController *)viewController;

@end

@interface CommitmentInteractivePopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *answerDock;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSArray *answers;
@property (assign, nonatomic) NSInteger questionIndex;

@property (weak, nonatomic) IBOutlet UIButton *option1;
@property (weak, nonatomic) IBOutlet UIButton *option2;
@property (weak, nonatomic) IBOutlet UIButton *option3;

@property (weak, nonatomic) id<CommitmentPopupDelegate> delegate;
@property (assign, nonatomic) BOOL alreadyAnswered;
@property (assign, nonatomic) BOOL alreadyAnsweredCorrectly;

- (IBAction)close:(id)sender;

@end
