//
//  ImageViewController.m
//  EditImage-Demo
//
//  Created by 尊旅环球游 on 2017/7/12.
//  Copyright © 2017年 chk. All rights reserved.
//

#import "EditImgController.h"

@interface EditImgController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation EditImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    UIView *viewMask = [[UIView alloc] initWithFrame:self.view.bounds];
    viewMask.backgroundColor = [UIColor blackColor];
    viewMask.alpha = 0.4;
    [self.view addSubview:viewMask];
    viewMask.userInteractionEnabled = NO;
    
    //镂空圆形
    UIBezierPath *mainPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, SCREEN_HEIGHT_IMG / 2 - SCREEN_WIDTH_IMG / 2, SCREEN_WIDTH_IMG, SCREEN_WIDTH_IMG) cornerRadius:0];
    [mainPath appendPath:[path bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = mainPath.CGPath;
    shapeLayer.borderWidth = 10;
    viewMask.layer.mask = shapeLayer;
    
    CALayer *layer = [CALayer layer];
    layer.frame =path.bounds;
    layer.borderWidth = 0.8;
    layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    [self addButton];
}

- (void)addButton {
    for (int i = 0; i < 2; i++) {
        CGRect frame = CGRectMake(0 + i * (SCREEN_WIDTH_IMG - 100), SCREEN_HEIGHT_IMG - 60 - 120, 100, 60 + 120);
        NSString *title = i == 0 ? @"取消" : @"确定";
        UIButton *btn = [self createButton:frame title:title tag:i];
        [self.view addSubview:btn];
    }
}


- (UIButton *)createButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnAction:(UIButton *)btn {
    if (btn.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage *image = [self cropImage];
        if (self.updateImage) {
            self.updateImage(image);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self addImage:image];
}

- (void)addImage:(UIImage *)image {
    CGFloat imgW = image.size.width;
    CGFloat imgH = image.size.height;
    
    CGFloat imgViewW = SCREEN_WIDTH_IMG;
    CGFloat imgViewH = SCREEN_WIDTH_IMG;
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    

    // 如果是宽>高的图片
    if (imgW > imgH) {
        imgViewW = SCREEN_WIDTH_IMG / image.size.height * image.size.width;
    }else{
        imgViewH = SCREEN_WIDTH_IMG / image.size.width * image.size.height;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0,  0, imgViewW, imgViewH);
    self.imageView.userInteractionEnabled = YES;
    
    self.scrollView.contentSize = CGSizeMake(imgViewW, imgViewH);
    self.scrollView.contentOffset = CGPointMake(offsetX,offsetY);
    [self.scrollView addSubview:self.imageView];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT_IMG - SCREEN_WIDTH_IMG) / 2.f, SCREEN_WIDTH_IMG, SCREEN_WIDTH_IMG)];
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.zoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        _scrollView.layer.masksToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


- (UIImage *)cropImage {
    
    UIImage *orignaImage = self.imageView.image;
    
    CGFloat width = (_scrollView.frame.size.width/self.imageView.frame.size.width)*orignaImage.size.width;
    CGFloat height = (_scrollView.frame.size.height/_scrollView.frame.size.width)*width;
    CGSize captureSize = CGSizeMake(width, height);
    
    CGFloat x = (_scrollView.contentOffset.x/self.imageView.frame.size.width)*orignaImage.size.width;
    CGFloat y = (_scrollView.contentOffset.y/self.imageView.frame.size.height)*orignaImage.size.height;
    CGPoint captureOffset = CGPointMake(x, y);
    
    // 长宽微调
    if (x + width >= self.imageView.frame.size.width) {
        x = self.imageView.frame.size.width - width;
    }
    if (y + height >= self.imageView.frame.size.height) {
        y = self.imageView.frame.size.height - height;
    }
    
    CGRect captureRect = CGRectMake(captureOffset.x, captureOffset.y, captureSize.height, captureSize.width);

    
    CGImageRef temp = CGImageCreateWithImageInRect(orignaImage.CGImage, captureRect);
    UIImage *result = [UIImage imageWithCGImage:temp];
    CGImageRelease(temp);
    
    return result;
}

// 截取View指定区域
- (UIImage*)imageFromView:(UIView *)view rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(view.size, NO, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect myImageRect = rect;
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef,myImageRect );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
