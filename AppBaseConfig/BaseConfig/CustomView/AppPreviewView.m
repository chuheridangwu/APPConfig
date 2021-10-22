//
//  AppPreviewView.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/17.
//

#import "AppPreviewView.h"

@interface AppPreviewView()<UIScrollViewDelegate>
@property (nonatomic,strong)UILabel *timeL;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int count;
@end

@implementation AppPreviewView

+ (void)showPreviewView {
    [[UIApplication sharedApplication].delegate.window addSubview:[AppPreviewView new]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        _count = 4;
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(downTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)downTime{
    _count --;
    _timeL.text = [NSString stringWithFormat:@"%d s",_count];
    if (_count == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setup {
    
    self.frame = [UIScreen mainScreen].bounds;
  
    UIImage *img = [UIImage imageNamed:@"launch_image"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:img];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        mas_v(edges);
    }];
    
    _timeL = [UILabel mm_createLabel:[UIColor whiteColor] fontSize:16 textAlignment:NSTextAlignmentCenter text:@"3s"];
    _timeL.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    [_timeL mm_cutRounded:12.5];
    [self addSubview:_timeL];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(50);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [UIView animateWithDuration:1.5 animations:^{
//            logo.alpha = 0;
//        }];
//
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [self removeFromSuperview];
//
//    });

}

- (void)showFirst {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    sv.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
    sv.pagingEnabled = YES;
    sv.delegate = self;
    sv.showsHorizontalScrollIndicator = NO;
//    sv.bounces = NO;
    [self addSubview:sv];
    
    
    NSArray *arr = @[@"pic_login02",@"pic_login03",@"pic_login04",@"pic_login05"];
    
    for (NSInteger i = 0;  i < arr.count; i++) {
        
        UIImageView *pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self imgNameWithName:arr[i]]]];
        [sv addSubview:pic];
        pic.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > SCREEN_WIDTH * 3) {
        
        [self removeFromSuperview];
    }
}

- (NSString *)imgNameWithName:(NSString *)name {
    
    NSString *str = name;
    
    CGFloat w = SCREEN_WIDTH;
    CGFloat h = SCREEN_HEIGHT;

    if (w  == 428 || w == 390 || w == 414) {
        
        if (h == 736) {
            str = [str stringByAppendingString:@"_1242"];
        } else {
            str = [str stringByAppendingString:@"_1125"];
        }
        
    } else if (w  == 375) {
        str = [str stringByAppendingString:@"_750"];
    } else {
        str = [str stringByAppendingString:@"_1242"];
    }
    
    return str;
}

@end
