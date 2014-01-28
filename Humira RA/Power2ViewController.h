//
//  Power2ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerSlideBaseViewController.h"

@interface Power2ViewController : PowerSlideBaseViewController

@property (strong, nonatomic) IBOutlet UIView *dimView;
@property (strong, nonatomic) IBOutlet UIImageView *popupView1;
@property (strong, nonatomic) IBOutlet UIImageView *popupView2;
@property (weak, nonatomic) IBOutlet UIButton *popupButton1;
@property (weak, nonatomic) IBOutlet UIButton *popupButton2;
@property (weak, nonatomic) IBOutlet UIButton *footnoteButton;
@property (strong, nonatomic) IBOutlet UIImageView *footnoteView;

- (IBAction)showPopup1:(id)sender;
- (IBAction)showPopup2:(id)sender;
- (IBAction)showFootnote:(id)sender;

@end
