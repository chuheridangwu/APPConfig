//
//  UITableView+Extension.m
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)
/**
 是否存在 文件 为nib的文件
 
 @param cellClass 该文件
 @return 是否存在 文件 为nib的文件
 */
-(BOOL)mm_hasNibClass:(Class)cellClass
{
    NSString *cellString = NSStringFromClass(cellClass);
    if (cellString.length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:cellString ofType:@"nib"];
        return path.length != 0;
    }
    return NO;
}

/**
 注册一个cell xib/class文件
 
 @param cellClass class of collection cell
 */
- (void)mm_registerCellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier
{
    NSString *cellString = NSStringFromClass(cellClass);
    if (![self mm_hasNibClass:cellClass]) {
        return [self registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
    }
    [self registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)mm_registerCellClass:(Class)cellClass
{
    return [self mm_registerCellClass:cellClass reuseIdentifier:NSStringFromClass(cellClass)];
}

// 获取一个cell
- (__kindof UITableViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass
                                                forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (__kindof UITableViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass
{
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
}

/**
 注册一个段头/尾类， 可以使Class ，也可以 NIB 文件
 
 @param sectionHeaderClass 段头类
 @param reuseIdentifier 复用id
 */
- (void)mm_registerSectionHeaderFooterClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([self mm_hasNibClass:sectionHeaderClass]) {
        return [self registerNib:[UINib nibWithNibName:NSStringFromClass(sectionHeaderClass) bundle:nil] forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    }
    [self registerClass:sectionHeaderClass forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}
- (void)mm_registerSectionHeaderFooterClass:(Class)sectionHeaderClass
{
    [self mm_registerSectionHeaderFooterClass:sectionHeaderClass reuseIdentifier:NSStringFromClass(sectionHeaderClass)];
}

// 获取一个段头/尾
- (__kindof UITableViewHeaderFooterView *)mm_dequeueReusableSectionHeaderFooterWithClass:(Class)headerClass
{
    return [self mm_dequeueReusableSectionHeaderFooterWithIdentifier:NSStringFromClass(headerClass)];
}

- (__kindof UITableViewHeaderFooterView *)mm_dequeueReusableSectionHeaderFooterWithIdentifier:(NSString *)reuseIdentifier
{
    return [self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
}
@end
