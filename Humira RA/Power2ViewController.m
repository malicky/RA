//
//  Power2ViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Power2ViewController.h"

@interface Power2ViewController ()

@end

@implementation Power2ViewController
@synthesize dimView;
@synthesize popupView1;
@synthesize popupView2;
@synthesize popupButton1;
@synthesize popupButton2;
@synthesize footnoteButton;
@synthesize footnoteView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.section = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popupButtons = [NSArray arrayWithObjects:self.popupButton1, self.footnoteButton, /*self.popupButton2,*/ nil];
    
    UIGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup1:)];
    [self.popupView1 addGestureRecognizer:tapGestureRecognizer1];
    
    UIGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFootnote:)];
    [self.footnoteView addGestureRecognizer:tapGestureRecognizer2];
}

- (void)viewDidUnload
{
    [self setDimView:nil];
    [self setPopupView1:nil];
    [self setPopupView2:nil];
    [self setPopupButton1:nil];
    [self setPopupButton2:nil];
    [self setFootnoteButton:nil];
    [self setFootnoteView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)showPopup1:(id)sender {
    //transition popup view    
    self.popupView1.center = self.view.center;
    self.popupView1.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.popupView1.layer.shadowOffset = CGSizeMake(0, 8);
    self.popupView1.layer.shadowOpacity = 0.66f;
    self.popupView1.layer.shadowRadius = 5.0f;
    
    self.dimView.frame = self.view.frame;
    [self.view addSubview:self.dimView];
    [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:self.popupView1];
    } completion:nil];
}

- (IBAction)showPopup2:(id)sender {
    //transition popup view    
    self.popupView2.center = self.view.center;
    self.popupView2.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.popupView2.layer.shadowOffset = CGSizeMake(0, 8);
    self.popupView2.layer.shadowOpacity = 0.66f;
    self.popupView2.layer.shadowRadius = 5.0f;
    
    self.dimView.frame = self.view.frame;
    [self.view addSubview:self.dimView];
    [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:self.popupView2];
    } completion:nil];
}

- (IBAction)showFootnote:(id)sender {
    //transition popup view    
    self.footnoteView.center = self.view.center;
    self.footnoteView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.footnoteView.layer.shadowOffset = CGSizeMake(0, 8);
    self.footnoteView.layer.shadowOpacity = 0.66f;
    self.footnoteView.layer.shadowRadius = 5.0f;
    
    self.dimView.frame = self.view.frame;
    [self.view addSubview:self.dimView];
    [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:self.footnoteView];
    } completion:nil];
}

- (void)closeFootnote:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.footnoteView removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

- (void)closePopup1:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.popupView1 removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

- (void)closePopup2:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.popupView2 removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

@end
