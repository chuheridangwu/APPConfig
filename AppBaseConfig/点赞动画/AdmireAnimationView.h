//
//  AdmireAnimationView.h
//  9158Live
//
//  Created by daiyufeng on 16/3/26.
//  Copyright © 2016年 tiange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdmireAnimationView : UIImageView

-(id)initWithSuperView:(UIView *)view;

-(void)startWithLevel:(int)level number:(int)num;

@end
