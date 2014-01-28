//
//  MainSegue.m
//  Humira RA
//
//  Created by Developer on 12-02-21.
//  Copyright (c) 2012 . All rights reserved.
//

#import "MainSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "SectionSegueDelegate.h"

@implementation MainSegue

- (void)perform {
    UIViewController *source = self.sourceViewController;
//    UIViewController<SectionSegueDelegate> *destination = self.destinationViewController;
    
//    NSString *destinationName = [source.class description];
//    UIImage *previewImage = [UIImage imageNamed:[destinationName stringByAppendingString:@"_preview"]];
//    NSAssert(previewImage, @"previewImage is nil");
////    
////    //add preview image (view) to source vc's view
//    __block UIImageView *previewImageView = [[UIImageView alloc] initWithImage:previewImage];
//    previewImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    previewImageView.frame = destination.view.bounds;
//    previewImageView.center = destination.view.center;
//    previewImageView.alpha = 1.0;
//    [destination.view addSubview:previewImageView];
//    
//    //call open and fade wheel!
//    [source willTransitionFromMainViewController];
//    
//    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
//        previewImageView.bounds = source.view.bounds;
//        previewImageView.center = source.view.center;
//        previewImageView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.5f;
//        transition.type = kCATransitionFade;
//        [source.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//        [source.navigationController pushViewController:destination animated:NO];
//        [previewImageView removeFromSuperview];
//    }];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionFade;
    [source.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *mainViewController = [source.navigationController.viewControllers objectAtIndex:1];
    NSAssert(mainViewController, @"Main VC is NOT at index 1 in VC stack!");
    
    [source.navigationController popToViewController:mainViewController animated:NO];
}

@end
