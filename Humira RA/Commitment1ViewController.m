//
//  Commitment1ViewController.m
//  Humira RA
//
//  Created by Developer on 12-02-28.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Commitment1ViewController.h"
#import "CommitmentSlidesViewController.h"

@interface Commitment1ViewController ()

@end

@implementation Commitment1ViewController
@synthesize popupButtons;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"Commitment1ViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popupButtons = [NSArray arrayWithObjects:self.button1, self.button2, self.button3, self.button4, nil];
}

- (void)viewDidUnload
{
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)selectSection:(UIButton *)sender {
    NSInteger index = sender.tag;
    CommitmentSlidesViewController *parent = (CommitmentSlidesViewController *)self.parentViewController.parentViewController;
    [parent selectViewControllerAtIndex:index];
}

@end
