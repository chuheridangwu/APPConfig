//
//  NSMutableString+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import "NSMutableString+Method.h"

@implementation NSMutableString (Method)

//横划线   text 文字内容  font 文字大小  color 颜色
- (NSAttributedString *)mm_text:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
    return string;
}

- (NSMutableAttributedString *)mm_text:(NSString *)text font:(UIFont *)fontSize color:(UIColor *)color underlineText:(NSString *)underlineText underlineFont:(UIFont *)underlineFontSize underlineColor:(UIColor *)underlineColor
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: fontSize,NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    
    [string addAttributes:@{NSForegroundColorAttributeName: underlineColor, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSFontAttributeName : underlineFontSize} range:[text rangeOfString:underlineText]];
    return string;
}

/**
 *  改变颜色  text 全部内容  fontSize 字体大小  color 字体颜色
 *         discolorationText 变色内容  discolorationFontSize 变色文字大小 discolorationColor变色字体颜色
 */
- (NSAttributedString *)mm_text:(NSString *)text font:(UIFont *)fontSize color:(UIColor *)color discolorationText:(NSString *)discolorationText discolorationFont:(UIFont *)discolorationFontSize discolorationColor:(UIColor *)discolorationColor
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: (fontSize),NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    [string addAttributes:@{NSForegroundColorAttributeName: discolorationColor,  NSFontAttributeName : (discolorationFontSize)} range:[text rangeOfString:discolorationText]];
    return string;
}

/**
 *  改变颜色 可以设置行间距   text 全部内容  fontSize 字体大小  color 字体颜色
 *         discolorationText 变色内容  discolorationFontSize 变色文字大小 discolorationColor变色字体颜色
 */
- (NSAttributedString *)mm_text:(NSString *)text font:(UIFont *)fontSize color:(UIColor *)color lineSpace:(CGFloat)lineSpace discolorationText:(NSString *)discolorationText discolorationFont:(UIFont *)discolorationFontSize discolorationColor:(UIColor *)discolorationColor
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: (fontSize),NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),NSParagraphStyleAttributeName:paragraphStyle}];
    if (discolorationText.length) {
        [string addAttributes:@{NSForegroundColorAttributeName: discolorationColor,  NSFontAttributeName : (discolorationFontSize)} range:[text rangeOfString:discolorationText]];
    }
    return string;
    
}


/**
 *  下划线  text 全部内容  fontSize 字体大小  color 字体颜色
 *         underlineText 下划线e内容  underlineFontSize 下滑线文字大小 underlineColor下划线字体颜色
 */
- (NSAttributedString *)mm_allText:(NSString *)text font:(UIFont *)fontSize color:(UIColor *)color allUnderlineText:(NSString *)underlineText underlineFont:(UIFont *)underlineFontSize underlineColor:(UIColor *)underlineColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: (fontSize),NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    NSArray * array = [text componentsSeparatedByString:underlineText];
    NSMutableString * str = [NSMutableString string];
    NSRange range;
    
    for (int i = 0; i < array.count; i++) {
        NSString * string = array[i];
        if ((str.length && [text hasSuffix:string]) || (string.length == 0 && i == array.count - 1)) {
            break;
        }
        [str appendString:string];
        NSLog(@"%@", str);
        range = NSMakeRange(str.length, underlineText.length);
        [attributedString addAttributes:@{
            NSForegroundColorAttributeName: underlineColor,
            NSFontAttributeName : (underlineFontSize)
            
        } range:range];
        [str appendString:underlineText];
        NSLog(@"%@", str);
    }
    
    return attributedString;
}

/// 返回图文混编的富文本
/// @param imageList 图片信息  数组
/// @param text 文字信息  可以是 NSAttributedString 类型或者是 NSString 类型
/// @param font 文字大小
- (NSAttributedString *)mm_textImageList:(NSArray *)imageList text:(id)text font:(UIFont *)font
{
    
    NSMutableAttributedString * abs = nil;
    
    if ([text isKindOfClass:[NSString class]]) {
        abs = [[NSMutableAttributedString alloc] initWithString:text];
    }else if ([text isKindOfClass:[NSAttributedString class]]){
        abs = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    }else{
        return nil;
    }
    
    NSMutableArray * array = @[].mutableCopy;
    CGFloat height = [@"" sizeWithAttributes:@{NSFontAttributeName : font}].height;
    
    for (UIImage * image in imageList) {
        
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        CGFloat width = image.size.width / image.size.height * height;
        attachment.bounds = CGRectMake(0, -1, width, height);
        NSAttributedString * str = [NSAttributedString attributedStringWithAttachment:attachment];
        [array addObject:str];
    }
    for (NSAttributedString * attStr in array) {
        [abs insertAttributedString:attStr atIndex:0];
    }
    return abs;
}


/// 给文字添加阴影
/// @param text 文字信息
/// @param fontSize 文字大小
/// @param color 文字颜色
/// @param underlineText 需要添加阴影的文字
/// @param shadowColor 阴影颜色
- (NSAttributedString *)mm_text:(NSString *)text font:(UIFont *)fontSize color:(UIColor *)color allShadowText:(NSString *)underlineText shadowColor:(UIColor *)shadowColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: (fontSize),NSForegroundColorAttributeName: color, NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowColor = shadowColor;
    
    NSArray * array = [text componentsSeparatedByString:underlineText];
    NSMutableString * str = [NSMutableString string];
    NSRange range;
    
    for (int i = 0; i < array.count; i++) {
        NSString * string = array[i];
        if ((str.length && [text hasSuffix:string]) || (string.length == 0 && i == array.count - 1)) {
            break;
        }
        [str appendString:string];
        NSLog(@"%@", str);
        range = NSMakeRange(str.length, underlineText.length);
        
        [attributedString addAttribute:NSShadowAttributeName value:shadow range:range];
        [str appendString:underlineText];
        NSLog(@"%@", str);
    }
    return attributedString;
}


@end


@implementation NSMutableAttributedString (Method)

- (void)mm_attibutedRangeString:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts
{
    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [self.string rangeOfString:texts[idx]];
        if (range.location != NSNotFound) {
            if (colors && colors.count == texts.count) {
                [self addAttribute:NSForegroundColorAttributeName value:colors[idx] range:range];
            }
            if (fonts && fonts.count == texts.count) {
                [self addAttribute:NSFontAttributeName value:fonts[idx] range:range];
            }
        }
    }];

}

- (instancetype)mm_attibutedRangeString:(NSString *)subString color:(UIColor *)color fontSize:(CGFloat)fontSize{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] init];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[self string] rangeOfString:subString].location, [[contentStr string] rangeOfString:subString].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:redRange];
    return  contentStr;
}

@end
