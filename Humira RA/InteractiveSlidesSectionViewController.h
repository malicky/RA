//
//  InteractiveSlidesSectionViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-05.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveSlidesBaseViewController.h"

@interface InteractiveSlidesSectionViewController : UIViewController <UIScrollViewDelegate, InteractiveSlidesBaseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (strong, nonatomic) NSMutableDictionary *answerData;
@end
