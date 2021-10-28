//
//  MModelTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/10/27.
//

#import "MModelTool.h"
#import "YYModel.h"

@implementation MModelTool

+ (instancetype)modelWithJson:(NSDictionary *)json {
    
   return [[self class] yy_modelWithJSON:json];
}

- (void)modelWithJson:(NSDictionary *)json {
    [self yy_modelSetWithJSON:json];
}

+ (NSArray *)modelArrayWithJson:(NSDictionary *)json {
    
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

@end
