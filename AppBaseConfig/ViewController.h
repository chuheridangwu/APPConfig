//
//  ViewController.h
//  AppBaseConfig
//
//  Created by mlive on 2021/4/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end



@interface Model : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *controllerName;

+ (Model*)initWithTitle:(NSString*)title name:(NSString*)name;
@end
