//
//  DreamSlideBaseViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DreamSlideBaseViewController.h"

@interface DreamSlideBaseViewController ()

@end

@implementation DreamSlideBaseViewController
@synthesize popupButtons = _popupButtons;
@synthesize section = _section;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

@end
