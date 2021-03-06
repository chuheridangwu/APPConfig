//
//  UILabel+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Method)
/// 创建label
+ (UILabel *)mm_createLabel:(UIColor *)color
                   fontSize:(CGFloat)fontSize
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text;

/// 创建label, 默认字体大小16
+ (UILabel *)mm_createLabel:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text;

/// 填写文字信息
- (void)mm_text:(NSString *)text
           font:(UIFont *)font
      textColor:(UIColor *)textColor;

/// 设置粗体
- (void)mm_setBoldFontSize:(CGFloat)fontSize;

/// 粗体加斜体
- (void)mm_setBoldObliqueFontSize:(CGFloat)fontSize;

/// 自适应高度的label
- (void)mm_adaptiveHeight:(NSString *)text
                        font:(CGFloat)font
                   textColor:(UIColor *)textColor;

/// 自适应宽度的label
- (void)mm_adaptiveWidth:(NSString *)text
                      font:(CGFloat)font
                 textColor:(UIColor *)textColor;

/// 自适应高度
- (void)mm_adaptiveHeight;

/// 自适应宽度
- (void)mm_adaptiveWidth;
@end

NS_ASSUME_NONNULL_END
