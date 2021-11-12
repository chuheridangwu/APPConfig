//
//  MParsingTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//

#import "MParsingTool.h"

@implementation MParsingTool
+ (instancetype)mm_modelWithJson:(NSDictionary *)json {
    
   return [[self class] yy_modelWithJSON:json];
}

- (void)mm_modelWithJson:(NSDictionary *)json {
    [self yy_modelSetWithJSON:json];
}

+ (NSArray *)mm_modelArrayWithJson:(NSDictionary *)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}
@end
