//
//  PowerToolSection2ViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-01.
//  Copyright (c) 2012 . All rights reserved.
//

#import "PowerToolSection2ViewController.h"

@interface PowerToolSection2ViewController ()

@end

@implementation PowerToolSection2ViewController

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
