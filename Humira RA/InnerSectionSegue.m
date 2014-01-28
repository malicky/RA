//
//  InnerSectionSegue.m
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import "InnerSectionSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation InnerSectionSegue

- (void)perform {
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionFade;
    [source.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    if ([source.navigationController.viewControllers containsObject:destination]) {
        [source.navigationController popToViewController:destination animated:NO];
    } else {
        [source.navigationController pushViewController:destination animated:NO];
    }
}

@end
