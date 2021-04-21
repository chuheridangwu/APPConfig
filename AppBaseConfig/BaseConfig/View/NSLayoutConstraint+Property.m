//
//  NSLayoutConstraint+Property.m
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#import "NSLayoutConstraint+Property.h"
#import <objc/runtime.h>
#import "MacroHeader.h"


@implementation NSLayoutConstraint (Property)

/** 自动适配屏幕 默认 NO  以宽度比例缩放 */
-(void)setWidthAutoFitScreen:(BOOL)widthAutoFitScreen
{
    objc_setAssociatedObject(self, @selector(widthAutoFitScreen), @(widthAutoFitScreen), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (widthAutoFitScreen) {
        self.constant = mmLayout_Width_Ratio(self.constant);
    } else {
        self.constant = self.constant;
    }
}

-(BOOL)widthAutoFitScreen
{
    return [objc_getAssociatedObject(self, @selector(widthAutoFitScreen)) boolValue];
}

/** 高度 自动适配屏幕 默认 NO  以高度比例缩放 */
-(void)setHeightAutoFitScreen:(BOOL)heightAutoFitScreen
{
    objc_setAssociatedObject(self, @selector(heightAutoFitScreen), @(heightAutoFitScreen), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (heightAutoFitScreen) {
        self.constant = mmLayout_Height_Ratio(self.constant);
    } else {
        self.constant = self.constant;
    }
}

-(BOOL)heightAutoFitScreen
{
    return [objc_getAssociatedObject(self, @selector(heightAutoFitScreen)) boolValue];
}

/** 1像素 默认 NO */
-(void)setOnePixelLineScreen:(BOOL)onePixelLineScreen
{
    objc_setAssociatedObject(self, @selector(onePixelLineScreen), @(onePixelLineScreen), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (onePixelLineScreen) {
        self.constant = 1/[UIScreen mainScreen].scale;
    } else {
        self.constant = self.constant;
    }
}

-(BOOL)onePixelLineScreen
{
    return [objc_getAssociatedObject(self, @selector(onePixelLineScreen)) boolValue];
}

@end
