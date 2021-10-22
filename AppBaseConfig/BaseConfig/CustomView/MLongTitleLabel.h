//
//  MLongTitleLabel.h
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
// 滚动字符串

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 example
 
 MLongTitleLabel *label = [[MLongTitleLabel alloc]initWithFrame:CGRectMake(42, 5, 55, 15)];
 label.textAlignment = NSTextAlignmentLeft;
 label.textColor = [UIColor whiteColor];
 label.fontSize = 11;
 [self addSubview:label];
 */

@interface MLongTitleLabel : UIView

@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)UIColor  *textColor;
@property (nonatomic,assign)CGFloat  fontSize;
@property (nonatomic,assign)NSTextAlignment textAlignment;
@property (nonatomic,assign)int type;
@property (nonatomic,strong)UILabel  *titleLabel;

@end

NS_ASSUME_NONNULL_END
