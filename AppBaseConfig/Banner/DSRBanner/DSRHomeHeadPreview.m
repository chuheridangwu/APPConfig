//
//  DSRHomeHeadPreview.m
//  MLLive
//
//  Created by daiyufeng on 2020/10/13.
//  Copyright © 2020 TianGe. All rights reserved.
//

#import "DSRHomeHeadPreview.h"
#import "DSRPreviewFlowLayout.h"
#import "mm_header.h"
#import "MacroHeader.h"


@interface DSRHomeHeadPreview()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *indexArrs;

@end

@implementation DSRHomeHeadPreview

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor clearColor]];

        self.indexArrs = @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                           @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                           @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                           @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg",
                           @"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"];
        
        CGFloat padding = 20 * (Screen_Width / 375.0);
        CGFloat itemW = (Screen_Width - padding * 2) * 0.5;
        CGRect rect = CGRectMake(7, 5.8,Screen_Width,220);
        
        DSRPreviewFlowLayout *layout = [[DSRPreviewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, rect.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = -40;
 
        
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DSRAnchorPreviewViewCell"];
        
        [self addSubview:_collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.indexArrs.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSRAnchorPreviewViewCell" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imgView.image = [UIImage imageNamed:self.indexArrs[indexPath.row]];
    [cell addSubview:imgView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    _indexPath = indexPath;
//    NSInteger index = [_indexArrs[indexPath.row] integerValue];
//    if (index == _playIndex) {
//        DSRAnchor *anchor = self.anchorArray[index];
//        if ([_delegate respondsToSelector:@selector(userClickHomePreviewAnchor:)]) {
//            [_delegate userClickHomePreviewAnchor:anchor];
//        }
//    }else {
//        [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.showCells removeObject:cell];
//    [self.showCells addObject:cell];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CGPoint pointInView = [self convertPoint:_collectionView.center toView:_collectionView];
//    NSIndexPath *indexPathNow = [_collectionView indexPathForItemAtPoint:pointInView];
//    NSInteger index = indexPathNow.row % _anchorArray.count;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_groupCount/2 * _anchorArray.count + index inSection:0];
//    _playIndex = index;
//    _indexPath = indexPath;
//    // 动画停止, 重新定位到 第50组(中间那组) 模型
//    [_collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//     [MobClick event:@"window_anchor_switch"];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNextPreview) object:nil];
//    [self performSelector:@selector(changeNextPreview) withObject:nil afterDelay:0.3];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    CGPoint pointInView = [self convertPoint:_collectionView.center toView:_collectionView];
//    NSIndexPath *indexPathNow = [_collectionView indexPathForItemAtPoint:pointInView];
//    NSInteger index = indexPathNow.row % _anchorArray.count;
//    _playIndex = index;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNextPreview) object:nil];
//    [self performSelector:@selector(changeNextPreview) withObject:nil afterDelay:0.5];
    
}

- (void)updateViewData {
//    _playingIdx = 0;
//    _playIndex = 0;
//    [self stopAllCellPlay];
//    if (_anchorArray.count > 1) {
//        [_indexArrs removeAllObjects];
//        for (NSInteger i = 0; i < _groupCount; i++) {
//            for (NSInteger j = 0; j < _anchorArray.count; j++) {
//                [self.indexArrs addObject:[NSNumber numberWithInteger:j]];
//            }
//        }
//        [self.collectionView reloadData];
//
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_groupCount / 2 * _anchorArray.count inSection:0];
//        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//
//    }else if (_anchorArray.count == 1) {
//        [_indexArrs removeAllObjects];
//        [self.indexArrs addObject:[NSNumber numberWithInteger:0]];
//        [self.collectionView reloadData];
//    }
}

- (void)stopAllCellPlay
{
//    for (int i = 0; i<self.showCells.count; i++) {
//        id hello = self.showCells[i];
//        if ([hello isKindOfClass:[NSNull class]]) {
//            continue;
//        }
//        if ([hello isKindOfClass:[DSRAnchorPreviewView class]]) {
//            DSRAnchorPreviewView *hi = (DSRAnchorPreviewView *)hello;
//            [hi forceClosePreview];
//        }
//    }
}

- (void)blurryImage:(UIImage *)image blurLevel:(CGFloat)blur {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 创建属性
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        // 滤镜效果 高斯模糊
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        // 指定模糊值 默认为10, 范围为0-100
        [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        
        CGImageRef outImage = [context createCGImage: result fromRect:[ciImage extent]];
        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            self->_anchorImgView.image = blurImage;
            CGImageRelease(outImage);
            
        });
    });
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end
