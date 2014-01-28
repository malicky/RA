//
//  Dream2ViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DreamSlideBaseViewController.h"

@interface Dream2ViewController : DreamSlideBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *popupButton1;

@property (strong, nonatomic) IBOutlet UIView *dimView;
@property (strong, nonatomic) IBOutlet UIImageView *popupView1;

- (IBAction)showPopup1:(id)sender;

@end
