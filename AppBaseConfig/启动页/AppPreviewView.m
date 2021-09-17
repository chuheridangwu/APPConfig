//
//  AppPreviewView.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/17.
//

#import "AppPreviewView.h"

@interface AppPreviewView()<UIScrollViewDelegate>

@end

@implementation AppPreviewView

+ (void)showPreviewView {
    [[self currentViewController].view addSubview:[AppPreviewView new]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {

    
    self.frame = [UIScreen mainScreen].bounds;
    
  
    
    UIImage *img = [UIImage imageNamed:[self imgNameWithName:@"pic_login01"]];
    UIImageView *logo = [[UIImageView alloc] initWithImage:img];
    [self addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        mas_v(edges);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.5 animations:^{
            logo.alpha = 0;
        }];


    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
//
//        if (!XUserShared.deviceInfo.isScheme) {
//            [self showFirst];
//        } else {
//        }
        
    });

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
