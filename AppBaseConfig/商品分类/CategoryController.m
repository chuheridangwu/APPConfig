//
//  CategoryController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import "CategoryController.h"
#import "CategoryModel.h"
#import "CategoryView1.h"
#import "CategoryView2.h"

@interface CategoryController ()
@property (nonatomic,strong)CategoryView1 *view1;
@property (nonatomic,strong)CategoryView2 *view2;

@property (nonatomic,strong)NSArray *imgs; //图片数组
@end

@implementation CategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imgs = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                     @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                     @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",];
    
    [self.view addSubview:self.view1];
    
    
    
    [self.view addSubview:self.view2];
    _view2.cate = _imgs;
    
    NSInteger lines = _imgs.count / 3 + (_imgs.count % 3 > 0 ? 1 : 0);
    CGFloat lineHeight = lines * mm_Width_Fix(71); // 一行的高度
    _view2.height = lineHeight;
}

- (CategoryView1 *)view1{
    if (!_view1) {
        _view1 = [[CategoryView1 alloc] initWithFrame:CGRectMake(0, 90, Screen_Width, [CategoryView1 cellHeight:YES])];
        _view1.isCloseMore = YES;
        _view1.itemBlock = ^(CategoryModel * _Nonnull data) {
            
        };
        WS(ws);
        _view1.showBlock = ^(BOOL isClose) {
            ws.view1.isCloseMore = isClose;
            ws.view1.height = [CategoryView1 cellHeight:isClose];
        };
    }
    return _view1;
}

- (CategoryView2 *)view2{
    if (!_view2) {
        _view2 = [[CategoryView2 alloc] initWithFrame:CGRectMake(0, 200, Screen_Width, 100)];
    }
    return _view2;
}

@end
