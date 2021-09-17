//
//  NSObject+Method.h
//  AppBaseConfig
//
//  Created by mlive on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Method)

// 获取顶层控制器
+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
