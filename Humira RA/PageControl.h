//
//  PageView.h
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControlDelegate.h"

@interface PageControl : UIView<PageControlBehaviour>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *imageData;
@property (weak, nonatomic) id<PageControlDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

@end
