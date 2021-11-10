//
//  CameraPhotoTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
//

#import "CameraPhotoTool.h"
#import "EditImgController.h"
#import "EditCameraController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <PhotosUI/PhotosUI.h>

@interface CameraPhotoTool()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate,EditCameraControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *pickerController;
@end

@implementation CameraPhotoTool

// 选择相机还是相册
- (void)selectedCameraOrPhoto:(UIViewController*)controller block:(SelectImageBlock)block{
    _baseController = controller;
    _imageBlock = block;
    
    __block typeof(self) ws = self;
    UIAlertAction *cameraAlert = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws chooseCamera];
    }];
    UIAlertAction *photoAlert = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws choosePhotoController];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                                  
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:cameraAlert];
    [alertVC addAction:photoAlert];
    [alertVC addAction:cancelAlert];
    
    if (alertVC.popoverPresentationController) { // 适配ipad alert在ipad上会崩溃
        [alertVC.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        alertVC.popoverPresentationController.sourceView = [UIApplication sharedApplication].windows.lastObject;
        alertVC.popoverPresentationController.sourceRect = [UIScreen mainScreen].bounds;
    }
    
    [controller presentViewController:alertVC animated:YES completion:nil];
  
//     更改文字颜色
//    for (UIAlertAction *action in actions) {
//        [alertVC addAction:action];
//        [action setValue:kBlack(0.6) forKey:@"titleTextColor"];
//    }
}


#pragma mark --  选择相机
- (void)chooseCamera{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        EditCameraController *vc = [[EditCameraController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.delegate = self;
        [self.baseController presentViewController:vc animated:YES completion:nil];
    }
}

- (void)selectImage:(UIImage *)image withController:(UIViewController *)controller{
    __block typeof(self) ws = self;
    EditImgController *vc = [[EditImgController alloc] init];
    vc.image = image;
    vc.updateImage = ^(UIImage *newIcon) {
        if (newIcon.size.width > 1200 || newIcon.size.height > 1200) {
            newIcon = [self scaleToSize:newIcon size:CGSizeMake(1200, 1200)];
        }
        [ws updataImage:newIcon];
        [ws.baseController dismissViewControllerAnimated:YES completion:nil];
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:vc animated:YES completion:nil];
}

#pragma mark --  选择相册
- (void)choosePhotoController{
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusNotDetermined:
                        NSLog(@"用户未选择");
                        break;
                    case PHAuthorizationStatusRestricted:
                    case PHAuthorizationStatusDenied:
                    {
                        NSLog(@"用户无权访问权限");
                    }
                        break;
                    case PHAuthorizationStatusAuthorized:
                        NSLog(@"用户允许被授权");
                        break;
                    case PHAuthorizationStatusLimited:
                    {
                        NSLog(@"用户允许被授权访问有限的照片");
                        [self selectedNewPhoto];
                    }
                        
                        break;
                    default:
                        break;
                }
            });
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusNotDetermined:
                        NSLog(@"用户未选择");
                        break;
                    case PHAuthorizationStatusRestricted:
                    case PHAuthorizationStatusDenied:
                    {
                        NSLog(@"用户无权访问权限");
                    }
                        break;
                    case PHAuthorizationStatusAuthorized:
                        NSLog(@"用户允许被授权");
                        [self selectedOldPhotoUI];
                        break;
                    default:
                        break;
                }
            });
        }];
    }
}

- (void)selectedNewPhoto{
    if (@available(iOS 14, *)) {
        PHPickerFilter *filter = [PHPickerFilter imagesFilter]; // 可配置查询用户相册中文件的类型，支持三种
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] initWithPhotoLibrary:[PHPhotoLibrary sharedPhotoLibrary]];
        configuration.filter = filter;
        // 选择单张或多张图片，0 不限制， 1、2、3限制图片个数
        configuration.selectionLimit = 0;
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        picker.delegate = self;

        // picker vc，在选完图片后需要在回调中手动 dismiss
        [self.baseController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)selectedOldPhotoUI{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
             PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
             // 没有权限
             if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
                  
             }else {
                 self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                 
                 if (@available(iOS 11.0,*)) {
                     [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
                 }
                 [self.baseController presentViewController:self.pickerController animated:YES completion:nil];
             }
         }
}

#pragma mark -- 相机的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage *upLoadImage = nil;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {
        // 针对 11.0 以上的iOS系统进行处理
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGRect crop = [[info valueForKey:@"UIImagePickerControllerCropRect"] CGRectValue];
        CGFloat w = crop.size.width +1;
        int c = w/SCREEN_WIDTH;
        crop.origin.y += 20 * c;
        upLoadImage  = [self ordinaryCrop:resultImage toRect:crop];
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        upLoadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    // 上传照片
    [self updataImage:upLoadImage];
}

- (UIImage *)ordinaryCrop:(UIImage *)imageToCrop toRect:(CGRect)cropRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

#pragma mark --  相册的代理
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block typeof(self) ws = self;
    NSItemProvider *itemProvider = results.lastObject.itemProvider;
    if ([itemProvider canLoadObjectOfClass:[UIImage class]]) {
        [itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    EditImgController *vc = [[EditImgController alloc] init];
                    vc.image = object;
                    vc.updateImage = ^(UIImage *newIcon) {
                        if (newIcon.size.width > 1000 || newIcon.size.height > 1000) {
                            newIcon = [self scaleToSize:newIcon size:CGSizeMake(1000, 1000)];
                        }
                        [ws updataImage:newIcon];
                    };
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [ws.baseController presentViewController:vc animated:YES completion:nil];
                });
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    } else {
        NSLog(@"Error cannot load.");
    }
}

// 等比压缩图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark -- 上传头像
- (void)updataImage:(UIImage*)image{
    if (_imageBlock) {
        _imageBlock(image);
    }
}

#pragma mark -- 懒加载
- (UIImagePickerController *)pickerController {
    if (_pickerController == nil) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.view.backgroundColor = [UIColor whiteColor];
        _pickerController.delegate = self;
        _pickerController.allowsEditing = YES;
        _pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        if ([[[UIDevice currentDevice] systemVersion ]floatValue ] > 8.0) {
            self.baseController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [_pickerController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [_pickerController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,
                                                           [UIFont systemFontOfSize:18], NSFontAttributeName,
                                                           nil]];
        
        _pickerController.navigationBar.tintColor = [UIColor blackColor];
    }
    return _pickerController;
}

@end
