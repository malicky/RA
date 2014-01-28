//
//  PDFViewController.m
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import "PDFViewController.h"
#import "ReaderDocument.h"

@interface PDFViewController ()

@property (strong, nonatomic) ReaderViewController *readerVC;
@property (strong, nonatomic) ReaderDocument *readerDoc;

@end

@implementation PDFViewController
@synthesize pdfFileName;
@synthesize readerVC;
@synthesize readerDoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //show reader view controller here!
    NSLog(@"%@", pdfFileName);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfFileName ofType:@"pdf"];
    NSAssert(filePath, @"PDF %@ at path %@ not found in main bundle", pdfFileName, filePath);
    self.readerDoc = [[ReaderDocument alloc] initWithFilePath:filePath password:nil];
    self.readerVC = [[ReaderViewController alloc] initWithReaderDocument:self.readerDoc];
    self.readerVC.delegate = self;
    
    self.readerVC.view.frame = self.view.bounds;
    
    [self addChildViewController:self.readerVC];
    [self.view addSubview:self.readerVC.view];
    [self.readerVC didMoveToParentViewController:self];
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

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self.readerVC.view removeFromSuperview];
    [self.readerVC removeFromParentViewController];
    
    self.readerDoc = nil;
    self.readerVC = nil;
    
    [self dismissModalViewControllerAnimated:NO];
}

@end
