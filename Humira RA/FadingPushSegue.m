//
//  FadingPushSegue.m
//  crohns
//
//  Created by Developer on 12-02-16.
//  Copyright (c) 2012 . All rights reserved.
//

#import "FadingPushSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation FadingPushSegue

- (void)perform {
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;

    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionFade;
    [source.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [source.navigationController pushViewController:destination animated:NO];
}

@end
