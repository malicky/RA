//
//  DreamSlideBaseViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-03.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionSlideDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface DreamSlideBaseViewController : UIViewController <SectionSlideDelegate>

@property (strong, nonatomic) NSArray *popupButtons;
@property (assign, nonatomic) NSInteger section;

@end
