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
                            block:(void(^)(UIButton *sender))block {
    
    UIButton *view = [UIButton new];
    view.titleLabel.font = [UIFont systemFontOfSize:font];
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:color forState:UIControlStateNormal];

    if (block) {
        
        [view  mm_setTapBlock:^(UIButton * _Nonnull sender) {
            !block ?: block(sender);
        }];
        
    }
    
    return view;
}

+ (UIButton *)mm_createButton:(CGFloat)fontSize
                        title:(NSString *)title
                        normalColor:(UIColor *)normalColor
                     selColor:(UIColor *)selColor
                  normalImage:(UIImage*)normalImage
                     selImage:(UIImage*)selImage
                        block:(void(^)(UIButton *sender))block{
    UIButton *view = [self mm_createBtnWithTitle:title color:normalColor font:fontSize block:block];
    [view setImage:normalImage forState:UIControlStateNormal];
    [view setTitleColor:selColor forState:UIControlStateSelected];
    [view setImage:selImage forState:UIControlStateSelected];
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


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SS_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define SS_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif
@implementation UIButton (Edge)

- (void)mm_setImagePositionWithType:(ButtonEdgeInsetsStyle)type spacing:(CGFloat)spacing {
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGSize titleSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    
    switch (type) {
        case ButtonEdgeInsetsStyleLeft: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
            break;
        }
        case ButtonEdgeInsetsStyleRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width + spacing);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, - titleSize.width);
            break;
        }
        case ButtonEdgeInsetsStyleTop: {
            // lower the text and push it left so it appears centered
            //  below the image
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (imageSize.height + spacing), 0);
            
            // raise the image and push it right so it appears centered
            //  above the text
            self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0, 0, - titleSize.width);
            break;
        }
        case ButtonEdgeInsetsStyleBottom: {
            self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), - imageSize.width, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, - (titleSize.height + spacing), - titleSize.width);
            break;
        }
    }
}

- (void)mm_setEdgeInsetsWithType:(ButtonMarginType)edgeInsetsType marginType:(ButtonEdgeType)marginType margin:(CGFloat)margin {
    CGSize itemSize = CGSizeZero;
    if (edgeInsetsType == ButtonEdgeTypeTitle) {
        itemSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    } else {
        itemSize = [self imageForState:UIControlStateNormal].size;
    }
    
    CGFloat horizontalDelta = (CGRectGetWidth(self.frame) - itemSize.width) / 2.f - margin;
    CGFloat vertivalDelta = (CGRectGetHeight(self.frame) - itemSize.height) / 2.f - margin;
    
    NSInteger horizontalSignFlag = 1;
    NSInteger verticalSignFlag = 1;
    
    switch (marginType) {
        case ButtonMarginTypeTop: {
            horizontalSignFlag = 0;
            verticalSignFlag = - 1;
            break;
        }
        case ButtonMarginTypeBottom: {
            horizontalSignFlag = 0;
            verticalSignFlag = 1;
            break;
        }
        case ButtonMarginTypeLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 0;
            break;
        }
        case ButtonMarginTypeRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 0;
            break;
        }
        case ButtonMarginTypeTopLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = - 1;
            break;
        }
        case ButtonMarginTypeTopRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = - 1;
            break;
        }
        case ButtonMarginTypeBottomLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 1;
            break;
        }
        case ButtonMarginTypeBottomRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 1;
            break;
        }
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vertivalDelta * verticalSignFlag, horizontalDelta * horizontalSignFlag, - vertivalDelta * verticalSignFlag, - horizontalDelta * horizontalSignFlag);
    if (edgeInsetsType == ButtonEdgeTypeTitle) {
        self.titleEdgeInsets = edgeInsets;
    } else {
        self.imageEdgeInsets = edgeInsets;
    }
}
@end


#pragma mark --- UIButton 添加Block回调
static void *UIButtonBlockKey =  &UIButtonBlockKey;

@implementation UIButton(UIButtonBlock)

- (UIButtonBlock)buttonBlock{
    return objc_getAssociatedObject(self, &UIButtonBlockKey);
}

- (void)setButtonBlock:(UIButtonBlock)buttonBlock{
    objc_setAssociatedObject(self, &UIButtonBlockKey, buttonBlock, OBJC_ASSOCIATION_COPY);
}

- (void)mm_setTapBlock:(UIButtonBlock)block{
    self.buttonBlock = block;
    [self addTarget:self action:@selector(mm_clickButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mm_clickButtonBlock:(UIButton*)btn{
    if (self.buttonBlock) {
        self.buttonBlock(btn);
    }
}
@end
