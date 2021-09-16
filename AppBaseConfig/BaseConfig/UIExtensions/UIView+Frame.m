//
//  UIView+Frame.m
//  CategoryProject
//
//  Created by mlive on 2021/4/15.
//

#import "UIView+Frame.h"
#import <objc/runtime.h>

@implementation UIView (Frame)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin{
    return self.frame.origin;
}

//中心X点
- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY{
    return self.center.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}
- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

#pragma mark Insepectable

-(CGFloat)cornerRadius_m
{
    return self.layer.cornerRadius;
}

-(void)setCornerRadius_m:(CGFloat)cornerRadius_m
{
    if(self.cycleCorner_m) return;
    self.layer.cornerRadius = cornerRadius_m;
    self.layer.masksToBounds = YES;
}


-(void)setCycleCorner_m:(BOOL)cycleCorner_m
{
    objc_setAssociatedObject(self, @selector(cycleCorner_m), @(cycleCorner_m), OBJC_ASSOCIATION_COPY);
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = cycleCorner_m;
    if(cycleCorner_m) {
        self.layer.cornerRadius = self.frame.size.width/2.0;
    }
}

-(BOOL)cycleCorner_m
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end


#pragma mark -- 快捷方法
@implementation UIView (Method)
// 初始化
+ (instancetype)mm_instance
{
    NSString *clazz = NSStringFromClass([self class]);
    NSString *path = [[NSBundle mainBundle] pathForResource:clazz ofType:@"nib"];
    if (path.length) {
        return [NSBundle.mainBundle loadNibNamed:clazz owner:nil options:nil].firstObject;
    }
    return [[self class] new];
}

// 切圆角
- (void)mm_cutRounded:(CGFloat)size
{
    self.layer.cornerRadius = size;
    self.clipsToBounds=YES;
}

/**
 * 切某个角的圆角
 * rectCorner  方向
 *  圆角大小
 */
-(void)mm_cutRoundOnCorner:(UIRectCorner)rectCorner radius:(float)radius
{
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    [self.layer setMask:maskLayer];
}

/**
 * 添加渐变色
 * axis 渐变方向
 * startColor  初始颜色
 * endColor 结束颜色
 */
- (void)mm_gradientLayer:(UILayoutConstraintAxis)axis startColor:(UIColor*)startColor endColor:(UIColor*)endColor
{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //设置渐变区域的起始和终止位置（范围为0-1,起始左上角为(0,0),结束为右下角为(1,1)）
    if (axis == UILayoutConstraintAxisHorizontal) {
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1,0.5);
    }else{
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
    }
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1)，如果颜色比较多可以使用多个颜色分区
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:gradientLayer atIndex:0];
//    [self.layer addSublayer:gradientLayer];
}

// 添加边框
- (void)mm_shadowView:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset shadowRadius:(CGFloat)shadowRadius
{
    self.layer.cornerRadius = radius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = shadowRadius;
}

// 添加蚂蚁线
- (void)mm_drawDottedLine:(CGFloat)height width:(CGFloat)width color:(UIColor *)color
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:color.CGColor];
    //        [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:height];
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:@(width),@(width),nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width,0);
    [shapeLayer setPath:path];
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
}

- (void)mm_breathLeamView:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(double)duration
{
    //呼吸灯动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    opacityAnimation.toValue = [NSNumber numberWithFloat:toValue];
    opacityAnimation.duration = duration;
    opacityAnimation.autoreverses = YES;
    opacityAnimation.repeatCount = FLT_MAX;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
}

// 移除所有子视图
- (void)mm_removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

// 添加点击手机
- (void)mm_addTapGesture:(id)target selector:(SEL)selector
{
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

// 线性动画，从下到上
- (void)mm_animationDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 0.4)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:nil];
}
@end

#pragma mark -- 创建控件
@implementation UIView (UI)
+ (UILabel *)mm_createLabel:(CGRect)frame
                   fontSize:(CGFloat)fontSize
              textAlignment:(NSTextAlignment)alignment
                       text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = alignment;
    label.text = text;
    label.textColor = [UIColor blackColor];
    return label;
}

- (UIImage *)mm_createQRCode:(NSString *)dataString withSize:(CGFloat) size iconImage:(UIImage *)iconImage
{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage * image = [UIImage imageWithCGImage:scaledImage];
    
    if (!iconImage) {
        return image;
    }
    // 5.开启图形上下文
    UIGraphicsBeginImageContext(image.size);
    // 6.画二维码的图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 7.画程序员的图片
    UIImage *meImage = iconImage;
    CGFloat meImageW = 50;
    CGFloat meImageH = 50;
    CGFloat meImageX = (image.size.width - meImageW) * 0.5;
    CGFloat meImageY = (image.size.height - meImageH) * 0.5;
    [meImage drawInRect:CGRectMake(meImageX, meImageY, meImageW, meImageH)];
    // 8.获取图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 9.关闭图形上下文
    UIGraphicsEndImageContext();
    return finalImage;
}

/** 生成条形码*/
- (UIImage *)mm_createBarCode:(NSString *)inputMessage width:(CGFloat)width height:(CGFloat)height
{
    NSData *inputData = [inputMessage dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
     CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
     [filter setValue:inputData forKey:@"inputMessage"];
     CIImage *ciImage = filter.outputImage;
     CGFloat scaleX = width/ciImage.extent.size.width;
     CGFloat scaleY = height/ciImage.extent.size.height;
     ciImage = [ciImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
     UIImage *returnImage = [UIImage imageWithCIImage:ciImage];
     return returnImage;
}
@end


#pragma mark -- 添加手势

@implementation UIView(GestureRecognizer )

- (void)mm_addTapGesture:(id)target sel:(SEL)selector {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
}

- (void)mm_addPanGesture:(id)target sel:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:pan];
}

- (void)mm_addTapGesture:(id)target selector:(SEL)selector {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

- (void)mm_addLongPressGesture:(id)target sel:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:selector];
    [self addGestureRecognizer:longPress];
}

@end
