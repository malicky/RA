//
//  InteractiveSlidesBaseViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-05.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol InteractiveSlidesBaseViewControllerDelegate <NSObject>
@property (strong, nonatomic) NSDictionary *answerData;
- (void)viewController:(UIViewController *)viewController didSelectAnswersWithValues:(NSDictionary *)answerValues inSection:(NSInteger)section;
- (void)viewController:(UIViewController *)viewController mightHaveDeselectedAnAnswerInSection:(NSInteger)section;
- (NSDictionary *)aggregatedPreviousAnswersForSection:(NSInteger)section;
@end

@protocol InteractiveSlidesBaseViewControllerBehaviour <NSObject>
@required
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *pageData;
@end

@interface InteractiveSlidesBaseViewController : UIViewController <InteractiveSlidesBaseViewControllerBehaviour>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *question;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger section;
@property (weak, nonatomic) id<InteractiveSlidesBaseViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDelegate:(id)delegate;
- (IBAction)selectAnswer:(id)sender;

@end
