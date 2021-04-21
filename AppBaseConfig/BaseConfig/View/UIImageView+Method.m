//
//  UIImageView+Method.m
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import "UIImageView+Method.h"

@implementation UIImageView (Method)
- (void)setImageName:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
}
- (NSString *)imageName
{
    return nil;
}

@end
