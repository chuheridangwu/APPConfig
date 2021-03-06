//
//  UIBarButtonItem+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#import "UIBarButtonItem+Method.h"

@implementation UIBarButtonItem (Method)

+(UIBarButtonItem *)mm_itemWithView:(UIView *)view
{
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image
{
    return [self mm_itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:UIEdgeInsetsZero];
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    return [self mm_itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:imageEdgeInsets];
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target
                            action:(SEL)action
                        nomalImage:(UIImage *)nomalImage
                  higeLightedImage:(UIImage *)higeLightedImage
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < 44) {
        CGFloat width = 44.0 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 44);
    }
    if (button.bounds.size.height > 44) {
        CGFloat height = 44.0 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 44, height);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    return [self mm_itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    return [self mm_itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:titleEdgeInsets];
}

+(UIBarButtonItem *)mm_itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font?font:nil;
    [button setTitleColor:titleColor?titleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor?highlightedColor:nil forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    if (button.bounds.size.width < 44) {
        CGFloat width = 44.0 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 44);
    }
    if (button.bounds.size.height > 44) {
        CGFloat height = 44.0 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 44, height);
    }
    button.titleEdgeInsets = titleEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)mm_fixedSpaceWithWidth:(CGFloat)width
{
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}
@end
