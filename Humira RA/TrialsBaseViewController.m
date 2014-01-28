//
//  TrialsBaseViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import "TrialsBaseViewController.h"

@interface TrialsBaseViewController ()

@end

@implementation TrialsBaseViewController
@synthesize index;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)close:(id)sender {
    if (self.delegate) {
        [self.delegate closeTrialViewController];
    }
}

@end
