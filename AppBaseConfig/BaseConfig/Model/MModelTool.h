//
//  MModelTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MModelTool : NSObject
@property (nonatomic, assign) CGFloat layout_height;

+ (instancetype)modelWithJson:(NSDictionary *)json;

- (void)modelWithJson:(NSDictionary *)json;

+ (NSArray *)modelArrayWithJson:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
