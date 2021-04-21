//
//  UIBarButtonItem+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Method)

+(UIBarButtonItem *)mm_itemWithView:(UIView *)view;

/**
 根据图片生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param image image
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image;
/**
 根据图片生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param image image
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

/**
 根据图片生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param nomalImage nomalImage
 @param higeLightedImage higeLightedImage
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target
                            action:(SEL)action
                        nomalImage:(UIImage *)nomalImage
                  higeLightedImage:(nullable UIImage *)higeLightedImage
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;


/**
 根据文字生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param title title
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

/**
 根据文字生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param title title
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

/**
 根据文字生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param title title
 @param font font
 @param titleColor 字体颜色
 @param highlightedColor 高亮颜色
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_itemWithTarget:(id)target
                            action:(SEL)action
                             title:(nullable NSString *)title
                              font:(nullable UIFont *)font
                        titleColor:(nullable UIColor *)titleColor
                  highlightedColor:(nullable UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;


/**
 用作修正位置的UIBarButtonItem

 @param width 修正宽度
 @return 修正位置的UIBarButtonItem
 */
+(UIBarButtonItem *)mm_fixedSpaceWithWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
