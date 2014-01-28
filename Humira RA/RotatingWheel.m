//
//  RotatingWheel.m
//  Humira RA
//
//  Created by Developer on 12-02-20.
//  Copyright (c) 2012 . All rights reserved.
//

#import "RotatingWheel.h"

@implementation RotatingWheel
@synthesize delegate = _delegate;
@synthesize currentSection = _currentSection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];    
    CGPoint origin = [touch locationInView:self.superview];
    _startLocation = origin;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    CGFloat distance = [self distanceFor:location andPoint:_startLocation];
    if (distance > 6.0f) {
        [self updateRotation:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    CGFloat distance = [self distanceFor:location andPoint:_startLocation];
    if (distance > 6.0f) {
        _rotationAngle = [self updateRotation:location];
        [self finishRotation];
    } else {
        [self.delegate rotatingWheel:self tappedSection:_currentSection];
    }
}

- (CGFloat)distanceFor:(CGPoint)point1 andPoint:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
}

- (CGFloat) updateRotation:(CGPoint)location
{
    CGFloat (^rotationLimit)(CGFloat , CGFloat, CGFloat) = ^(CGFloat angle, CGFloat min, CGFloat max) {
        if(angle < min) return max - (min - angle);
        if(angle > max) return min - (max - angle);
        return angle;
    };
    
    CGFloat fromAngle = atan2f(_startLocation.y - self.center.y, _startLocation.x - self.center.x);
    CGFloat toAngle = atan2f(location.y - self.center.y, location.x - self.center.x);
    CGFloat newAngle = rotationLimit(_rotationAngle + (toAngle - fromAngle), 0, 2*M_PI);
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(newAngle);
    
    //    DLog("volume knob from angle: %f, to angle: %f, new angle: %f", fromAngle, toAngle, newAngle);
    self.transform = rotation;
    return newAngle;
}

- (void)finishRotation {
    CGFloat powerAngle = 0;
    CGFloat powerAngle2 = 2*M_PI;
    CGFloat commitmentAngle = (4.0f * M_PI) / 3.0f;
    CGFloat dreamAngle = (2.0f * M_PI) / 3.0f;
    
    CGFloat deltaPower = MIN(fabs(_rotationAngle - powerAngle), fabs(_rotationAngle - powerAngle2));
    CGFloat deltaCommitment = fabs(_rotationAngle - commitmentAngle);
    CGFloat deltaDream = fabs(_rotationAngle - dreamAngle);
    
//    NSLog(@"p=%f c=%f d=%f", deltaPower, deltaCommitment, deltaDream);
    CGFloat newAngle = 0.0f;
    if (deltaPower == MIN(deltaPower, MIN(deltaCommitment, deltaDream))) {
        newAngle = powerAngle;
        _currentSection = SectionPower;
    } else if (deltaCommitment == MIN(deltaPower, MIN(deltaCommitment, deltaDream))) {
        newAngle = commitmentAngle;
        _currentSection = SectionCommitment;
    } else if (deltaDream == MIN(deltaPower, MIN(deltaCommitment, deltaDream))) {
        newAngle = dreamAngle;
        _currentSection = SectionDream;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeRotation(newAngle);
    } completion:^(BOOL finished) {
        _rotationAngle = newAngle;
    }];
}

@end
