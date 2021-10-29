//
//  UIImage+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DataBlock)(NSData  *resultData);

@interface UIImage (Method)
/*
 1.白色,参数:
 透明度 0~1,  0为白,   1为深灰色
 半径:默认30,推荐值 3   半径值越大越模糊 ,值越小越清楚
 色彩饱和度(浓度)因子:  0是黑白灰, 9是浓彩色, 1是原色  默认1.8
 “彩度”，英文是称Saturation，即饱和度。将无彩色的黑白灰定为0，最鲜艳定为9s，这样大致分成十阶段，让数值和人的感官直觉一致。
 */
- (UIImage *)mm_imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;

// 2.封装好,供外界调用的
- (UIImage *)mm_imgWithBlur;


/**
 图片变灰
 */
+ (UIImage*)mm_grayscaleImageForImage:(UIImage*)image;

/**
 绘制图片改变颜色

 @param color 颜色
 @return 图片
 */
-(UIImage*)mm_imageChangeColor:(UIColor*)color;

/**
 修复图片旋转问题
 @return 处理后的图片
 */
- (UIImage *)mm_fixImageOrientation;

//图片拼接
+ (UIImage *)mm_combine:(UIImage*)leftImage :(UIImage*)rightImage;

/**
 *  压缩图片到指定尺寸
 *
 *  @param image 目标图片
 *  @param size  目标尺寸大小（最大值）
 *
 */
+ (void)mm_compressOriginalImage:(UIImage *)image toSize:(CGSize)size block:(DataBlock)DataBlock;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
+ (UIImage *)mm_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

/**
 *  压缩图片到指定尺寸
 *
 *  @param image 目标图片
 *  @param mBool 如果为yes必须要压缩到指定大小
 *  @param maxKB  目标尺寸大小（最大值）
 *
 */
+ (void)mm_compressOriginalImage:(UIImage *)image toMaxKB:(CGFloat)maxKB mBool:(BOOL)mBool block:(DataBlock)DataBlock;

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param targetSize  目标大小
 *
 *  @return 生成图片
 */
+ (UIImage*)mm_imageByScalingAndCroppingForImage:(UIImage *)image size:(CGSize)targetSize;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)mm_compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 压缩图片到指定文件大小

 @param image 目标图片
 @param bytes 目标大小（最大值）
 @param DataBlock 返回的图片文件
 */
+ (void)mm_compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)bytes block:(DataBlock)DataBlock;

/**
 压缩图片到指定文件大小
 
 @param source_image 目标图片
 @param maxSize 目标大小（最大值）
 @return 返回的图片文件
 */
+ (NSData *)mm_resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;


/**
 *  获取图片主色调
 */
+ (UIColor *)mm_imageDominant:(UIImage *)image;


/**
 等比缩放
 
 @param size size
 @param source_image source_image
 @return UIImage
 */
+ (UIImage *)mm_newSizeImage:(CGSize)size image:(UIImage *)source_image;

/**
 压缩或拉伸图片到指定大小
 @return 处理后的图片
 */
-(UIImage *)mm_imageResizedWith:(CGSize)size;

/**
 根据颜色生成一张图片，默认 1x1 大小
 @param color 颜色
 @return 一张图片
 */
+ (UIImage *)mm_imageWithColor:(UIColor *)color;

+ (UIImage *)mm_imageWithColor:(UIColor *)color size:(CGSize)size;

// 按图片的大小 智能压缩
- (NSData *)mm_smartCompressedImage;

// 缩略图
- (UIImage *)mm_thumbnailImage;

/// layer转img
/// @param layer layer
+ (UIImage *)imageFromLayer:(CALayer *)layer;

/**
 改变图片颜色，纯色的好处理
 @return 处理后的
 */
-(UIImage *)mm_imageConvertedToColor:(UIColor*)color;
-(UIImage *)mm_imageConvertedToColor:(UIColor*)color alpha:(CGFloat)alpha;


/**
 图片中某一点的 色值， x, y 必须大于 1
 
 @param point 图片某一点的位置
 @return 当前点位置
 */
-(UIColor *)mm_imageColorAtPoint:(CGPoint)point;

/**在point点进行拉伸*/
-(UIImage *)mm_imageScaledAtPoint:(CGPoint)point;
-(UIImage *)mm_imageScaled;

// 二维码
+(UIImage *)mm_qrImageWithString:(NSString *)string size:(CGFloat)size;

/**
 模糊化
 @param level 模糊程度
 */
-(UIImage *)mm_bluredImageWithLevel:(float)level;

/**
 @param images a bunch of UIImage
 */
+(UIImage *)mm_mergeImagesWith:(NSArray<UIImage *> *)images inSize:(CGSize)size;

- (UIImage *)bhb_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage *)maskImage;

/*
 gif
 */
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

/*
拍照横竖屏
*/

- (UIImage *)fixOrientation;
@end

NS_ASSUME_NONNULL_END
