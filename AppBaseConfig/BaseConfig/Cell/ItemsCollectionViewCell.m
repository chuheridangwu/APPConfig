//
//  ItemsCollectionViewCell.m
//  yaho
//
//  Created by mlive on 2021/10/13.
//

#import "ItemsCollectionViewCell.h"

@interface ItemsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation ItemsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
