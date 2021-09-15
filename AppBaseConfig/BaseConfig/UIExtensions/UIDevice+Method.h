//
//  UIDevice+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/20.
// 设备信息

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Method)

/**
 获取app版本  like iOS-183（1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersionFormed;

/**
 app版本 like 1.8.3 （1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersion;

+ (NSString *)mm_buildVersion;

/**
 app版本 like 183 （1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersionInt;

/**
 app名称
 @return app名称
 */
+ (NSString *)mm_appName;

/**
 设备名称
 @return 某某的iPhone
 */
+ (NSString *)mm_name;

/**
 系统名称
 @return ios
 */
+ (NSString *)mm_systemName;

/**
 设备类型
 @return iPhone ipod touch
 */
+ (NSString *)mm_model;

/**
 设备模式 eg 'iPhone8,1' is 'iPhone 6s'
 对比见  https://www.cnblogs.com/qinwuyan/p/6201707.html
 @return 设备模式
 */
+ (NSString *)mm_deviceModel;

/**
 当前手机的操作系统的版本
 @return 系统的版本
 */
+ (NSString *)mm_systemVersion;


/**
 获取请求头中的User-Agent
 
 @return @“iOS/5.3 (手机型号; APP版本号; 系统版本号; 手机时间)”
 */
+ (NSString *)mm_userAgent;

/**
 当前手机的idfa，如果用户关闭了广告则返回 00000000-0000-0000-0000-000000000000
 否则返回 和E621E1F8-C36C-495A-93FC-0C247A3E6E5F相似的字符
 @return idfa
 */
+ (NSString *)mm_IDFA;

/**
 用户关闭了广告，则生成一个UUID，否则返回广告idfa

 @return idfa or uuid
 */
+ (NSString *)mm_IDFAOrUUID;

/**
生成一个唯一的ID（保存在 keyChain）
 */
+ (NSString *)mm_UUID;

@end

NS_ASSUME_NONNULL_END
