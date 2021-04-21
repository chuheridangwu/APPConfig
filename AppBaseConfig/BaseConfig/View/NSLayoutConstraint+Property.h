//
//  NSLayoutConstraint+Property.h
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (Property)

/** 自动适配屏幕 默认 NO  以宽度比例缩放 */
@property (nonatomic) IBInspectable BOOL widthAutoFitScreen;

/** 高度 自动适配屏幕 默认 NO  以高度比例缩放 */
@property (nonatomic) IBInspectable BOOL heightAutoFitScreen;

/** 1像素 默认 NO */
@property (nonatomic) IBInspectable BOOL onePixelLineScreen;

@end

NS_ASSUME_NONNULL_END
