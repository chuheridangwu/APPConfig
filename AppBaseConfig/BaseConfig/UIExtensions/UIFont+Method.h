//
//  UIFont+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/19.
//  字体适配

#import <UIKit/UIKit.h>

// 正常使用  1 - Regular
#define mPingFangFont(size)     [UIFont m_regularPFFontWith:size layout:NO]
#define mLayoutPFFont(size)     [UIFont m_regularPFFontWith:size layout:YES]

// 小加粗字体 2 - Medium
#define mPingFangSCFont(size)     [UIFont m_mediumPFFontWith:size layout:NO]
#define mLayoutPFSCFont(size)     [UIFont m_mediumPFFontWith:size layout:YES]

// 系统粗体字体 3
#define mBoldSystemFont(size)       [UIFont boldSystemFontOfSize:size]
#define mLayoutBoldSystemFont(size) [UIFont m_systemBoldFontWith:size layout:YES]

// semi-Semibold 更粗的字体
#define mBoldBoldPFFont(size)       [UIFont m_boldBoldPFFontWith:size layout:NO]
#define mLayoutBoldBoldPFFont(size) [UIFont m_boldBoldPFFontWith:size layout:YES]

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MFontType) {
    MFontSystem = 0,  // 无需设置
    MFontPingFang,            // Regular
    MFontPingFangBold,        // Medium
    MFontPingFangBoldBold,    // 系统默认粗体
};


@interface UIFont (Method)
/**
 设置平方字体 -- PingFangSC-Regular
 @param size 字体大小
 @param layout 是否适配屏幕 plus 会加大1个字号
 @return UIFont
 */
+ (UIFont *)m_regularPFFontWith:(CGFloat)size layout:(BOOL)layout;

/**
 设置平方字体 -- PingFangSC-Medium
 @param layout 是否适配屏幕 plus为YES则会加大1个字号
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_mediumPFFontWith:(CGFloat)size layout:(BOOL)layout;

/**
 设置系统默认粗体 -- boldSystemFont
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_systemBoldFontWith:(CGFloat)size layout:(BOOL)layout;

/**
 设置平方字体 -- PingFangSC-Semibold    非常粗的字体
 @param layout 是否适配屏幕 plus为YES则会加大1个字号
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)m_boldBoldPFFontWith:(CGFloat)size layout:(BOOL)layout;
@end

#pragma mark --- 对UI控件进行适配
@interface UIView (MFontExtension)
@property (nonatomic) CGFloat orginalFontSize;
@end

@interface UILabel (MFontExtension)

/** 自定义文字类型 默认 MFontPingFang MFontType */
@property(nonatomic) IBInspectable NSUInteger fontType_m;

/** 是否要适配屏幕 默认 YES */
@property (nonatomic) IBInspectable BOOL fontLayout_m;

@end

@interface UITextField (MFontExtension)

/** 自定义文字类型 默认 MFontPingFang */
@property (nonatomic) IBInspectable NSUInteger fontType_m;

/** 是否要适配屏幕 默认 YES */
@property (nonatomic) IBInspectable BOOL fontLayout_m;

@end

@interface UITextView (MFontExtension)

/** 自定义文字类型 默认 MFontPingFang */
@property (nonatomic) IBInspectable NSUInteger fontType_m;

/** 是否要适配屏幕 默认 YES */
@property (nonatomic) IBInspectable BOOL fontLayout_m;

@end

@interface UIButton (MFontExtension)

/** 自定义文字类型 默认 MFontPingFang */
@property (nonatomic) IBInspectable NSUInteger fontType_m;

/** 是否要适配屏幕 默认 YES */
@property (nonatomic) IBInspectable BOOL fontLayout_m;

@end

NS_ASSUME_NONNULL_END
