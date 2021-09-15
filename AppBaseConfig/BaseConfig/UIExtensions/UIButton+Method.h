//
//  UIButton+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Method)
/**
 创建一个按钮
 @param fontSize 文本的字体
 @param title 文字
 @param textColor 文字颜色
 @param target  接收点击事件的控件
 @param action  事件
 @return 一个按钮
 */
+ (UIButton *)mm_createButton:(CGFloat)fontSize
                        title:(NSString *)title
                    textColor:(UIColor *)textColor
                       target:(nullable id)target action:(SEL)action;


/// 高亮颜色设置
/// @param color 颜色
- (void)mm_setHightLightWithColor:(UIColor *)color;


/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
- (void)mm_setHightLightGradientsWith:(UIColor *)startColor
                             endColor:(UIColor *)endColor;

/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
/// @param size 渐变大小
- (void)mm_setHightLightGradientsWith:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                                 size:(CGSize)size;

/// 高亮背景渐变设置
/// @param colors 渐变色数组
/// @param locations 渐变色分割点数组
/// @param size 渐变大小
- (void)mm_setHightLightGradientsWith:(NSArray<UIColor *> *)colors
                            locations:(NSArray *)locations
                                 size:(CGSize)size;


/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
- (void)mm_setBackgroundGradientsWith:(UIColor *)startColor
                             endColor:(UIColor *)endColor;

/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
/// @param size 渐变大小
- (void)mm_setBackgroundGradientsWith:(UIColor *)startColor
                             endColor:(UIColor *)endColor size:(CGSize)size;

/// 高亮背景渐变设置
/// @param colors 渐变色数组
/// @param locations 渐变色分割点数组
/// @param size 渐变大小
- (void)mm_setBackgroundGradientsWith:(NSArray<UIColor *> *)colors
                            locations:(NSArray *)locations
                                 size:(CGSize)size;
@end

#pragma mark --- 自定义按钮
typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop, // image在上，label在下
    ButtonEdgeInsetsStyleLeft, // image在左，label在右
    ButtonEdgeInsetsStyleBottom, // image在下，label在上
    ButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (UI)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)mm_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

// 水平居中的img和title之间的间距
- (void)mm_verticalCenterImageAndTitleWithSpacing:(float)spacing;
@end

NS_ASSUME_NONNULL_END
