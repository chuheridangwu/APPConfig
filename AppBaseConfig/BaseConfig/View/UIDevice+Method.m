//
//  UIDevice+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/20.
//

#import "UIDevice+Method.h"
#import <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>
#import "SSKeychain.h"

@implementation UIDevice (Method)
/**
 获取app版本  like iOS-183（1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersionFormed
{
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int systemVersion = 0;
        NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        for (NSString *str in [versionStr componentsSeparatedByString:@"."]) {
            systemVersion = systemVersion*10 + str.intValue;
        }
        version = [NSString stringWithFormat:@"iOS-%d", systemVersion];
    });
    
    return version;
}

/**
 app版本 like 1.8.3 （1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersion
{
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    });
    return version;
}

+ (NSString *)mm_buildVersion
{
    static NSString *buildVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    });
    return buildVersion;
}

/**
 app版本 like 183 （1.8.3）
 @return 版本号
 */
+ (NSString *)mm_appVersionInt {
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int systemVersion = 0;
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        for (NSString *str in [version componentsSeparatedByString:@"."]) {
            systemVersion = systemVersion*10 + str.intValue;
        }
        version = [NSString stringWithFormat:@"%d", systemVersion];
    });
    return version;
}

/**
 app名称
 @return app名称
 */
+ (NSString *)mm_appName
{
    static NSString *name;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    });
    return name;
}

/**
 设备名称
 @return 某某的iPhone
 */
+ (NSString *)mm_name {
    return [[UIDevice currentDevice] name];
}

/**
 系统名称
 @return ios
 */
+ (NSString *)mm_systemName {
    return  [[UIDevice currentDevice] systemName];
}

/**
 设备类型
 @return iPhone ipod touch
 */
+ (NSString *)mm_model {
    return  [[UIDevice currentDevice] model];
}

/**
 设备模式 eg 'iPhone8,1' is 'iPhone 6s'
 对比见  https://www.cnblogs.com/qinwuyan/p/6201707.html
 @return 设备模式
 */
+ (NSString *)mm_deviceModel
{
    static NSString *deviceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return deviceModel ?: @"iOS";
}

/**
 当前手机的操作系统的版本
 @return 系统的版本
 */
+ (NSString *)mm_systemVersion
{
    return [UIDevice currentDevice].systemVersion ?: @"";
}

/**
 获取请求头中的User-Agent

 @return @“iOS/5.3 (手机型号; APP版本号; 系统版本号; 手机时间)”
 */
+ (NSString *)mm_userAgent
{
    NSString *time = [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970]];
    NSString *userAgent = [NSString stringWithFormat:@"iOS/5.3 (%@; %@; %@; %@)", [UIDevice mm_UUID], [UIDevice mm_appVersion], [UIDevice mm_systemVersion],time];
    return userAgent;
}

/**
 当前手机的idfa，如果用户关闭了广告则返回 @""
 idfa 在iOS14 需要申请权限
 否则返回 和E621E1F8-C36C-495A-93FC-0C247A3E6E5F相似的字符
 @return idfa
 */
+ (NSString *)mm_IDFA
{
    if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
        static NSString *IDFA;
        if (IDFA.length == 0) {
            IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            BOOL isLimited = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[-?0]+"] evaluateWithObject:IDFA];
            if(!isLimited) return IDFA;
        }
    }
    return @"";
}

/**
 用户关闭了广告，则生成一个UUID，否则返回广告idfa
 
 @return idfa or uuid
 */
+ (NSString *)mm_IDFAOrUUID
{
    NSString *IDFA = [self mm_IDFA];
    if (IDFA.length) {
        return IDFA;
    }
    return [self mm_UUID];
}

/**
 生成一个唯一的ID（保存在 keyChain）
 */
static NSString *key = @"app_idfa";
static NSString *value = @"com.xxx.xxx";
+ (NSString *)mm_UUID
{
    NSString * currentidfa = [SSKeychain passwordForService:value account:key];
    if ([currentidfa length] == 0 || [currentidfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        currentidfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if ([currentidfa length] > 0) {
            [SSKeychain setPassword:currentidfa forService:value account:key];
        }
    }
    return currentidfa;
}

@end
