//
//  UIButton+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

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
/**
 创建一个按钮
 @param title 文字
 @param color 文字颜色
 @param font  字体大小
 @param block  事件，注意循环引用问题
 @return 一个按钮
 */
+ (instancetype)mm_createBtnWithTitle:(NSString *)title
                            color:(UIColor *)color
                             font:(CGFloat)font
                                block:(void(^)(UIButton *sender))block;

/**
 创建一个按钮
 @param title 文字
 @param normalColor 文字颜色
 @param fontSize  字体大小
 @param block  事件 ，注意循环引用问题
 @return 一个按钮
 */
+ (UIButton *)mm_createButton:(CGFloat)fontSize
                        title:(NSString *)title
                        normalColor:(UIColor *)normalColor
                     selColor:(UIColor *)selColor
                  normalImage:(UIImage*)normalImage
                     selImage:(UIImage*)selImage
                        block:(void(^)(UIButton *sender))block;
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


#pragma mark -- 按钮文字间距

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleLeft, // image在左，label在右
    ButtonEdgeInsetsStyleRight, // image在右，label在左
    ButtonEdgeInsetsStyleTop, // image在上，label在下
    ButtonEdgeInsetsStyleBottom, // image在下，label在上
};

typedef NS_ENUM(NSInteger, ButtonEdgeType) {
    ButtonEdgeTypeTitle,//标题
    ButtonEdgeTypeImage//图片
};

typedef NS_ENUM(NSInteger, ButtonMarginType) {
    ButtonMarginTypeTop         ,
    ButtonMarginTypeBottom      ,
    ButtonMarginTypeLeft        ,
    ButtonMarginTypeRight       ,
    ButtonMarginTypeTopLeft     ,
    ButtonMarginTypeTopRight    ,
    ButtonMarginTypeBottomLeft  ,
    ButtonMarginTypeBottomRight
};

/**
 默认情况下，imageEdgeInsets和titleEdgeInsets都是0。先不考虑height,
 
 if (button.width小于imageView上image的width){图像会被压缩，文字不显示}
 
 if (button.width < imageView.width + label.width){图像正常显示，文字显示不全}
 
 if (button.width >＝ imageView.width + label.width){图像和文字都居中显示，imageView在左，label在右，中间没有空隙}
 */

@interface UIButton (Edge)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现图片和标题的自由排布
 *  注意：1.该方法需在设置图片和标题之后才调用;
 2.图片和标题改变后需再次调用以重新计算titleEdgeInsets和imageEdgeInsets
 *
 *  @param type    图片位置类型
 *  @param spacing 图片和标题之间的间隙
 */
- (void)mm_setImagePositionWithType:(ButtonEdgeInsetsStyle)type spacing:(CGFloat)spacing;

/**
 *  按钮只设置了title or image，该方法可以改变它们的位置
 *  @param edgeInsetsType  方向
 *  @param marginType     图片还是文字
 *  @param margin       间距
 */
- (void)mm_setEdgeInsetsWithType:(ButtonMarginType)edgeInsetsType marginType:(ButtonEdgeType)marginType margin:(CGFloat)margin;

@end


#pragma mark --- UIButton 添加Block回调

typedef void(^UIButtonBlock)(UIButton *sender);
@interface UIButton (UIButtonBlock)

@property (nonatomic,copy)UIButtonBlock buttonBlock;

- (void)mm_setTapBlock:(UIButtonBlock)block;

@end

NS_ASSUME_NONNULL_END
