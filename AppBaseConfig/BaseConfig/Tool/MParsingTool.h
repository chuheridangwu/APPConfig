//
//  MParsingTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//  解析工具，子类可以继承它

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MParsingTool : NSObject
+ (instancetype)mm_modelWithJson:(NSDictionary *)json;
- (void)mm_modelWithJson:(NSDictionary *)json;

+ (NSArray *)mm_modelArrayWithJson:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
