//
//  AdmireAnimationView.m
//  9158Live
//
//  Created by daiyufeng on 16/3/26.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import "AdmireAnimationView.h"

@interface AdmireAnimationView ()
{
    UIView *superView;
    UIView *baseView;
    int animatiomNum;
    float nlevel;
}

@end

@implementation AdmireAnimationView

-(id)initWithSuperView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        superView = view;
        CGSize size = [UIScreen mainScreen].bounds.size;
        baseView = [[UIView alloc] initWithFrame:CGRectMake(size.width - 100, size.height/2 - 55, 100, size.height/2)];
        baseView.userInteractionEnabled = NO;
        [superView addSubview:baseView];
    }
    return self;
}

-(void)startWithLevel:(int)level number:(int)num
{
    animatiomNum = num;
    nlevel = level;
    [self showAdmireImage];
}

-(void)showAdmireImage
{
    if(animatiomNum -- == 0 )
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
    double width = (double)(arc4random() % 5) + 30;
    NSString *imageNamePath = [NSString stringWithFormat:@"good%d",(arc4random() % 9 + 1)];
    UIImageView *manImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50,
                                                                              baseView.bounds.size.height - 20,
                                                                              width,
                                                                              width)];
    manImageView.alpha = 0.85;
    manImageView.image = [UIImage imageNamed:imageNamePath];
    manImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [baseView addSubview:manImageView];
    [UIView animateWithDuration:0.2 animations:^{
        manImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
    int time = arc4random() % 15/10.0 + 2.5;
    [UIView animateWithDuration:1  animations:^{
        manImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time - 1.5 animations:^{
            manImageView.alpha = 0;
        }completion:^(BOOL finished) {
            [manImageView removeFromSuperview];
        }];
    }];
   
    //创建关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //在路径上添加一条曲线，需要指定路径经过点。
    CGMutablePathRef path = CGPathCreateMutable();
    //将编辑点移动到某个位置
    CGPathMoveToPoint(path, NULL, manImageView.center.x, manImageView.center.y);
    
    //从编辑点画一条直线到目标点。同时将编辑点移动到目标点。
    CGPathAddLineToPoint(path, NULL, arc4random() % 30 + 35, CGRectGetHeight(baseView.frame) / 3 * 2);
    int x = arc4random() % 60 + 20;
    CGPathAddLineToPoint(path, NULL, x, CGRectGetHeight(baseView.frame) / 3 * 1);
    //    CGPathAddLineToPoint(path, NULL, arc4random() % 50 +25, CGRectGetHeight(baseView.frame) / 3 );
    //    CGPathAddLineToPoint(path, NULL, arc4random() % 50 +25, CGRectGetHeight(baseView.frame) / 6 );
    CGPathAddLineToPoint(path, NULL, x, 0);
    
    //动画行进的路径
    animation.path = path;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = time;
    
    //释放路径
    CGPathRelease(path);
    
    [manImageView.layer addAnimation:animation forKey:@"position"];
    [self performSelector:@selector(showAdmireImage) withObject:nil afterDelay:1.0/nlevel];
}
@end
