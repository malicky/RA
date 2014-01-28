//
//  ViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-20.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatingWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "SectionSegueDelegate.h"

@interface MainViewController : UIViewController <RotatingWheelDelegate, SectionSegueDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet RotatingWheel *wheel;

@property (assign, nonatomic) BOOL transitionToMain;

- (IBAction)centerTapped:(id)sender;
- (void)openBackground;
- (void)closeBackground;
- (void)fadeWheel:(BOOL)visible withCompletion:(void(^)(BOOL finished))completion;
- (void)retrieveWheel;
- (void)animateWheelSection;
- (UIImage *)imageForCurrentSection;
- (NSString *)segueForCurrentSection;
- (UIImage *)previewImageForCurrentSection;

@end
