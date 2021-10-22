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
/**
 创建一个按钮
 @param title 文字
 @param color 文字颜色
 @param font  字体大小
 @param block  事件
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
 @param block  事件
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

#pragma mark -- 另一个自定义button
typedef NS_ENUM(NSInteger, SSImagePositionType) {
    SSImagePositionTypeLeft,   //图片在左，标题在右，默认风格
    SSImagePositionTypeRight,  //图片在右，标题在左
    SSImagePositionTypeTop,    //图片在上，标题在下
    SSImagePositionTypeBottom  //图片在下，标题在上
};

typedef NS_ENUM(NSInteger, SSEdgeInsetsType) {
    SSEdgeInsetsTypeTitle,//标题
    SSEdgeInsetsTypeImage//图片
};

typedef NS_ENUM(NSInteger, SSMarginType) {
    SSMarginTypeTop         ,
    SSMarginTypeBottom      ,
    SSMarginTypeLeft        ,
    SSMarginTypeRight       ,
    SSMarginTypeTopLeft     ,
    SSMarginTypeTopRight    ,
    SSMarginTypeBottomLeft  ,
    SSMarginTypeBottomRight
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
- (void)setImagePositionWithType:(SSImagePositionType)type spacing:(CGFloat)spacing;

/**
 *  按钮只设置了title or image，该方法可以改变它们的位置
 *
 *  @param edgeInsetsType <#edgeInsetsType description#>
 *  @param marginType     <#marginType description#>
 *  @param margin         <#margin description#>
 */
- (void)setEdgeInsetsWithType:(SSEdgeInsetsType)edgeInsetsType marginType:(SSMarginType)marginType margin:(CGFloat)margin;



/**
 *  图片在上，标题在下
 *
 *  @param spacing image 和 title 之间的间隙
 */
- (void)setImageUpTitleDownWithSpacing:(CGFloat)spacing __deprecated_msg("Method deprecated. Use `setImagePositionWithType:spacing:`");

/**
 *  图片在右，标题在左
 *
 *  @param spacing image 和 title 之间的间隙
 */
- (void)setImageRightTitleLeftWithSpacing:(CGFloat)spacing __deprecated_msg("Method deprecated. Use `setImagePositionWithType:spacing:`");

@end


NS_ASSUME_NONNULL_END
