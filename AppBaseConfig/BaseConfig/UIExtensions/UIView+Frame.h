//
//  UIView+Frame.h
//  CategoryProject
//
//  Created by mlive on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

/** IBInspectable xib中设置圆角 设置圆角大小 */
@property (nonatomic) IBInspectable CGFloat cornerRadius_m;

/** IBInspectable xib中设置圆角 设置视图圆角，优先于 cornerRadius_m */
@property (nonatomic) IBInspectable BOOL cycleCorner_m;
@end

#pragma mark -- UIView 扩展方法
@interface UIView (Method)
/// 初始化
+ (instancetype)mm_instance;

/// 切圆角
- (void)mm_cutRounded:(CGFloat)size;

/// 切某个角
-(void)mm_cutRoundOnCorner:(UIRectCorner)rectCorner radius:(float)radius;

/**
 * 添加渐变色
 * axis 渐变方向
 * startColor  初始颜色
 * endColor 结束颜色
 */
- (void)mm_gradientLayer:(UILayoutConstraintAxis)axis startColor:(UIColor*)startColor endColor:(UIColor*)endColor;


/// 添加阴影
/// @param radius 圆角
/// @param color 颜色
/// @param opacity 透明度
/// @param offset 偏移
/// @param shadowRadius 宽度
- (void)mm_shadowView:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius;


/// 添加蚂蚁线
- (void)mm_drawDottedLine:(CGFloat)height width:(CGFloat)width color:(UIColor *)color;


/// 添加呼吸灯，默认重复
/// @param fromValue  开启时的透明度（0-1）
/// @param toValue  到什么程度为止（0-1）
/// @param duration  时间
- (void)mm_breathLeamView:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(double)duration;

/// 移除所有子视图
- (void)mm_removeAllSubviews;

/// 添加点击手势
- (void)mm_addTapGesture:(id)target selector:(SEL)selector;

/// 线性动画，从下到上
- (void)mm_animationDuration:(CFTimeInterval)duration;
@end

#pragma mark -- UIView 创建控件
@interface UIView (UI)
+ (UILabel *)mm_createLabel:(CGRect)frame
                   fontSize:(CGFloat)fontSize
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text;
///创建二维码
///@param size  生成图片的宽度
///@param dataString  二维码内容
///@param iconImage  中心图标
- (UIImage *)mm_createQRCode:(NSString *)dataString
                               withSize:(CGFloat) size
                              iconImage:(UIImage *)iconImage;

/** 生成条形码*/
- (UIImage *)mm_createBarCode:(NSString *)inputMessage
                                       width:(CGFloat)width
                                      height:(CGFloat)height;
@end

#pragma mark --- 添加手势
@interface UIView (GestureRecognizer)
- (void)mm_addTapGesture:(id)target sel:(SEL)selector;
- (void)mm_addPanGesture:(id)target sel:(SEL)selector;
- (void)mm_addTapGesture:(id)target selector:(SEL)selector;
- (void)mm_addLongPressGesture:(id)target sel:(SEL)selector;
@end

NS_ASSUME_NONNULL_END
