//
//  NSData+Encryption.m
//  AppBaseConfig
//
//  Created by mlive on 2021/9/15.
//

#import "NSData+Encryption.h"

#import <CommonCrypto/CommonCryptor.h>

#define RSA_KEY_BASE64 @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgSVx9ny4+OfS+6ak/l3YtPIT1 \
k0KVHUoTkHn06VxcvlQNwLmZpiZGaqlTCl5Im2fyFbUlnnts4IgsWEhY9GZPtjM5 \
1rrFEEef7ZS1PEHMxomyAsRnDXt06ok/9Cc9pY0xAJGk70mgIaebrIw0pMXG5Q40 \
HI4T94Oq5VemM6BeHQIDAQAB"

const char ivBytes[] =
{
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};
const char ivBytesOld[] = // 这个值不知道有没有用了现在
{
    0x65, 0x45, 0x41, 0x22, 0x00, 0x00, 0x78, 0x00, 0x67, 0x35, 0x38, 0x11, 0x00, 0x45, 0x15, 0x00
};
static SecKeyRef _public_key=nil;

@implementation NSData (Encryption)
- (NSData *)mm_AES256ParmEncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
      bzero(keyPtr, sizeof(keyPtr));
      [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      NSUInteger dataLength = [self length];
      size_t bufferSize = dataLength + kCCBlockSizeAES128;
      void *buffer = malloc(bufferSize);
      size_t numBytesEncrypted = 0;
      CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCKeySizeAES256,
                                            NULL,
                                            [self bytes], dataLength,
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
      if (cryptStatus == kCCSuccess) {
          return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
      }
      free(buffer);
      return nil;
}


- (NSData *)mm_AES256ParmDecryptWithKey1:(NSString *)key   //解密
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          ivBytes /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

-(NSData *)mm_DESencryptWithKey:(NSString *)key
{
    return [self encrypt:kCCEncrypt key:key];
}

-(NSData *)mm_DESdecryptWithKey:(NSString *)key
{
    return [self encrypt:kCCDecrypt key:key];
}

- (NSData *)encrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    size_t dataInLength;
    dataInLength = [self length];
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [key UTF8String];
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,
                       NULL, //  可选的初始矢量
                       [self bytes], // 数据的存储单元
                       [self length],// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    if (ccStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:dataOut length:dataOutMoved];
    }
    free(dataOut);
    return nil;
}
- (SecKeyRef)getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    if(_public_key == nil){
        
        NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key"ofType:@"der"];
        if (publicKeyPath == nil) {
            NSLog(@"Can not find pub.der");
            return nil;
        }
        NSData *publicKeyFileContent = [[NSData alloc] initWithContentsOfFile:publicKeyPath];
        if (publicKeyFileContent == nil) {
            NSLog(@"Can not read from pub.der");
            return nil;
        }
        //   NSData *certificateData = [GTMBase64 decodeString:RSA_KEY_BASE64];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)publicKeyFileContent);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

- (NSData*)mm_rsaEncryptString{
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([self length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i=0; i<blockCount; i++) {
        unsigned long bufferSize = MIN(blockSize,[self length] - i * blockSize);
        NSData *buffer = [self subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    return encryptedData;
}

//(key和iv向量这里是16位的) 这里是CBC加密模式，安全性更高
- (NSData *)mm_AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv{//加密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)mm_AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv{//解密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)mm_UTF8Data {
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:self.length];
    
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = self.bytes;
    
    long dataLength = (long) self.length;
    
    while (index < dataLength) {
        uint8_t len = 0;
        uint8_t firstChar = bytes[index];
        
        // 1个字节
        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
            len = 1;
        }
        // 2字节
        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
            if (index + 1 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                if (0x80 <= secondChar && secondChar <= 0xBF) {
                    len = 2;
                }
            }
        }
        // 3字节
        else if ((firstChar & 0xF0) == 0xE0) {
            if (index + 2 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                
                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                    len = 3;
                }
            }
        }
        // 4字节
        else if ((firstChar & 0xF8) == 0xF0) {
            if (index + 3 < dataLength) {
                uint8_t secondChar = bytes[index + 1];
                uint8_t thirdChar = bytes[index + 2];
                uint8_t fourthChar = bytes[index + 3];
                
                if (firstChar == 0xF0) {
                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                } else if (firstChar == 0xF3) {
                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                        len = 4;
                    }
                }
            }
        }
        // 5个字节
        else if ((firstChar & 0xFC) == 0xF8) {
            len = 0;
        }
        // 6个字节
        else if ((firstChar & 0xFE) == 0xFC) {
            len = 0;
        }
        
        if (len == 0) {
            index++;
            [resData appendData:replacement];
        } else {
            [resData appendBytes:bytes + index length:len];
            index += len;
        }
    }
    return resData;
}
@end
