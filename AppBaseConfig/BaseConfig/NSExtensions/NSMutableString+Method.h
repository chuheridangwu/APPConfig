//
//  NSMutableString+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (Method)
/**横划线   text文字内容  font 文字大小  color 颜色*/
- (NSAttributedString *)mm_text:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

/**
 @param text 全部内容
 @param fontSize 字体大小
 @param color 字体颜色
 @param underlineText 下划线内容
 @param underlineFontSize 下滑线文字大小
 @param underlineColor  下划线字体颜色
 */
- (NSMutableAttributedString *)mm_text:(NSString *)text
                               font:(UIFont *)fontSize
                              color:(UIColor *)color
                      underlineText:(NSString *)underlineText
                      underlineFont:(UIFont *)underlineFontSize
                     underlineColor:(UIColor *)underlineColor;

/**
 改变部分文字颜色
 @param text 文本内容
 @param fontSize 字体大小
 @param color 字体颜色
 @param discolorationText 变色内容
 @param discolorationFontSize 变色文字大小
 @param discolorationColor 变色字体颜色
 */
- (NSAttributedString *)mm_text:(NSString *)text
                        font:(UIFont *)fontSize
                       color:(UIColor *)color
           discolorationText:(NSString *)discolorationText
           discolorationFont:(UIFont *)discolorationFontSize
          discolorationColor:(UIColor *)discolorationColor;

/**
改变部分颜色，可以设置行间距
 @param text 全部内容
 @param fontSize 字体大小
 @param color 字体颜色
 @param discolorationText 变色内容
 @param discolorationFontSize 变色文字大小
 @param discolorationColor  变色字体颜色
 */
- (NSAttributedString *)mm_text:(NSString *)text
                        font:(UIFont *)fontSize
                       color:(UIColor *)color
                   lineSpace:(CGFloat)lineSpace
           discolorationText:(NSString *)discolorationText
           discolorationFont:(UIFont *)discolorationFontSize
          discolorationColor:(UIColor *)discolorationColor;

/**
  下划线  text 全部内容  fontSize 字体大小  color 字体颜色
 @param underlineText 下划线内容
 @param underlineFontSize 下滑线文字大小
 @param underlineColor 下划线字体颜色
 */
- (NSAttributedString *)mm_allText:(NSString *)text
                           font:(UIFont *)fontSize
                          color:(UIColor *)color
               allUnderlineText:(NSString *)underlineText
                  underlineFont:(UIFont *)underlineFontSize
                 underlineColor:(UIColor *)underlineColor;

/// 返回图文混编的富文本
/// @param imageList 图片信息  数组
/// @param text 文字信息  可以是 NSAttributedString 类型或者是 NSString 类型
/// @param font 文字大小
- (NSAttributedString *)mm_textImageList:(NSArray *)imageList
                                 text:(id)text
                                 font:(UIFont *)font;

/// 给文字添加阴影
/// @param text 文字信息
/// @param fontSize 文字大小
/// @param color 文字颜色
/// @param underlineText 需要添加阴影的文字
/// @param shadowColor 阴影颜色
- (NSAttributedString *)mm_text:(NSString *)text
                        font:(UIFont *)fontSize
                       color:(UIColor *)color
               allShadowText:(NSString *)underlineText
                 shadowColor:(UIColor *)shadowColor;


@end

@interface NSMutableAttributedString (Method)

/// 富文本
/// @param texts 处理的文字数组
/// @param colors 颜色
/// @param fonts 字体
- (void)mm_attibutedRangeString:(NSArray *)texts
                        colors:(NSArray *)colors
                         fonts:(NSArray *)fonts;
/// 富文本
/// @param subString 处理的文字串
/// @param color 颜色
/// @param fontSize 字体大小
- (instancetype)mm_attibutedRangeString:(NSString *)subString
                                  color:(UIColor *)color
                               fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
