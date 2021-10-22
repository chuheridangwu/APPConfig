//
//  CategoryView1.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import "CategoryView1.h"
#import "CategoryModel.h"

@interface CategoryView1 ()
@property (nonatomic,strong)UIImageView *aroImgView; // 箭头
@property (nonatomic,strong)NSMutableArray <UIView*>*views; //数组

@property (nonatomic,strong)NSArray *imgs; //图片数组
@end

@implementation CategoryView1

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _views = [NSMutableArray array];
        _imgs = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                  @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
        [self initUi];
    }
    return self;
}

-(void)initUi{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [bottomView mm_addTapGesture:self sel:@selector(onClickShowMore)];
    [self addSubview:bottomView];
    [bottomView addSubview:self.aroImgView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    [self.aroImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-2);
        make.width.height.mas_equalTo(15);
    }];
}


- (void)setIsCloseMore:(BOOL)isCloseMore{
    _isCloseMore = isCloseMore;
    [_aroImgView setImage:[UIImage imageNamed: isCloseMore ? @"home_hot_bottom" : @"home_hot_top"]];
    
    [_views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int itemCount = 4;

    NSArray *ary = _imgs;
    if (isCloseMore && ary.count > itemCount) {
        ary = [_imgs subarrayWithRange:NSMakeRange(0, itemCount)];
    }
    
    CGFloat margin = 15;
    CGFloat topMargin = 5;
    CGFloat itemW = (Screen_Width - (margin * (itemCount + 1))) /  itemCount;
    CGFloat itemH = itemW + 15;
    WS(ws);
    for (int i = 0; i < ary.count; i++) {
        int row = i / itemCount;
        int low = i % itemCount;
        CGFloat offsetx = margin + (margin + itemW) * low;
        CGFloat offsety = row * (itemH + topMargin);
        CategoryModel *data = ary[i];
        CategoryItem1 *item = [[CategoryItem1 alloc] initWithFrame:CGRectMake(offsetx, offsety, itemW, itemH) withData:data];
        [self addSubview:item];
        item.itemBlock = ^{
            if (ws.itemBlock) {
                ws.itemBlock(data);
            }
        };
        [_views addObject:item];
    }
}

- (void)onClickShowMore{
    WS(ws);
    if (_showBlock) {
        _showBlock(ws.isCloseMore ? NO : YES);
    }
}

+ (CGFloat)cellHeight:(BOOL)isCloseMore{
    NSArray *ary = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                     @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",];
    
    int itemCount = 4;
    
    CGFloat margin = 15;
    CGFloat topMargin = 5;
    CGFloat itemW = (Screen_Width - (margin * (itemCount + 1))) /  itemCount;
    CGFloat itemH = itemW + 15;
    
    CGFloat height = itemH;
    // 如果展开分类
    if (ary.count > itemCount  && isCloseMore == NO) {
        height = (topMargin + itemH) * (ary.count / itemCount) + (ary.count % itemCount == 0 ? 0 : itemH);
    }
    
    // 20 是下面的间隔高度，5是上面的间隔高度
    height += 25;
    
    return  height;
}

- (UIImageView *)aroImgView{
    if (!_aroImgView) {
        _aroImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_hot_bottom"]];
        _aroImgView.userInteractionEnabled = YES;
        _aroImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _aroImgView;
}

@end


@implementation CategoryItem1

- (instancetype)initWithFrame:(CGRect)frame withData:(CategoryModel *)data{
    if (self = [super initWithFrame:frame]) {
        
        _data = data;

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.layer.masksToBounds = YES;

        UILabel *label = [UILabel mm_createLabel:mm_ColorFromHex(0x686868) fontSize:12 textAlignment:NSTextAlignmentCenter text:@"123"];

        [self addSubview:imgView];
        [self addSubview:label];
        imgView.image = [UIImage imageNamed:@"h1.jpg"];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:data.tabImg]];


        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(5);
            make.right.offset(-5);
            make.height.equalTo(imgView.mas_width);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(imgView.mas_bottom).offset(0);
            make.bottom.offset(0);
        }];

        [self mm_addTapGesture:self sel:@selector(clickItem)];
    }
    
    return  self;
}

- (void)clickItem{
    if (_itemBlock) {
        _itemBlock();
    }
}

@end
