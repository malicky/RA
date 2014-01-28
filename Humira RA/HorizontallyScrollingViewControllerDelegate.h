//
//  HorizontallyScrollingViewControllerDelegate.h
//  Humira RA
//
//  Created by Developer on 12-03-08.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HorizontallyScrollingViewControllerDelegate <NSObject>

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id delegate;

@end
