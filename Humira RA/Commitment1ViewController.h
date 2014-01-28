//
//  Commitment1ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-28.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Commitment1ViewController : UIViewController

@property (strong, nonatomic) NSArray *popupButtons;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

- (IBAction)selectSection:(UIButton *)sender;

@end
