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

// 获取设备名称
+ (NSString *)mm_deviceName{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,4"])    return @"iPhone XS Maxs";
    if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Maxs";
    if ([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])    return @"iPhone SE 2";
    if ([deviceString isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";

    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}
@end
