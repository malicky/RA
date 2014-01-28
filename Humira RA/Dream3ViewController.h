//
//  Dream3ViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DreamSlideBaseViewController.h"

@interface Dream3ViewController : DreamSlideBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *popupButton;
@property (strong, nonatomic) IBOutlet UIView *dimView;
@property (strong, nonatomic) IBOutlet UIImageView *popupView;
- (IBAction)showPopup:(id)sender;
@end
