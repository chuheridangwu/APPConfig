//
//  MacroHeader.h
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#ifndef MacroHeader_h
#define MacroHeader_h

#ifdef __OBJC__

// 第三方
#import "YYModel.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import <SDWebImage.h>
#import <IQKeyboardManager.h>
#import <AFNetworkReachabilityManager.h>
#import <AFHTTPSessionManager.h>
#import "UINavigationController+FDFullscreenPopGesture.h"  // 侧滑

// 分类
#import "UITableView+Extension.h"
#import "UICollectionView+MExtension.h"
#import "UIImageView+Method.h"
#import "UIImage+Method.h"
#import "UIButton+Method.h"
#import "UILabel+Method.h"
#import "UIDevice+Method.h"
#import "UIView+Frame.h"
#import "UIFont+Method.h"
#import "UIBarButtonItem+Method.h"

#import "NSData+Encryption.h"
#import "NSDate+Method.h"
#import "NSBundle+Language.h"
#import "NSObject+Method.h"
#import "NSDictionary+Method.h"
#import "NSArray+Method.h"
#import "NSMutableString+Method.h"
#import "NSString+Common.h"

// 权限相关的工具类
#import "ContactsTool.h"
#import "CameraPhotoTool.h"

// 自定义View
#import "MLongTitleLabel.h"
#import "MLoadingView.h"
#import "AppPreviewView.h"


//屏幕bounds
#define Screen_Bounds   [[UIScreen mainScreen] bounds]
//屏幕size
#define Screen_Size     [[UIScreen mainScreen] bounds].size
//屏幕高度
#define Screen_Height   [[UIScreen mainScreen] bounds].size.height
//屏幕宽度
#define Screen_Width    [[UIScreen mainScreen] bounds].size.width
//屏幕比例
#define ScreenWidthScale (Screen_Width/375.f)

//状态栏高度
#define mm_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//齐刘海
#define mm_Is_Iphone_Xm  (mm_StatusBarHeight>20)
//底部高度
#define mm_BottomMargin   ((mm_StatusBarHeight>20) ? 34 : 0)

//屏幕适配 根据屏幕宽375   高667 来做适配的
#define mm_Width_Fix(x)          (roundf((x)*ScreenWidthScale))
#define mm_Height_Fix(x)         (roundf((x)*Screen_Height/667.0f))

//获取图片资源
#define mm_GetImage(imageName)    [UIImage imageNamed:imageName]

// 设置弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 设置打印信息
#ifdef DEBUG
# define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define NSLog(...);
#endif



//获取沙盒目录
#define mm_PathTemp NSTemporaryDirectory()    //temp
#define mm_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] //Document
#define mm_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]  //Cache


//16进制颜色
#define mm_ColorFromHex(s)    mm_ColorFromAHex(s,1.0)
#define mm_ColorFromAHex(s,a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0 alpha:a]
//随机颜色
#define mm_RandomColor        [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//RGB颜色
#define mm_RGBColor(r, g, b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define mm_RGBAColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//布局
#define mm_size(w, h)              CGSizeMake(mm_Width_Fix(w), mm_Height_Fix(h))

#define mas_t(size)             make.top.mas_equalTo(mm_Height_Fix(size))
#define mas_b(size)             make.bottom.mas_equalTo(mm_Height_Fix(size))
#define mas_l(size)             make.left.mas_equalTo(mm_Width_Fix(size))
#define mas_r(size)             make.right.mas_equalTo(mm_Width_Fix(size))
#define mas_w(size)             make.width.mas_equalTo(mm_Width_Fix(size))
#define mas_h(size)             make.height.mas_equalTo(mm_Height_Fix(size))
#define mas_s(w,h)              make.size.mas_equalTo(mm_size(w,h))
#define mas_v(value)            (void)make.value

#endif /* __OBJC__ */

#endif /* MacroHeader_h */


/**
 
 // 宏定义 只显示打印信息，不显示日期
 #ifdef DEBUG
 #define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
 #else
 #define NSLog(...)
 #endif
 
 
 
 
 */
