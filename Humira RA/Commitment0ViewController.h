//
//  Commitment0ViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommitmentInteractivePopupViewController.h"

@interface Commitment0ViewController : UIViewController <CommitmentPopupDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *question1;
@property (weak, nonatomic) IBOutlet UIButton *question2;
@property (weak, nonatomic) IBOutlet UIButton *question3;
@property (weak, nonatomic) IBOutlet UIButton *question4;
@property (weak, nonatomic) IBOutlet UIButton *question5;
@property (weak, nonatomic) IBOutlet UIButton *question6;

@property (strong, nonatomic) IBOutlet UIView *dimView;

- (IBAction)pickQuestion:(id)sender;
- (IBAction)solve:(id)sender;

@end
