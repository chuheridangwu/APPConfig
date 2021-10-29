//
//  UITableView+Extension.h
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extension)

/**
 注册一个cell xib/class文件
 
 @param cellClass class of collection cell
 */
- (void)mm_registerCellClass:(Class)cellClass;
- (void)mm_registerCellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier;

// 获取一个cell
- (__kindof UITableViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass;
- (__kindof UITableViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass
                                                       forIndexPath:(NSIndexPath *)indexPath;

/**
 注册一个段头/尾类， 可以使Class ，也可以 NIB 文件
 
 @param sectionHeaderClass 段头类
 @param reuseIdentifier 复用id
 */
- (void)mm_registerSectionHeaderFooterClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier;
- (void)mm_registerSectionHeaderFooterClass:(Class)sectionHeaderClass;

// 获取一个段头/尾
- (__kindof UITableViewHeaderFooterView *)mm_dequeueReusableSectionHeaderFooterWithClass:(Class)headerClass;
- (__kindof UITableViewHeaderFooterView *)mm_dequeueReusableSectionHeaderFooterWithIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
