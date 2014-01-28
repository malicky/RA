//
//  TrialsBaseViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontallyScrollingViewControllerDelegate.h"

@protocol TrialsBaseViewControllerDelegate <NSObject>

- (void)closeTrialViewController;

@end

@interface TrialsBaseViewController : UIViewController <HorizontallyScrollingViewControllerDelegate>

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id<TrialsBaseViewControllerDelegate> delegate;

- (IBAction)close:(id)sender;

@end
