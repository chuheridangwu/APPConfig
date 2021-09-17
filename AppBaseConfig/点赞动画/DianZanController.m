//
//  DianZanController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/17.
//

#import "DianZanController.h"
#import "AdmireAnimationView.h"



@interface DianZanController ()
@property (nonatomic,strong)AdmireAnimationView   *admireAnimationView;

@end

@implementation DianZanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel mm_createLabel:[UIColor redColor] fontSize:20 textAlignment:NSTextAlignmentCenter text:@"点击屏幕显示点赞动画"];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        mas_v(left.right.top.bottom);
    }];
    
    _admireAnimationView = [[AdmireAnimationView  alloc] initWithSuperView:self.view];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_admireAnimationView startWithLevel:1 number:1];
    int num = random() %10;
    [_admireAnimationView startWithLevel:num < 5?1:num/5.0 number:num];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
