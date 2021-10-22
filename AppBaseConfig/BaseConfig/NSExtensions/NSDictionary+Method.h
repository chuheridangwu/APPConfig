//
//  NSDictionary+Method.h
//  yaho
//
//  Created by mlive on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Method)
/// 字典转json格式字符串：
- (NSString*)mm_dictionaryToJsonString;
@end

NS_ASSUME_NONNULL_END
