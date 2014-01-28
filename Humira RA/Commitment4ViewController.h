//
//  Commitment4ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Commitment4ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *popupButton;
@property (strong, nonatomic) IBOutlet UIImageView *popupView;
@property (strong, nonatomic) IBOutlet UIView *dimView;

- (IBAction)showPopup:(id)sender;

@end
