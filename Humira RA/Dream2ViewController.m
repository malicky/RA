//
//  Dream2ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Dream2ViewController.h"

@interface Dream2ViewController ()

@end

@implementation Dream2ViewController
@synthesize popupButton1;
@synthesize dimView;
@synthesize popupView1;

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
    self.popupButtons = [NSArray arrayWithObjects:self.popupButton1, nil];
    
    UIGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup1:)];
    [self.popupView1 addGestureRecognizer:tapGestureRecognizer1];
}

- (void)viewDidUnload
{
    [self setPopupButton1:nil];
    [self setDimView:nil];
    [self setPopupView1:nil];
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

- (void)closePopup1:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView transitionWithView:self.view duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.popupView1 removeFromSuperview];
            [self.dimView removeFromSuperview];
        } completion:nil];
    }
}

@end
