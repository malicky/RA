//
//  PageControlDelegate.h
//  Humira RA
//
//  Created by Developer on 12-02-24.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PageControlBehaviour <NSObject>
@required
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *imageData;

@end

@protocol PageControlDelegate <NSObject>
@required
- (void)didSelectPageControl:(UIView<PageControlBehaviour> *)pageControl withUserInfo:(NSDictionary *)userInfo;

@end
