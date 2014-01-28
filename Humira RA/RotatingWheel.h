//
//  RotatingWheel.h
//  Humira RA
//
//  Created by Developer on 12-02-20.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum WheelSection {
    SectionPower = 0,
    SectionCommitment = 1,
    SectionDream = 2
} WheelSection;


@class RotatingWheel;
@protocol RotatingWheelDelegate <NSObject>
@required
- (void)rotatingWheel:(RotatingWheel *)rotatingWheel tappedSection:(WheelSection)section;
@end


@interface RotatingWheel : UIImageView {
@private
    CGPoint _startLocation;
    CGFloat _rotationAngle;
}

@property (weak, nonatomic) IBOutlet id<RotatingWheelDelegate> delegate;
@property (assign, nonatomic, readonly) WheelSection currentSection;

- (CGFloat)distanceFor:(CGPoint)point1 andPoint:(CGPoint)point2;
- (CGFloat) updateRotation:(CGPoint)location;
- (void)finishRotation;

@end
