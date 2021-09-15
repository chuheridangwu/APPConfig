//
//  NSString+Common.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)

/** 去掉所有的空格、换行符（包括中间的） */
- (NSString *)m_trimAll;

/**去掉左右(首尾) 空格、换行符*/
- (NSString *)mm_trim;
/**获取ip地址*/

/*
 获取手机号邮箱加密
 1，手机号:显示前5位以及后2位  中间4位加密  13926****64
 2，邮箱:
 2.1  @前大于2位 以XX＊@显示 比如as＊@qq.com
 2.2  @前小于等于2位 以X＊@显示  比如a＊@qq.com
 */
- (NSString *)mm_mobileAndEmailEncryption;

/// 获取 WIFI 名称
- (NSString*)mm_wifiName;
@end

@interface NSString (Size)

/**
 根据最大适应的宽度和字体，来计算文字的高度

 @param font 文本的字体
 @param width 最大适应的宽度
 @return 计算的文字的大小
 */
- (CGSize)mm_sizeWithFont:(CGFloat)font maxWidth:(CGFloat)width;

/**
 根据最大适应的高度和字体，来计算文字的宽度
 
 @param font 文本的字体
 @param height 最大适应的宽度
 @return 计算的文字的大小
 */
- (CGSize)mm_sizeWithFont:(CGFloat)font maxHeight:(CGFloat)height;

@end

#pragma mark -- URL相关
@interface NSString (URL)

/** URL编码 */
- (NSString *)mm_encodedString;

/** URL decode */
- (NSString *)mm_decodedString;

/**
 该字符是一个URL链接，则可以调用此方法获取此链接的所有参数
 @return 参数列表
 */
-(NSDictionary *)mm_URLParameters;

/**
 像URL参数一样拼接到该URL中
 例如   https://m.manjd.com   {@"w":@"23"}  =>  https://m.manjd.com?w=23
 @param params 参数，不支持包含NSArray类型
 @return 拼接好的URL
 */
-(NSString *)mm_URLAppendingParameters:(NSDictionary *)params;
@end

#pragma mark -- 加密相关
@interface NSString (Encrypt)
/**base64加密 */
- (NSString *)mm_ecodeBase64String;

/**base64解密 */
- (NSString *)mm_decodeBase64String;

/**md5 加密字符串 */
- (NSString *)mm_md5;
@end

#pragma mark -- 常用的判断方法
@interface NSString (Bool)

/**是不是以 http: https: 开头的*/
- (BOOL)mm_isValidURL;

/**
 只能是 字母 A-Z a-z
 @return 是否为 字母
 */
- (BOOL)mm_isValidAlphabet;

/**
 验证是否是整数
 @return YES：整数
 */
- (BOOL)mm_isNumber;

/**
 是不是小数（只能是小数，整数也是返回NO）
 @return 只能是小数
 */
- (BOOL)mm_isDecimalNumber;

/**
 验证是否符合邮箱号码
 @return 是不是正确邮箱格式
 */
- (BOOL)mm_isValidEmail;

/**
验证是不是手机号码  以1开头的 11位数字
@return 是不是手机号码
 */
- (BOOL)mm_isValidMobile;

/**
 是不是固定电话号码  0735-12345678
 @return 固定电话
 */
- (BOOL)mm_isFixedLinePhone;

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)mm_isValidRuleNotBlank;

/**
 * 字母、数字、中文正则判断（包括空格、（）()）
 */
- (BOOL)mm_isValidRuleAndBlank;

/**
 数字和字母
 */
- (BOOL)mm_isValidNumberAndCharacter;

/**
 纳税人识别号
 */
- (BOOL)mm_isValidDutyNumber;

/**
 * 地址详情输入
 */
- (BOOL)mm_isValidAddressInfo;

/**
 * 地址收件人输入
 */
- (BOOL)mm_isValidAddressName;

/** 是否包含系统中的emoji */
- (BOOL)mm_containsNativeEmoji;

/** 检查一个‘字符’是否是emoji表情*/
+ (BOOL)m_isEmoji:(NSString *)srt;
@end

@interface NSString (Time)
/**当前时间*/
+(NSString*)mm_currentTime;
@end
NS_ASSUME_NONNULL_END
