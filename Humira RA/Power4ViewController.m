//
//  Power4ViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Power4ViewController.h"

@interface Power4ViewController ()

@end

@implementation Power4ViewController
@synthesize footnoteView;
@synthesize footnoteButton;
@synthesize dimView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.section = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popupButtons = [NSArray arrayWithObjects:self.footnoteButton, nil];
    
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFootnote:)];
    [self.footnoteView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidUnload
{
    [self setFootnoteButton:nil];
    [self setFootnoteView:nil];
    [self setDimView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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

@end
