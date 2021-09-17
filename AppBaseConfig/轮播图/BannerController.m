//
//  BannerController.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import "BannerController.h"
#import "SDCycleScrollView.h"
#import "HQFlowView.h"
#import "DSRHomeHeadPreview.h"

@interface BannerController ()<SDCycleScrollViewDelegate,HQFlowViewDataSource,HQFlowViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *bannerScrollView; //滚动视图
@property (nonatomic,strong) HQFlowView *pageFlowView; // 另一种滚动视图
@property (nonatomic,strong) DSRHomeHeadPreview *preview;
@property (nonatomic,strong) NSArray *imgs;
@end

@implementation BannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imgs = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
    [self.view addSubview:self.bannerScrollView];
    
    [self.view addSubview:self.pageFlowView];
    [self.pageFlowView  reloadData];
    
    [self.view addSubview:self.preview];
}

#pragma mark -- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"当前点击的图片索引 -- %ld",index);
}

-(SDCycleScrollView*)bannerScrollView{
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,80,self.view.bounds.size.width,200) delegate:self placeholderImage:[UIImage imageNamed:@"placeHolder_ad"]];
        _bannerScrollView.infiniteLoop = YES;
        _bannerScrollView.hidesForSinglePage= YES;
        _bannerScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerScrollView.pageControlAliment =  SDCycleScrollViewPageContolAlimentRight;
        _bannerScrollView.currentPageDotColor = [UIColor whiteColor];
        _bannerScrollView.pageDotColor = [UIColor redColor];
        _bannerScrollView.localizationImageNamesGroup = _imgs;
    }
    return _bannerScrollView;
}

#pragma mark --  HQFlowViewDataSource
// 设置两个大小
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView
{
    return CGSizeMake(self.view.bounds.size.width - 2 * 30, flowView.frame.size.height);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    NSLog(@"点击第%ld个广告",subIndex);
}

- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return _imgs.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.layer.cornerRadius = 5;
        bannerView.layer.masksToBounds = YES;
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    //在这里下载网络图片
//    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.advArray[index]] placeholderImage:nil];
    //加载本地图片
    bannerView.mainImageView.image = [UIImage imageNamed:_imgs[index]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView
{
    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
}
#pragma mark --旋转屏幕改变JQFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

- (void)dealloc
{
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}

- (HQFlowView *)pageFlowView{
    if (!_pageFlowView) {
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.3;
        _pageFlowView.leftRightMargin = 15;
        _pageFlowView.topBottomMargin = 20;
        _pageFlowView.orginPageCount = _imgs.count;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}

- (DSRHomeHeadPreview *)preview{
    if (!_preview) {
        _preview = [[DSRHomeHeadPreview alloc] initWithFrame:CGRectMake(0, 520,self.view.bounds.size.width, 200)];
    }
    return _preview;
}
@end
