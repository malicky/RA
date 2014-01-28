//
//  Power5ViewController.h
//  Humira RA
//
//  Created by Developer on 12-03-01.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerSlideBaseViewController.h"
#import "PowerToolSectionBaseViewController.h"

@interface Power5ViewController : PowerSlideBaseViewController <UIScrollViewDelegate, PowerToolScrollDelegate, PowerToolSectionAnswerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *wallImageView;

@property (strong, nonatomic) NSArray *configuredPageViewControllers;
@property (strong, nonatomic) NSMutableArray *popupButtons;
@property (weak, nonatomic) IBOutlet UIButton *remissionButton;
@property (weak, nonatomic) IBOutlet UIButton *clinicalResponseButton;
@property (weak, nonatomic) IBOutlet UIButton *radiographicProgressionButton;

- (IBAction)selectSubsection:(id)sender;
@end
