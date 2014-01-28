//
//  SectionSlideDelegate.h
//  Humira RA
//
//  Created by Developer on 12-02-29.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SectionSlideDelegate <NSObject>
@required
@property (strong, nonatomic) NSArray *popupButtons;
@property (assign, nonatomic) NSInteger section;

@optional
- (void)didSelectSection:(NSInteger)section;

@end
