//
//  ViewController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/4/21.
//

#import "ViewController.h"
#import "BannerController.h"
#import "CategoryController.h"

#import "UIView+Frame.h"
#import "MacroHeader.h"

typedef NS_ENUM(NSInteger,CellType) {
    CellType_Banner = 0,
};

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"Banner",@"分类"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

static NSString *identifier = @"UITableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) { // 省事，先这样写
        case 0:
        {
            BannerController *bannerVC = [[BannerController alloc] init];
            [self.navigationController pushViewController:bannerVC animated:YES];
        }
            break;
        case 1:
        {
            CategoryController *bannerVC = [[CategoryController alloc] init];
            [self.navigationController pushViewController:bannerVC animated:YES];
        }
            break;
            
        default:
            break;
    }

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
