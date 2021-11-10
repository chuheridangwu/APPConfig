//
//  CameraPhotoTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
// 相机相册权限, 如果太麻烦直接看别人的项目  TZImagePickerController、HXPhotoPicker

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectImageBlock)(UIImage *image);

@interface CameraPhotoTool : NSObject
@property (nonatomic,weak)UIViewController *baseController;
@property (nonatomic,copy)SelectImageBlock imageBlock;

// 选择相机还是相册
- (void)selectedCameraOrPhoto:(UIViewController*)controller block:(SelectImageBlock)block;

@end

NS_ASSUME_NONNULL_END
