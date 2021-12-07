//
//  UILabel+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/15.
//

#import "UILabel+Method.h"
#import "NSString+Common.h"
#import "UIView+Frame.h"

@implementation UILabel (Method)

+ (UILabel *)mm_createLabel:(UIColor *)color
                   fontSize:(CGFloat)fontSize
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = alignment;
    label.text = text;
    label.textColor = color;
    return label;
}

+ (UILabel *)mm_createLabel:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text{
    return [self mm_createLabel:color fontSize:16 textAlignment:alignment text:text];
}

- (void)mm_text:(NSString *)text
           font:(UIFont *)font
      textColor:(UIColor *)textColor
{
    self.text = text;
    self.font = font;
    self.textColor = textColor;
}

/// 设置粗体
- (void)mm_setBoldFontSize:(CGFloat)fontSize{
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

/// 粗体加斜体
- (void)mm_setBoldObliqueFontSize:(CGFloat)fontSize{
    self.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
}

- (void)mm_adaptiveHeight:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor
{
    self.text = text;
    self.font = [UIFont systemFontOfSize:font];
    self.textColor = textColor;
    self.numberOfLines = 0;
    self.height = [text mm_sizeWithFont:font maxWidth:self.width].height;
}

- (void)mm_adaptiveWidth:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor
{
    self.text = text;
    self.font = [UIFont systemFontOfSize:font];
    self.textColor = textColor;
    self.width = [text mm_sizeWithFont:font maxWidth:self.height].width;
}

- (void)mm_adaptiveHeight
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.numberOfLines = 0;
    self.height = rect.size.height;
}

- (void)mm_adaptiveWidth
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(0, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.width = rect.size.width;
}
@end

