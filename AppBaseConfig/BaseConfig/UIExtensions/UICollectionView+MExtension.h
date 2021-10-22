//
//  UICollectionView+MExtension.h
//  yaho
//
//  Created by mlive on 2021/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (MExtension)
/**
 注册一个cell xib/class文件
 
 @param cellClass class of collection cell
 */
- (void)mm_registerCellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier;

- (void)mm_registerCellClass:(Class)cellClass;

// 获取一个cell
- (__kindof UICollectionViewCell *)mm_dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;
/**
 注册一个段头/尾类， 可以使Class ，也可以 NIB 文件
 
 @param sectionHeaderClass 段头类
 @param reuseIdentifier 复用id
 */
- (void)mm_registerSectionHeaderClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier;
- (void)mm_registerSectionFooterClass:(Class)sectionHeaderClass reuseIdentifier:(NSString *)reuseIdentifier;

- (void)mm_registerSectionHeaderClass:(Class)sectionHeaderClass;
- (void)mm_registerSectionFooterClass:(Class)sectionHeaderClass;

// 获取一个段头/尾
- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionHeaderWithClass:(Class)headerClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionHeaderWithClass:(Class)headerClass
                                                               reuseIdentifier:(NSString *)identifier
                                                                  forIndexPath:(NSIndexPath *)indexPath;

- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionFooterWithClass:(Class)footerClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UICollectionReusableView *)mm_dequeueReusableSectionFooterWithClass:(Class)headerClass
                                                               reuseIdentifier:(NSString *)identifier
                                                                  forIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
