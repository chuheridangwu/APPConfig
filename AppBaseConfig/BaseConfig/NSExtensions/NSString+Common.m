//
//  NSString+Common.m
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSString (Common)
/** 去掉所有的空格、换行符（包括中间的） */
- (NSString *)m_trimAll
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**去掉左右(首尾) 空格、换行符*/
- (NSString *)mm_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
// 获取ip地址
+ (NSString *)mm_IPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                    NSLog(@"IP:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)]);
                return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

/*手机号邮箱加密显示*/
- (NSString *)mm_mobileAndEmailEncryption
{
    if (self.length > 0) {
        NSMutableString *tmpStr = [NSMutableString stringWithString:self];
        if (self.length == 11) {//手机号
            [tmpStr replaceCharactersInRange:NSMakeRange(5, 4) withString:@"****"];
            return tmpStr;
        }else{
            return @"";
        }
    }else if (self.length > 0){
        NSMutableString *tmpStr = [NSMutableString stringWithString:self];
        NSRange range = [self rangeOfString:@"@"];
        if (range.location != NSNotFound) {//邮箱
            if (range.location > 2) {
                [tmpStr replaceCharactersInRange:NSMakeRange(2, range.location-2) withString:@"*"];
            }else{
                [tmpStr replaceCharactersInRange:NSMakeRange(range.location-1, 1) withString:@"*"];
            }
            return tmpStr;
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

- (NSString*)mm_wifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (NSDictionary *)mm_jsonStringToDictionary{
    NSData *JSONData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/// 字符串转数组
- (NSArray *)mm_jsonStringToArray{
    NSData *JSONData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return ary;
}

@end

#pragma mark -- 计算文字的宽高
@implementation NSString (Size)

- (CGSize)mm_sizeWithFont:(CGFloat)font maxWidth:(CGFloat)width
{
    if (self.length > 0) {
        CGRect frame = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
        return frame.size;
    }
    return CGSizeZero;
}

/**
 根据最大适应的高度和字体，来计算文字的宽度
 
 @param font 文本的字体
 @param height 最大适应的宽度
 @return 计算的文字的大小
 */
- (CGSize)mm_sizeWithFont:(CGFloat)font maxHeight:(CGFloat)height
{
    if (self.length > 0) {
        CGRect frame = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:
                        NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
        
        return frame.size;
    }
    return CGSizeZero;
}
@end

#pragma mark -- 处理URL相关的问题
@implementation NSString (URL)

// URL编码
-(NSString *)mm_encodedString
{
    NSString *string = self;
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

// URL decode
-(NSString *)mm_decodedString
{
    NSString *string = self;
    return [string stringByRemovingPercentEncoding];
}
/**
 该字符是一个URL链接，则可以调用此方法获取此链接的所有参数
 @return 参数列表
 */
-(NSDictionary *)mm_URLParameters{
    if (![self respondsToSelector:@selector(rangeOfString:)]) {
        return nil;
    }
    //获取问号的位置，问号后是参数列表
    NSRange range = [self rangeOfString:@"?"];
    
    NSString *propertys = nil;
    if (range.length == 0) {
        propertys = self;
    } else if (self.length > 1){
        propertys = [self substringFromIndex:(int)(range.location+1)];
    }
    if (propertys) {
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithCapacity:subArray.count];
        [subArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:@"="]) {
                NSArray *dicArray = [obj componentsSeparatedByString:@"="];
                [paras setObject:[dicArray[1] mm_decodedString]
                          forKey:[dicArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
        }];
        return paras;
    }
    return @{@"paras": [self ?:@"" mm_decodedString]};
}

/**
 像URL参数一样拼接到该URL中
 例如   https://m.manjd.com   {@"w":@"23"}  =>  https://m.manjd.com?w=23
 @param params 参数，不支持包含NSArray类型
 @return 拼接好的URL
 */
-(NSString *)mm_URLAppendingParameters:(NSDictionary *)params
{
    NSString *string = self;
    if (!params.count) {
        return string;
    }
    if ([string rangeOfString:@"?"].location==NSNotFound) {
        string = [string stringByAppendingString:@"?"];
    } else if([string hasSuffix:@"&"]) {
        string = [string substringToIndex:string.length-1];
    }
    BOOL hasMark = [string hasSuffix:@"?"];
    NSMutableString *mstr = [[NSMutableString alloc] initWithString:string];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        if(hasMark) {
            [mstr appendFormat:@"%@=%@&", key, obj];
        } else {
            [mstr appendFormat:@"&%@=%@", key, obj];
        }
    }];
    if([mstr hasSuffix:@"&"]) {
        return [mstr substringToIndex:mstr.length-1];
    }
    return mstr;
}
@end

#pragma mark -- 加密相关
@implementation  NSString (Encrypt)

/**base64加密 */
- (NSString *)mm_ecodeBase64String {
    if (self && [self length] > 0) {
        //加密
        //先把 字符串  str 转成 NSData类型
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        //把加密后的NSData转成base64编码
        data = [data base64EncodedDataWithOptions:0];
        NSString * ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return ret;
    }
    return @"";
}

/**base64解密 */
- (NSString *)mm_decodeBase64String {
    
    if (self && [self length] > 0) {
        //把base64字符串编译成NSData
        NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
        //把NSData转成字符串
        NSString * decode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return decode;
    }
    return @"";
}

// md5 在iOS13中会被警告，现在使用SHA256加密
-(NSString *)mm_md5
{
    if(self == nil || [self length] == 0) return nil;
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (NSString*)mm_sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output isKindOfClass:NSNull.class] ? @"" : output;
}
@end

@implementation NSString (Bool)

-(BOOL)mm_isValidURL {
    NSString *url = self.lowercaseString;
    return [url hasPrefix:@"http:"] || [url hasPrefix:@"https:"];
}

- (BOOL)mm_isValidAlphabet {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Za-z]+$"] evaluateWithObject:self];
}

- (BOOL)mm_isNumber {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+$"] evaluateWithObject:self];
}

// 固定电话
- (BOOL)mm_isFixedLinePhone {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^((0\\d{2,3}-\\d{7,8})|(1[3456789]\\d{9}))$"]
            evaluateWithObject:self];
}
//手机号码只可以输入数字
//0开头的号码就10位；
//不是0开头的号码就9位；
//如果是0开头的号码，则第二个数字必须为6 8 9
//如果不是0开头的号码，则第一个数字必须为6 8 9
- (BOOL)mm_isValidMobile
{
    NSArray *arr = @[@"6",@"8",@"9"];
    NSString *mobile = self;
    if (mobile.length < 9) return NO;
    
    if ([[mobile substringToIndex:1] isEqualToString:@"0"]&&mobile.length==10&&[arr containsObject:[mobile substringWithRange:NSMakeRange(1, 1)]]) {
        NSScanner* scan = [NSScanner scannerWithString:mobile];
        int val;
        return [scan scanInt:&val] && [scan isAtEnd];
    }else if (!([[mobile substringToIndex:1] isEqualToString:@"0"])&&mobile.length==9&&[arr containsObject:[mobile substringToIndex:1]]){
        NSScanner* scan = [NSScanner scannerWithString:mobile];
        int val;
        return [scan scanInt:&val] && [scan isAtEnd];
    }
    return NO;
}

