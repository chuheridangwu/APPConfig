//
//  UIButton+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import "UIButton+Method.h"
#import "UIView+Frame.h"
#import "UIImage+Method.h"

@implementation UIButton (Method)

+ (UIButton *)mm_createButton:(CGFloat)fontSize title:(NSString*)title textColor:(UIColor *)textColor target:(nullable id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (instancetype)mm_createBtnWithTitle:(NSString *)title
                            color:(UIColor *)color
                             font:(CGFloat)font
                            block:(void(^)(QMUIButton *sender))block {
    
    QMUIButton *view = [QMUIButton new];
    view.titleLabel.font = [UIFont systemFontOfSize:font];
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:color forState:UIControlStateNormal];

    if (block) {
        
        [view setQmui_tapBlock:^(__kindof UIControl *sender) {
            !block ?: block(sender);
        }];
    }
    
    return view;
}

/// 高亮颜色设置
/// @param color 颜色
- (void)mm_setHightLightWithColor:(UIColor *)color {
    [self setBackgroundImage:[UIImage mm_imageWithColor:color] forState:UIControlStateHighlighted];
}


/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
- (void)mm_setHightLightGradientsWith:(UIColor *)startColor endColor:(UIColor *)endColor {
    [self mSetGradientsWith:@[startColor, endColor] locations:nil size:self.size buttonState:UIControlStateHighlighted];
}

/// 高亮背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
/// @param size 渐变大小
- (void)mm_setHightLightGradientsWith:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size {
    [self mSetGradientsWith:@[startColor, endColor] locations:nil size:size buttonState:UIControlStateHighlighted];
}

/// 高亮背景渐变设置
/// @param colors 渐变色数组
/// @param locations 渐变色分割点数组
/// @param size 渐变大小
- (void)mm_setHightLightGradientsWith:(NSArray<UIColor *> *)colors locations:(NSArray *)locations size:(CGSize)size {
    [self mSetGradientsWith:colors locations:locations size:size buttonState:UIControlStateHighlighted];
}

/// 背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
- (void)mm_setBackgroundGradientsWith:(UIColor *)startColor endColor:(UIColor *)endColor {
    [self mSetGradientsWith:@[startColor, endColor] locations:nil size:self.size buttonState:UIControlStateNormal];
}

/// 背景渐变设置
/// @param startColor 开始颜色
/// @param endColor 结尾颜色
/// @param size 渐变大小
- (void)mm_setBackgroundGradientsWith:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size {
    [self mSetGradientsWith:@[startColor, endColor] locations:nil size:size buttonState:UIControlStateNormal];
}

/// 背景渐变设置
/// @param colors 渐变色数组
/// @param locations 渐变色分割点数组
/// @param size 渐变大小
- (void)mm_setBackgroundGradientsWith:(NSArray<UIColor *> *)colors locations:(NSArray *)locations size:(CGSize)size {
    [self mSetGradientsWith:colors locations:locations size:size buttonState:UIControlStateNormal];
}

- (void)mSetGradientsWith:(NSArray<UIColor *> *)colors locations:(NSArray *)locations size:(CGSize)size buttonState:(UIControlState)state {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *colorMarr = @[].mutableCopy;
    for (UIColor *color in colors) {
        [colorMarr addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = colorMarr;
    if (locations) {
        gradientLayer.locations = locations;
    }else {
        gradientLayer.locations = @[@0,@1.0];
    }
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [self setBackgroundImage:[UIImage imageFromLayer:gradientLayer] forState:state];
}
@end

#pragma mark -- 自定义button

@implementation UIButton(UI)

- (void)mm_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case ButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)mm_verticalCenterImageAndTitleWithSpacing:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
}

@end
