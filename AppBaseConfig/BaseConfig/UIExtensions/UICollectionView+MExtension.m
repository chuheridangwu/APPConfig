//
//  UICollectionView+MExtension.m
//  yaho
//
//  Created by mlive on 2021/10/14.
//

#import "UICollectionView+MExtension.h"

@implementation UICollectionView (MExtension)
/**
 是否存在 文件 为nib的文件
 
 @param cellClass 该文件
 @return 是否存在 文件 为nib的文件
 */
-(BOOL)mjb_hasNibClass:(Class)cellClass
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
    if (![self mjb_hasNibClass:cellClass]) {
        return [self registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    [self registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)mm_registerCellClass:(Class)cellClass
{
    return [self mm_registerCellClass:cellClass reuseIdentifier:NSStringFromClass(cellClass)];
}

// 获取一个cell
- (__kindof UICollectionViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass
                                                forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}
/**
 注册一个段头/尾类， 可以使Class ，也可以 NIB 文件
 
 @param sectionHeaderClass 段头类
 @param reuseIdentifier 复用id
 */

- (void)mm_registerSectionHeaderClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([self mjb_hasNibClass:sectionHeaderClass]) {
        return [self registerNib:[UINib nibWithNibName:NSStringFromClass(sectionHeaderClass) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    }
    [self registerClass:sectionHeaderClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                  withReuseIdentifier:reuseIdentifier];
}
- (void)mm_registerSectionFooterClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([self mjb_hasNibClass:sectionHeaderClass]) {
        return [self registerNib:[UINib nibWithNibName:NSStringFromClass(sectionHeaderClass) bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier];
    }
    [self registerClass:sectionHeaderClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                  withReuseIdentifier:reuseIdentifier];
}

- (void)mm_registerSectionHeaderClass:(Class)sectionHeaderClass
{
    [self mm_registerSectionHeaderClass:sectionHeaderClass reuseIdentifier:NSStringFromClass(sectionHeaderClass)];
}
- (void)mm_registerSectionFooterClass:(Class)sectionFooterClass
{
    [self mm_registerSectionFooterClass:sectionFooterClass reuseIdentifier:NSStringFromClass(sectionFooterClass)];
}

// 获取一个段头/尾
- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionHeaderWithClass:(Class)headerClass forIndexPath:(NSIndexPath *)indexPath
{
    return [self mm_dequeueReusableSectionHeaderWithClass:headerClass
                                         reuseIdentifier:NSStringFromClass(headerClass)
                                            forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionHeaderWithClass:(Class)headerClass
                                                               reuseIdentifier:(NSString *)identifier
                                                                  forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                    withReuseIdentifier:identifier
                                           forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionFooterWithClass:(Class)footerClass forIndexPath:(NSIndexPath *)indexPath
{
    return [self mm_dequeueReusableSectionFooterWithClass:footerClass
                                         reuseIdentifier:NSStringFromClass(footerClass)
                                            forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionFooterWithClass:(Class)headerClass
                                                               reuseIdentifier:(NSString *)identifier
                                                                  forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                    withReuseIdentifier:identifier
                                           forIndexPath:indexPath];
}


@end
