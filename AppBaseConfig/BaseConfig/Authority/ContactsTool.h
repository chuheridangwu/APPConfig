//
//  ContactsTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/10/29.
//  通讯录权限

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactsTool : NSObject

/**
请求通讯录权限
 @param deniedBlock  用户拒绝
 @param addres  获取通讯录数据，以字典形式保存
 */
+ (void)mm_requestContacts:(void(^)(void))deniedBlock addres:(void(^)(NSArray*))addres;

@end

NS_ASSUME_NONNULL_END
