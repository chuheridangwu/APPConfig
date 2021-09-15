//
//  NSData+Encryption.h
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encryption)
- (NSData *)mm_AES256ParmEncryptWithKey:(NSString *)key;   //加密
- (NSData *)mm_AES256ParmDecryptWithKey1:(NSString *)key;   //解密

- (NSData *)mm_DESencryptWithKey:(NSString *)key;//加密
- (NSData *)mm_DESdecryptWithKey:(NSString *)key;//解密

- (NSData*)mm_rsaEncryptString;//RSA加密

- (NSData *)mm_UTF8Data;

//AES128
- (NSData *)mm_AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv;
- (NSData *)mm_AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv;
@end

NS_ASSUME_NONNULL_END
