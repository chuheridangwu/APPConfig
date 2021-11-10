//
//  CategoryView2.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import "CategoryView2.h"
#import "QMUIGridView.h"

@interface CategoryView2 ()
@property (nonatomic, strong) QMUIGridView *classView;
@end

@implementation CategoryView2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor yellowColor];

    CGFloat line = mm_Width_Fix(44) + mm_Width_Fix(5) + mm_Width_Fix(12);
    _classView = [[QMUIGridView alloc] initWithColumn:3 rowHeight:line];
    _classView.separatorWidth = mm_Width_Fix(12);
    _classView.separatorColor = [UIColor redColor];
    [self addSubview:_classView];
    [_classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.bottom.offset(0);
        mas_v(left.right);
    }];
}


- (void)setCate:(NSArray<NSString *> *)cate {
    if (_cate == cate) {
        return;
    }
    _cate = cate;
    
    for (UIView *view in self.classView.subviews) {
        [view removeFromSuperview];
    }
    
    
    for (NSInteger i = 0; i < cate.count; i++) {
        
        NSString *model = cate[i];
        
        QMUIButton *item = [QMUIButton mm_createBtnWithTitle:@"456" color:mm_ColorFromHex(0x333333) font:12 block:^(UIButton *sender) {

            !self.cateBlock ?: self.cateBlock(model);

        }];
        
        
        UIImage *place = [[UIImage imageNamed:model] qmui_imageResizedInLimitedSize:mm_size(44, 44)];
        [item setImage:place forState:UIControlStateNormal];
        [item mm_setImagePositionWithType:ButtonEdgeInsetsStyleTop spacing:mm_Width_Fix(5)];
        [self.classView addSubview:item];
        
//        [item setImage:[UIImage imageNamed:model] forState:UIControlStateNormal];
//        [item sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal];
//
//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[XTools urlWithUrlString:model.img] options:SDWebImageDownloaderUseNSURLCache context:0 progress:0 completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//            if (image) {
//                image = [image qmui_imageResizedInLimitedSize:mm_size(44, 44)];
//                [item setImage:image forState:UIControlStateNormal];
//            }
//        }];
    }
}


@end


