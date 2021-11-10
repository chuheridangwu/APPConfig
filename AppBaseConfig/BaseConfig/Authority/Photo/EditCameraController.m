//
//  EditCameraController.m
//  MoreLive
//
//  Created by mlive on 2021/7/15.
//  Copyright © 2021 tiange. All rights reserved.
//

#import "EditCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "EditImgController.h"

@interface EditCameraController ()<AVCapturePhotoCaptureDelegate>
// 捕获设备
@property (nonatomic, strong) AVCaptureDevice *device;
// 输入设备
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 输出图片设置
@property (nonatomic, strong) AVCapturePhotoSettings *outputSettings;
// 输出图片
@property (nonatomic, strong) AVCapturePhotoOutput *imgOutput;
// 启动摄像头
@property (nonatomic, strong) AVCaptureSession *session;
// 图像预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIView *bottonView;

@property (nonatomic, strong) EditImgController *scaleView;

@property (nonatomic, assign)CGFloat barHeight;
@end

@implementation EditCameraController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_session) {
        [_session startRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self creatrCamerDistrict];
    
    [self.view addSubview:self.bottonView];
}

- (void)creatrCamerDistrict{
    // 获取后置摄像头
    _device = [self camerWithPosition:AVCaptureDevicePositionBack];
    _input = [[AVCaptureDeviceInput alloc]initWithDevice:_device error:nil];
    _session = [[AVCaptureSession alloc]init];

    _imgOutput = [[AVCapturePhotoOutput alloc]init];
    NSDictionary *dic = @{AVVideoCodecKey:AVVideoCodecJPEG};
    _outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:dic];
    [_imgOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    
    // 获取图片大小
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // 添加输入输出
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_imgOutput]) {
        [_session addOutput:_imgOutput];
    }
    
    // 生成预览层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    _previewLayer.frame = CGRectMake(0, self.barHeight + 20, SCREEN_WIDTH_IMG, SCREEN_HEIGHT_IMG - self.barHeight - 140 - self.barHeight);
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:_previewLayer];

  // 开始取景
    [_session startRunning];
}

//根据前后置摄像头
- (AVCaptureDevice *)camerWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark --  bottonView
- (UIView *)bottonView{
    if (!_bottonView) {
        _bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT_IMG - 120 - self.barHeight, SCREEN_WIDTH_IMG, 120 + self.barHeight)];

        UIButton *fixBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [fixBtn setImage:[UIImage imageNamed:@"cameraBtn"] forState:UIControlStateNormal];
        [fixBtn addTarget:self action:@selector(fixPhoto) forControlEvents:UIControlEventTouchUpInside];
        [_bottonView addSubview:fixBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelPhoto) forControlEvents:UIControlEventTouchDown];
        [_bottonView addSubview:cancelBtn];
        
        UIButton *switchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImage *image = [UIImage imageNamed:@"camera_switch"];
        [switchBtn setImage:image forState:UIControlStateNormal];
        [switchBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
        [_bottonView addSubview:switchBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.centerY.offset(0);
            make.width.equalTo(@80);
        }];
        
        [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.offset(0);
            make.width.equalTo(@(image.size.width));
            make.height.equalTo(@(image.size.height));
        }];
        
        [fixBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.equalTo(@120);
            make.height.equalTo(@120);
        }];
    }
    return _bottonView;
}

#pragma mark -- 拍照
- (void)fixPhoto{
    AVCaptureConnection *conntion = [_imgOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败");
        return;
    }
    
    [_imgOutput capturePhotoWithSettings:_outputSettings delegate:self];

}

#pragma mark -- 输出图片
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
        
    image = [self fixOrientation:image]; //修正图片方向
    
    [self.session stopRunning];
    
    
    if ([self.delegate respondsToSelector:@selector(selectImage:withController:)]) {
        [self.delegate selectImage:image withController:self];
    }
    
    // 保存到相册
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- 修正图片
- (UIImage *)fixOrientation:(UIImage*)img{
    // No-op if the orientation is already correct
    if (img.imageOrientation == UIImageOrientationUp) return img;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, img.size.width, img.size.height,
                                             CGImageGetBitsPerComponent(img.CGImage), 0,
                                             CGImageGetColorSpace(img.CGImage),
                                             CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return image;
}
- (void)cancelPhoto{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    
    if (cameraCount > 1) {
        
        NSError *error;
        //给摄像头的切换添加翻转动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.type = @"oglFlip";
        animation.subtype = kCATransitionFromLeft;
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //拿到另外一个摄像头位置
        AVCaptureDevicePosition position = [[_input device] position];
        
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self camerWithPosition:AVCaptureDevicePositionBack];
        }
        else {
            newCamera = [self camerWithPosition:AVCaptureDevicePositionFront];
        }
        
        //生成新的输入
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
        [self.previewLayer addAnimation:animation forKey:@"OglFlipAnimation"];
    }
}

- (CGFloat)barHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
