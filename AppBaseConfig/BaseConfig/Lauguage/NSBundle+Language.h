//
//  NSBundle+Language.h
//  CategoryProject
//
//  Created by mlive on 2021/4/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define XLa(key) LocalizationString(key)
NSString* LocalizationString(NSString *key);

@interface NSBundle (Language)

/// 自定义strings文件，默认Localizable.strings
@property(nonatomic,strong,class)NSString *customStringsName;

/// 当前语言
@property(nonatomic,strong,readonly,class)NSString *currentLanguage;

/// 设置语言
+ (void)mm_currentLanguage:(NSString*)language complete:(void(^)(void))complete;
@end

#pragma mark -- UILabel 
IB_DESIGNABLE
@interface UILabel (Language)
@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;
@end

#pragma mark -- UITextField
IB_DESIGNABLE
@interface UITextField (Language)
@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;
@end

#pragma mark -- UIButton
IB_DESIGNABLE
@interface UIButton (Language)
@property(nonatomic,strong)IBInspectable NSString *LocalizedKey;
@property(nonatomic,strong)IBInspectable NSString *SelectedKey;
@property(nonatomic,strong)IBInspectable NSString *DisabledKey;
@property(nonatomic,strong)IBInspectable NSString *HighlightedKey;
@end
NS_ASSUME_NONNULL_END