-(BOOL)mm_isDecimalNumber {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([1-9]\\d*|0)(\\.\\d*)?$"] evaluateWithObject:self];
}

- (BOOL)mm_isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)mm_isValidRuleNotBlank
{
    NSString *string = self;
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒a-zA-Z0-9\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（包括空格、（）()）
 */
- (BOOL)mm_isValidRuleAndBlank
{
    NSString *string = self;
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒（）()a-zA-Z0-9\u4E00-\u9FA5\\s]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch1 = [pred evaluateWithObject:string];
    
    return isMatch1;
}

/**
 数字和字母
 */
- (BOOL)mm_isValidNumberAndCharacter
{
    NSString *str = self;
    NSString *pattern = @"^[a-zA-Z\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


/**
 纳税人识别号
 */
- (BOOL)mm_isValidDutyNumber
{
    NSString *str = self;
    NSArray *arr = @[@"^[\\da-zA-Z]{10,15}$",
                     @"^\\d{6}[\\da-zA-Z]{10,12}$",
                     @"^[a-zA-Z]\\d{6}[\\da-zA-Z]{9,11}$",
                     @"^[a-zA-Z]{2}\\d{6}[\\da-zA-Z]{8,10}$",
                     @"^\\d{14}[\\dxX][\\da-zA-Z]{4,5}$",
                     @"^\\d{17}[\\dxX][\\da-zA-Z]{1,2}$",
                     @"^[a-zA-Z]\\d{14}[\\dxX][\\da-zA-Z]{3,4}$",
                     @"^[a-z]\\d{17}[\\dxX][\\da-zA-Z]{0,1}$",
                     @"^[\\d]{6}[\\da-zA-Z]{13,14}$"
                     ];
    for (NSString *pattern in arr) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:str];
        if (isMatch) {
            return YES;
        }
    }
    return NO;
}






/**
 * 地址详情输入
 */
- (BOOL)mm_isValidAddressInfo
{
    NSString *str = self;
    NSString *pattern = @"[a-zA-Z0-9#_\\-\\(\\)\\s\\u4e00-\\u9fa5]{3,30}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 * 地址收件人输入
 */
- (BOOL)mm_isValidAddressName
{
    NSString *str = self;
    if ([str hasPrefix:@"老"]||[str hasPrefix:@"大"]||[str hasPrefix:@"小"]||[str hasPrefix:@"啊"]||[str hasPrefix:@"阿"]) {
        return NO;
    } else if ([str hasSuffix:@"先生"] || [str hasSuffix:@"小姐"] || [str hasSuffix:@"女士"]) {
        return NO;
    }
    
    NSString *patterns = @"[\\u4e00-\\u9fa5]{2,5}";
    NSPredicate *preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patterns];
    BOOL isMatchs = [preds evaluateWithObject:str];
    return isMatchs;
}

