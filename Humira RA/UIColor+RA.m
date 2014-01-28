//
//  UIColor+RA.m
//  Humira RA
//
//  Created by Developer on 12-03-06.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIColor+RA.h"

@implementation UIColor (RA)

+ (UIColor *)humiraGrey {
    UIColor *color = [UIColor colorWithRed:0.45490196078431 green:0.45882352941176 blue:0.52549019607843 alpha:1.0];
    return color;
}

+ (UIColor *)humiraGreen {
    UIColor *color = [UIColor colorWithRed:0.75686274509804 green:0.80392156862745 blue:0.13725490196078 alpha:1.0];
    return color;
}

//+ (UIColor *)humiraGreen alpha:(CGFloat)alpha {
//    UIColor *color = [UIColor colorWithRed:0.75686274509804 green:0.80392156862745 blue:0.13725490196078 alpha:1.0];
//    return color;
//}

+ (UIColor *)humiraPink {
    UIColor *color = [UIColor colorWithRed:0.69411764705882 green:0 blue:0.36470588235294 alpha:1.0];
    return color;
}

+ (UIColor *)commitmentSectionTitleColor {
    UIColor *color = [UIColor colorWithRed:0.49019607843137 green:0.47058823529412 blue:0.47058823529412 alpha:1.0];
    return color;
}

@end
