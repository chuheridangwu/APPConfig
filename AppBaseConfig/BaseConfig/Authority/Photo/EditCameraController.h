//
//  EditCameraController.h
//  MoreLive
//
//  Created by mlive on 2021/7/15.
//  Copyright © 2021 tiange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditCameraControllerDelegate<NSObject>
- (void)selectImage:(UIImage *)image withController:(UIViewController *)controller;
@end


@interface EditCameraController : UIViewController
@property (nonatomic, weak)id <EditCameraControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
