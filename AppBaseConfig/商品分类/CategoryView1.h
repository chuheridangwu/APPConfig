//
//  CategoryView1.h
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CategoryModel;
typedef void(^OnItemBlock)(CategoryModel *data);
typedef void(^OnClickShowBlock)(BOOL isClose);


@interface CategoryView1 : UIView
@property (nonatomic,copy)OnItemBlock itemBlock;
@property (nonatomic,copy)OnClickShowBlock showBlock;
@property (nonatomic,assign)BOOL isCloseMore; // YES显示全部分类  NO 是关闭
+ (CGFloat)cellHeight:(BOOL)isCloseMore;

@end

@interface CategoryItem1 : UIView
@property (nonatomic,copy)dispatch_block_t itemBlock;
@property (nonatomic,strong)CategoryModel *data;
- (instancetype)initWithFrame:(CGRect)frame withData:(CategoryModel *)data;

@end
NS_ASSUME_NONNULL_END
