//
//  QuizViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-24.
//  Copyright (c) 2012 . All rights reserved.
//

#import "HorizontalScrollViewController.h"
#import "PageControlDelegate.h"

@protocol QuizViewControllerDelegate <NSObject>
@required
- (void)quizViewController:(UIViewController *)viewController didSelectAnswer:(NSInteger)answer atIndex:(NSInteger)index;
- (void)shouldCloseQuizViewController:(UIViewController *)viewController;

@end

@interface QuizViewController : HorizontalScrollViewController

@property (strong, nonatomic) id<QuizViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDictionary *answered;
@property (assign, nonatomic) NSInteger firstPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<QuizViewControllerDelegate>)delegate;

@end
