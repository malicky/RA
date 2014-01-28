//
//  Dream1ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Dream1ViewController.h"

@interface Dream1ViewController ()

@end

@implementation Dream1ViewController
@synthesize popupButton;
@synthesize popupView;
@synthesize dimView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.section = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
    [self.popupView addGestureRecognizer:tapGestureRecognizer];
    
    self.popupButtons = [NSArray arrayWithObject:self.popupButton];
}

- (void)viewDidUnload
{
    [self setPopupButton:nil];
    [self setPopupView:nil];
    [self setDimView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)showPopup:(id)sender {
    //transition popup view    
    self.popupView.center = self.view.center;
    self.popupView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.popupView.layer.shadowOffset = CGSizeMake(0, 8);
    self.popupView.layer.shadowOpacity = 0.66f;
    self.popupView.layer.shadowRadius = 5.0f;
    
    self.dimView.frame = self.view.frame;
    [self.view addSubview:self.dimView];
    [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:self.popupView];
    } completion:nil];
}

- (void)closePopup:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.popupView removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

@end
