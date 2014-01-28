//
//  PDFViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface PDFViewController : UIViewController <ReaderViewControllerDelegate>

@property (strong, nonatomic) NSString *pdfFileName;
@end
