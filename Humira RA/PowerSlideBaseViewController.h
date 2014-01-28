//
//  PowerSlideBaseViewController.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionSlideDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface PowerSlideBaseViewController : UIViewController <SectionSlideDelegate>

@property (strong, nonatomic) NSArray *popupButtons;
@property (assign, nonatomic) NSInteger section;

@end
