//
//  NSArray+Method.m
//  yaho
//
//  Created by mlive on 2021/10/19.
//

#import "NSArray+Method.h"

@implementation NSArray (Method)
- (NSString *)mm_arrayToJsonString{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
}

@end
