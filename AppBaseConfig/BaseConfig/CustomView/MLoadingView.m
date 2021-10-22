//
//  XLoadingView.m
//  xazhyl
//
//  Created by lx on 2020/1/15.
//  Copyright © 2020 cn.gov.baoan.xajd. All rights reserved.
//

#import "MLoadingView.h"

@interface MLoadingView ()

@end

@implementation MLoadingView {
    CAReplicatorLayer *_containerLayer2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, 50, 50);
        
        _containerLayer2 = [CAReplicatorLayer layer];
        _containerLayer2.masksToBounds = YES;
        _containerLayer2.instanceCount = 9;
        _containerLayer2.instanceDelay = 0.7 / _containerLayer2.instanceCount;
        _containerLayer2.instanceTransform = CATransform3DMakeRotation(AngleWithDegrees(360 / _containerLayer2.instanceCount), 0, 0, 1);
        [self.layer addSublayer:_containerLayer2];
        _containerLayer2.frame = self.bounds;
        
        
    }
    return self;
}

- (void)startAnimating {
    
    
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.backgroundColor = UIColor.darkGrayColor.CGColor;
    subLayer2.frame = CGRectMake((50 - 10) / 2, 0, 10, 10);
    subLayer2.cornerRadius = 10 / 2;
    subLayer2.transform = CATransform3DMakeScale(0, 0, 0);
    [_containerLayer2 addSublayer:subLayer2];
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @(1);
    animation2.toValue = @(0.1);
    animation2.repeatCount = HUGE;
    animation2.duration = 0.7;
    [subLayer2 addAnimation:animation2 forKey:nil];
}



@end
