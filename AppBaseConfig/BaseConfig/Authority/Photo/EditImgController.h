//
//  ImageViewController.h
//  EditImage-Demo
//
//  Created by 尊旅环球游 on 2017/7/12.
//  Copyright © 2017年 chk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define weak(obj) __weak typeof(obj) Weak_##obj = obj;
#define strong(obj) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(obj) obj = Weak_##obj; \
_Pragma("clang diagnostic pop")

#define SCREEN_WIDTH_IMG [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT_IMG [[UIScreen mainScreen] bounds].size.height

typedef void(^UpdateIconImage)(UIImage *);

@interface EditImgController : UIViewController

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,copy) UpdateIconImage updateImage;

@end
