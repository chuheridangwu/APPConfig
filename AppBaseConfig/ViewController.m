//
//  ViewController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/4/21.
//

#import "ViewController.h"
#import "BannerController.h"
#import "CategoryController.h"
#import "DianZanController.h"

#import "UIView+Frame.h"
#import "MacroHeader.h"
#import "AppPreviewView.h"

typedef NS_ENUM(NSInteger,CellType) {
    CellType_Banner = 0,
};


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray <Model*>*dataSource;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dataSource = @[
        [Model initWithTitle:@"轮播图" name:@"BannerController"],
        [Model initWithTitle:@"首页分类item" name:@"CategoryController"],
        [Model initWithTitle:@"直播间点赞动画" name:@"DianZanController"]
    ];

    [self.view addSubview:self.tableView];
    
//    [AppPreviewView showPreviewView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

static NSString *identifier = @"UITableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Model *model =  self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model =  self.dataSource[indexPath.row];
    QMUICommonViewController *controller = (QMUICommonViewController*)[[NSClassFromString(model.controllerName) alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}


@end





@implementation Model

+ (Model*)initWithTitle:(NSString*)title name:(NSString*)name{
    Model *model = [[Model alloc] init];
    model.title = title;
    model.controllerName = name;
    return model;
}

@end
