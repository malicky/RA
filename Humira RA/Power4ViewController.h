//
//  Power4ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerSlideBaseViewController.h"

@interface Power4ViewController : PowerSlideBaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *footnoteView;
@property (weak, nonatomic) IBOutlet UIButton *footnoteButton;
@property (strong, nonatomic) IBOutlet UIView *dimView;

- (IBAction)showFootnote:(id)sender;

@end
