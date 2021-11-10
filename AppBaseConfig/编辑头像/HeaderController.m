//
//  HeaderController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/11/10.
//

#import "HeaderController.h"
#import "CameraPhotoTool.h"

@interface HeaderController ()
@property (nonatomic,strong)CameraPhotoTool *photoTool;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation HeaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _photoTool = [[CameraPhotoTool alloc] init];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.view addSubview:_imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setTitle:@"点击选择图片" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake((self.view.bounds.size.width - 120) / 2, CGRectGetMaxY(_imageView.frame) + 30, 120, 44);
    [btn addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchDown];
}

- (void)clickHeader{
    __block typeof(self) ws = self;
    [_photoTool selectedCameraOrPhoto:self block:^(UIImage * _Nonnull image) {
        ws.imageView.image = image;
    }];
}


@end
