//
//  UIFont+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/19.
//

#import "UIFont+Method.h"
#import <objc/runtime.h>

@implementation UIFont (Method)
/**
 设置平方字体 -- PingFangSC-Regular
 @param size 字体大小
 @param layout 是否适配屏幕 plus 会加大1个字号
 @return UIFont
 */
+ (UIFont *)m_regularPFFontWith:(CGFloat)size layout:(BOOL)layout
{
    CGFloat sizeLayout = [self getLayoutSizeWithLayout:layout];
    if (@available(iOS 9.0, *)) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size+sizeLayout];
        return font;
    }
    return [UIFont systemFontOfSize:(size + sizeLayout)];
}

/**
 设置平方字体 -- PingFangSC-Medium
 @param layout 是否适配屏幕 plus为YES则会加大1个字号
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_mediumPFFontWith:(CGFloat)size layout:(BOOL)layout
{
    CGFloat sizeLayout = [self getLayoutSizeWithLayout:layout];
    if (@available(iOS 9.0, *)) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size+sizeLayout];
        return font;
    }
    return mBoldSystemFont(size + sizeLayout);
}

/**
 设置系统默认粗体 -- boldSystemFont
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_systemBoldFontWith:(CGFloat)size layout:(BOOL)layout
{
    CGFloat offset = [self getLayoutSizeWithLayout:layout];
    return mBoldSystemFont(size+offset);
}

/**
 设置平方字体 -- PingFangSC-Semibold    非常粗的字体
 @param layout 是否适配屏幕 plus为YES则会加大1个字号
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_boldBoldPFFontWith:(CGFloat)size layout:(BOOL)layout
{
    CGFloat sizeLayout = [self getLayoutSizeWithLayout:layout];
    if (@available(iOS 9.0, *)) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size+sizeLayout];
        return font;
    }
    return mBoldSystemFont(size + sizeLayout);
}

// 这种适配有时候不行，可以采取 size * ([UIScreen mainScreen] bounds].size.width / 375.0)
+(CGFloat)getLayoutSizeWithLayout:(BOOL)layout
{
    if (([[UIScreen mainScreen] bounds].size.width / 375.0) > 1) {
        return 1;
    }else if (([[UIScreen mainScreen] bounds].size.width / 375.0) < 1) {
        return -1;
    }
    return 0;
}

@end

@implementation UIView (MFontExtension)
-(void)setOrginalFontSize:(CGFloat)orginalFontSize {
    objc_setAssociatedObject(self, @selector(orginalFontSize), @(orginalFontSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CGFloat)orginalFontSize {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
@end

@implementation UILabel (MFontExtension)

+(void)setFontWithType:(MFontType)type layout:(BOOL)layout forView:(UIView *)view
{
    if(![view respondsToSelector:@selector(setFont:)] && ![view respondsToSelector:@selector(font)]) return;
    CGFloat fontSize = view.orginalFontSize;  // 记录原生xib的文字大小设置，手动设置大小不走这里
    if (fontSize == 0) {
        fontSize = [(UILabel *)view font].pointSize;
        view.orginalFontSize = fontSize;
    }
    UIFont *font = nil;
    switch (type) {
        case MFontPingFang:
            font = [UIFont m_regularPFFontWith:fontSize layout:layout];
            break;
        case MFontPingFangBold:
            font = [UIFont m_mediumPFFontWith:fontSize layout:layout];
            break;
        case MFontPingFangBoldBold:
            font = [UIFont m_systemBoldFontWith:fontSize layout:layout];
            break;
        default:
            break;
    }
    if(font) [(UILabel *)view setFont:font];
}

-(void)setFontType_m:(NSUInteger)fontType_m
{
    objc_setAssociatedObject(self, @selector(fontType_m), @(fontType_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:fontType_m layout:self.fontLayout_m forView:self];
}

-(NSUInteger)fontType_m
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

-(void)setFontLayout_m:(BOOL)fontLayout_m
{
    objc_setAssociatedObject(self, @selector(fontLayout_m), @(fontLayout_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:self.fontType_m layout:fontLayout_m forView:self];
}

-(BOOL)fontLayout_m
{
    id val = objc_getAssociatedObject(self, _cmd);
    if(!val) return YES;
    return [val boolValue];
}

@end

@implementation UITextField (MFontExtension)

-(void)setFontType_m:(NSUInteger)fontType_m
{
    objc_setAssociatedObject(self, @selector(fontType_m), @(fontType_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:fontType_m layout:self.fontLayout_m forView:self];
}
-(NSUInteger)fontType_m
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

-(void)setFontLayout_m:(BOOL)fontLayout_m
{
    objc_setAssociatedObject(self, @selector(fontLayout_m), @(fontLayout_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:self.fontType_m layout:fontLayout_m forView:self];
}

-(BOOL)fontLayout_m
{
    id val = objc_getAssociatedObject(self, _cmd);
    if(!val) return YES;
    return [val boolValue];
}

@end

@implementation UITextView (MFontExtension)

-(void)setFontType_m:(NSUInteger)fontType_m
{
    objc_setAssociatedObject(self, @selector(fontType_m), @(fontType_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:fontType_m layout:self.fontLayout_m forView:self];
}

-(NSUInteger)fontType_m
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

-(void)setFontLayout_m:(BOOL)fontLayout_m
{
    objc_setAssociatedObject(self, @selector(fontLayout_m), @(fontLayout_m), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [UILabel setFontWithType:self.fontType_m layout:fontLayout_m forView:self];
}

-(BOOL)fontLayout_m
{
    id val = objc_getAssociatedObject(self, _cmd);
    if(!val) return YES;
    return [val boolValue];
}

@end

@implementation UIButton (MFontExtension)

-(void)setFontType_m:(NSUInteger)fontType_m
{
    [self.titleLabel setFontType_m:fontType_m];
}

-(NSUInteger)fontType_m
{
    return [self.titleLabel fontType_m];
}

-(void)setFontLayout_m:(BOOL)fontLayout_m
{
    [self.titleLabel setFontLayout_m:fontLayout_m];
}

-(BOOL)fontLayout_m
{
    return [self.titleLabel fontLayout_m];
}

@end