-(BOOL)mm_containsNativeEmoji {
    __block BOOL contain = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if ([substring mm_isEmoji]) {
            contain = YES;
            *stop = YES;
        }
    }];
    return contain;
}

// 检查一个‘字符’是否是emoji表情
// http://stackoverflow.com/questions/25861468/how-to-disable-ios-8-emoji-keyboard
- (BOOL)mm_isEmoji
{
    if (self.length <= 0) {
        return NO;
    }
    unichar first = [self characterAtIndex:0];
    switch (self.length) {
        case 1:
        {
            if (first == 0xa9 || first == 0xae || first == 0x2122 ||
                first == 0x3030 || (first >= 0x25b6 && first <= 0x27bf) ||
                first == 0x2328 || (first >= 0x23e9 && first <= 0x23fa)) {
                return YES;
            }
        } break;
        case 2:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x203c && first <= 0x3299) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        } break;
        case 3:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xfe0f) {
                if (first >= 0x23 && first <= 0x39) {
                    return YES;
                }
            }
            else if (c == 0xd83c) {
                if (first == 0x26f9 || first == 0x261d || (first >= 0x270a && first <= 0x270d)) {
                    return YES;
                }
            }
            if (first == 0xd83c) {
                return YES;
            }
        }  break;
        case 4:
        {
            unichar c = [self characterAtIndex:1];
            if (c == 0xd83c) {
                if (first == 0x261d || first == 0x270c) {
                    return YES;
                }
            }
            if (first >= 0xd83c && first <= 0xd83e) {
                return YES;
            }
        } break;
        case 5:
        {
            if (first == 0xd83d) {
                return YES;
            }
        } break;
        case 8:
        case 11:
        {
            if (first == 0xd83d) {
                return YES;
            }
        } break;
        default:
            break;
    }
    return NO;
}

+ (BOOL)m_isEmoji:(NSString *)srt{
    return [srt mm_isEmoji];
}
@end

#pragma Mark-- 时间

@implementation NSString(Time)
+(NSString*)mm_currentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date] ];
    return dateTime;
}

@end


@implementation NSString (AttributedString)

- (NSMutableAttributedString*)mm_attibutedRangeString:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts
{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];

    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [contentStr.string rangeOfString:texts[idx]];
        if (range.location != NSNotFound) {
            if (colors && colors.count == texts.count) {
                [contentStr addAttribute:NSForegroundColorAttributeName value:colors[idx] range:range];
            }
            if (fonts && fonts.count == texts.count) {
                [contentStr addAttribute:NSFontAttributeName value:fonts[idx] range:range];
            }
        }
    }];
    
    return contentStr;
}

- (NSMutableAttributedString*)mm_attibutedRangeString:(NSString *)subString color:(UIColor *)color fontSize:(CGFloat)fontSize{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSString *string1 = [self stringByAppendingString:subString];
    NSString *temp;
    for (int i = 0; i < self.length; i++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subString.length)];
        if ([temp isEqualToString:subString]) {
            NSRange range = {i,subString.length};
            //修改特定字符的颜色
            [contentStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            //修改特定字符的字体大小
            [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:range];
        }
    }
    return  contentStr;
}

@end


#pragma mark -- 进制之间的转换
@implementation NSString (Base)
/**
 十进制转换为二进制
 @param decimal 十进制数;
 @return 二进制数
 */
+ (NSString *)mm_binaryByDecimal:(NSInteger)decimal{
    NSString *binary = @"";
    while (decimal) {

        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {

            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {

        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {

            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

/**
 十进制转换十六进制
  
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)mm_getHexByDecimal:(NSInteger)decimal{
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    
    if (hex.length == 1) {
        hex = [NSString stringWithFormat:@"0%@",hex];
    }
    
    return hex;
}

/**
 二进制转换成十六进制
   
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary{
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}


/**
 十六进制转换为二进制
   
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex{
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

/**
 二进制转换为十进制
  
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary{
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

// 十六进制Data 数据转成 十六进制的字符串   比如 <00A40402> = @"00A40402"
-(NSString *)mm_hexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}

// 十六进制字符串 数据转成 十六进制的data数据   比如  @"00A40402" = <00A40402>
- (NSData *)mm_hexToBytes:(NSString *)str{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

// 十六进制字符串 数据转成 十进制
- (NSString*)mm_decimal{
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanHexLongLong:&result];
    return  [NSString stringWithFormat:@"%lld",result];
}

@end
