//
//  Power1ViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Power1ViewController.h"

@interface Power1ViewController ()

@end

@implementation Power1ViewController
@synthesize dimView;
@synthesize popupView;
@synthesize popupButton;
@synthesize footnoteButton;
@synthesize footnoteView;

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
    self.popupButtons = [NSArray arrayWithObjects:self.popupButton, self.footnoteButton, nil];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
    [self.popupView addGestureRecognizer:tapGestureRecognizer];
    
    UIGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFootnote:)];
    [self.footnoteView addGestureRecognizer:tapGestureRecognizer2];
}

- (void)viewDidUnload
{
    [self setDimView:nil];
    [self setPopupView:nil];
    [self setPopupButton:nil];
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

- (void)closePopup:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.popupView removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

- (void)closeFootnote:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.footnoteView removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

@end
