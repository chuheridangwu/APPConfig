//
//  NSDictionary+Method.m
//  yaho
//
//  Created by mlive on 2021/10/19.
//

#import "NSDictionary+Method.h"

@implementation NSDictionary (Method)
//字典转json格式字符串：
- (NSString*)mm_dictionaryToJsonString{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
