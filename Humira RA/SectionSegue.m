//
//  SectionSegue.m
//  Humira RA
//
//  Created by Developer on 12-02-21.
//  Copyright (c) 2012 . All rights reserved.
//

#import "SectionSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "SectionSegueDelegate.h"

@implementation SectionSegue

- (void)perform {
    UIViewController<SectionSegueDelegate> *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    
    NSString *destinationName = [destination.class description];
    UIImage *previewImage = [UIImage imageNamed:[destinationName stringByAppendingString:@"_preview"]];
    NSAssert(previewImage, @"previewImage is nil");
    
    //add preview image (view) to source vc's view
    __block UIImageView *previewImageView = [[UIImageView alloc] initWithImage:previewImage];
    previewImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    previewImageView.frame = CGRectZero;
    previewImageView.center = source.view.center;
    previewImageView.alpha = 0.0;
    [source.view insertSubview:previewImageView atIndex:0];
    
    //call open and fade wheel!
    [source willTransitionFromMainViewController:![self.identifier isEqualToString:@"Interactive"]];

    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationCurveEaseInOut animations:^{
        previewImageView.bounds = source.view.bounds;
        previewImageView.center = source.view.center;
        previewImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionFade;
        [source.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [source.navigationController pushViewController:destination animated:NO];
        [previewImageView removeFromSuperview];
    }];
}

@end
