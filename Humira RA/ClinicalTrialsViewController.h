//
//  ClinicalTrialsViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TrialsBaseViewController.h"

@interface ClinicalTrialsViewController : UIViewController <UIScrollViewDelegate, TrialsBaseViewControllerDelegate>

@property (strong, nonatomic) UIScrollView *pagingScrollView;
@property (strong, nonatomic) UIView *dimView;

- (IBAction)close:(id)sender;
- (IBAction)selectIndex:(id)sender;

@end
