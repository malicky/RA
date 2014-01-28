//
//  Power1ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerSlideBaseViewController.h"

@interface Power1ViewController : PowerSlideBaseViewController

@property (strong, nonatomic) IBOutlet UIView *dimView;
@property (strong, nonatomic) IBOutlet UIImageView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *popupButton;
@property (weak, nonatomic) IBOutlet UIButton *footnoteButton;
@property (strong, nonatomic) IBOutlet UIImageView *footnoteView;

- (IBAction)showPopup:(id)sender;
- (IBAction)showFootnote:(id)sender;

@end
