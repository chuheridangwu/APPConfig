//
//  UIViewController+Method.m
//  AppBaseConfig
//
//  Created by mlive on 2021/11/19.
//

#import "UIViewController+Method.h"

@implementation UIViewController (Method)
// 初始化
+ (instancetype)mm_instance
{
    NSString *clazz = NSStringFromClass([self class]);
    NSString *path = [[NSBundle mainBundle] pathForResource:clazz ofType:@"nib"];
    if (path.length) {
        return [NSBundle.mainBundle loadNibNamed:clazz owner:nil options:nil].firstObject;
    }
    return [[self class] new];
}

@end
