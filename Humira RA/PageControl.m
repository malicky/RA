//
//  PageView.m
//  Humira RA
//
//  Created by Developer on 12-02-23.
//  Copyright (c) 2012 . All rights reserved.
//

#import "PageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+RA.h"

@interface PageControl()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *button;

- (NSString *)titleText;
- (NSString *)detailText;
- (UIImage *)backgroundImage;
- (UIImage *)selectedImage;

@end

@implementation PageControl
@synthesize index = _index;
@synthesize imageData = _imageData;
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize button = _button;
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
        self.button.titleLabel.shadowOffset = CGSizeMake(-1, -1);
//        self.button.titleLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.4];
        [self.button setTitleColor:[UIColor colorWithWhite:0.45 alpha:0.4] forState:UIControlStateNormal];
        [self.button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
        self.button.backgroundColor = [UIColor clearColor];
        self.button.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
        [self addSubview:self.button];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.75];
        self.titleLabel.shadowOffset = CGSizeMake(1, 1);
        self.titleLabel.numberOfLines = 2;
//        self.titleLabel.layer.shadowColor = [[UIColor blueColor] CGColor];
//        self.titleLabel.layer.shadowOffset = CGSizeMake(2, 4);
//        self.titleLabel.layer.shadowOpacity = 1.0f;
//        self.titleLabel.layer.shadowRadius = 5.0f;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
//        self.detailLabel = [[UILabel alloc] init];
//        self.detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//        self.detailLabel.backgroundColor = [UIColor clearColor];
//        self.detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
//        self.detailLabel.textColor = [UIColor lightGrayColor];
//        self.detailLabel.shadowColor = [UIColor darkGrayColor];
//        self.detailLabel.shadowOffset = CGSizeMake(3, 3);
//        self.detailLabel.textAlignment = UITextAlignmentCenter;
//        [self addSubview:self.detailLabel];        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.frame = CGRectInset(self.bounds, 20, 35);
    self.titleLabel.frame = CGRectInset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 1.5f), 30, 30);
//    self.detailLabel.frame = CGRectMake(0, self.frame.size.height / 2.0f, self.frame.size.width, self.frame.size.height / 2.0f);
}

- (void)setImageData:(NSDictionary *)imageData {
    if (_imageData != imageData) {
        _imageData = imageData;
    }
    
    [self.button setBackgroundImage:[self backgroundImage] forState:UIControlStateNormal];
    [self.button setBackgroundImage:[self selectedImage] forState:UIControlStateHighlighted];
    [self.button setTitle:[self detailText] forState:UIControlStateNormal];
    self.titleLabel.text = [self titleText];
//    self.detailLabel.text = [self detailText];
}

- (NSString *)titleText {
    NSString *text = [self.imageData valueForKey:@"title"];
    return text;
}

- (NSString *)detailText {
    NSString *text = [self.imageData valueForKey:@"details"];
    return text;
}

- (UIImage *)backgroundImage {
    NSString *name = [self.imageData valueForKey:@"background"];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

- (UIImage *)selectedImage  {
    NSString *name = [self.imageData valueForKey:@"selected"];
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

- (void)handleSelect:(id)sender {
    if (self.delegate) {
        [self.delegate didSelectPageControl:self withUserInfo:nil];
    }
}

@end
