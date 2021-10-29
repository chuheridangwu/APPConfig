//
//  NSBundle+Language.m
//  CategoryProject
//
//  Created by mlive on 2021/4/19.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

NSString* LocalizationString(NSString *key){
    //文件名 = 语言代码 + .lproj
    NSArray  *languages = [NSLocale preferredLanguages];
    NSString *language = [languages objectAtIndex:0]; //系统默认语言
//    if ([language containsString:@"th"]) {
//        language = @"th";
//    }else if ([language containsString:@"zh"]){
//        language = @"zh-Hans";
//    }else if ([language containsString:@"vi"]) {
//        language = @"vi";
//    }else{
//        language = @"vi";
//    }
    language = @"ja";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    //获取对应语言的字符串
    // testText 文本的key
    // localizedStrings 是.strings文件的文件名
    NSString *realString = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"LaunchScreen"];
    return realString;
}

#pragma mark -- NSBundle的子类，重写 localizedStringForKey 方法
@interface MMLanguageBundle : NSBundle
@end
@implementation MMLanguageBundle
/// 国际化
- (NSString*)localizedStringForKey:(NSString*)key value:(NSString*)value table:(NSString*)tableName{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:NSBundle.currentLanguage ofType:@"lproj"]];
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }else{
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

#pragma mark --- NSBundle 分类

@implementation NSBundle (Language)

+ (NSString*)customStringsName
{
    return objc_getAssociatedObject(self, @selector(customStringsName));
}

+ (void)setCustomStringsName:(NSString*)customStringsName
{
    objc_setAssociatedObject(self, @selector(customStringsName), customStringsName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static NSString *kAppLanguageKey = @"KJ_CURRENT_LANGUAGE_KEY";
+ (NSString*)currentLanguage
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kAppLanguageKey];
    if (language == nil) {
        language = [[NSLocale preferredLanguages] firstObject];
    }
    return language;
}

/// 设置语言
+ (void)mm_currentLanguage:(NSString*)language complete:(void(^)(void))complete
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (language) {
        [userDefaults setObject:language forKey:kAppLanguageKey];
    }else{
        [userDefaults removeObjectForKey:kAppLanguageKey];
    }
    [userDefaults synchronize];
    if (complete) complete();
}
@end

#pragma mark -- UILabel 分类
@implementation UILabel (Language)
- (NSString*)LocalizedKey
{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}

- (void)setLocalizedKey:(NSString*)LocalizedKey
{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    self.text = XLa(LocalizedKey);
}

@end

#pragma mark -- UITextField
@implementation UITextField (Language)
- (NSString*)LocalizedKey{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}
- (void)setLocalizedKey:(NSString*)LocalizedKey{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    if (NSBundle.customStringsName) {
        self.placeholder = XLa(LocalizedKey);
    }else{
        self.placeholder = XLa(LocalizedKey);
    }
}

@end

#pragma mark -- UIButton
@implementation UIButton (Language)
- (NSString*)LocalizedKey{
    return objc_getAssociatedObject(self, @selector(LocalizedKey));;
}
- (void)setLocalizedKey:(NSString*)LocalizedKey{
    objc_setAssociatedObject(self, @selector(LocalizedKey), LocalizedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (LocalizedKey == nil) return;
    if (NSBundle.customStringsName) {
        [self setTitle:XLa(LocalizedKey) forState:UIControlStateNormal];
    }else{
        [self setTitle:XLa(LocalizedKey) forState:UIControlStateNormal];
    }
}
- (NSString*)HighlightedKey{
    return objc_getAssociatedObject(self, @selector(HighlightedKey));;
}
- (void)setHighlightedKey:(NSString*)HighlightedKey{
    objc_setAssociatedObject(self, @selector(HighlightedKey), HighlightedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (HighlightedKey == nil) return;
    if (NSBundle.customStringsName) {
        [self setTitle:XLa(HighlightedKey) forState:UIControlStateHighlighted];
    }else{
        [self setTitle:XLa(HighlightedKey) forState:UIControlStateHighlighted];
    }
}
- (NSString*)SelectedKey{
    return objc_getAssociatedObject(self, @selector(SelectedKey));;
}
- (void)setSelectedKey:(NSString*)SelectedKey{
    objc_setAssociatedObject(self, @selector(SelectedKey), SelectedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (SelectedKey == nil) return;
    if (NSBundle.customStringsName) {
        [self setTitle:XLa(SelectedKey) forState:UIControlStateSelected];
    }else{
        [self setTitle:XLa(SelectedKey) forState:UIControlStateSelected];
    }
}
- (NSString*)DisabledKey{
    return objc_getAssociatedObject(self, @selector(DisabledKey));;
}
- (void)setDisabledKey:(NSString*)DisabledKey{
    objc_setAssociatedObject(self, @selector(DisabledKey), DisabledKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (DisabledKey == nil) return;
    if (NSBundle.customStringsName) {
        [self setTitle:XLa(DisabledKey) forState:UIControlStateDisabled];
    }else{
        [self setTitle:XLa(DisabledKey) forState:UIControlStateDisabled];
    }
}
@end
