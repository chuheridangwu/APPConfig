//
//  CategoryView2.h
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CategoryView2 : UIView

@property (nonatomic, copy) NSArray <NSString *>*cate;
@property (nonatomic, copy) void(^cateBlock)(NSString *cate);

@end


NS_ASSUME_NONNULL_END
