//
//  MNetworkTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -- Api请求参数
@interface ApiSetting : NSObject
@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSDictionary *paramer;
@end

#pragma mark -- Api请求结果
@interface ResponseData : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) NSDictionary *responseBody;
@property (nonatomic, copy) dispatch_block_t noDataBlock;
@property (nonatomic, copy) dispatch_block_t noMoreBlock;
@end

#pragma mark -- Api请求类
typedef void (^apiBlock)(ApiSetting *setting);
typedef void (^successBlock)(ResponseData *response);
typedef void (^failureBlock)(NSError *error);

@interface MNetworkTool : NSObject
+ (instancetype)sharedTool;

// 获取host地址
+ (NSString *)baseHost;

//get
+ (NSURLSessionDataTask *)mm_getWithApi:(apiBlock)apiBlock
                              success:(successBlock)successBlock
                              failure:(failureBlock)failureBlock;

- (NSURLSessionDataTask *)mm_getWithUrlStr:(NSString *)urlStr
                                   Paramer:(id)paramer
                                   Success:(successBlock)successBlock
                                   Failure:(failureBlock)failureBlock;

//post
+ (NSURLSessionDataTask *)mm_postWithApi:(apiBlock)apiBlock
                              success:(successBlock)successBlock
                              failure:(failureBlock)failureBlock;

- (NSURLSessionDataTask *)mm_postWithUrlStr:(NSString *)urlStr
                                    Paramer:(id)paramer
                                    Success:(successBlock)successBlock
                                    Failure:(failureBlock)failureBlock;

//delete
- (NSURLSessionDataTask *)mm_deleteWithUrlStr:(NSString *)urlStr
                                      Success:(successBlock)successBlock Failure:(failureBlock)failureBlock;

//图片上传接口
+ (NSURLSessionDataTask *)mm_uploadpicWithFile:(NSData *)file
                                    success:(successBlock)successBlock
                                    failure:(failureBlock)failureBlock;

//文件下载
+ (void)mm_downLoadWithFile:(NSString *)url
                    name:(NSString *)name
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;

// 获取网络状态
+ (void)mm_startMonitoring:(void (^)(AFNetworkReachabilityStatus status))block;
@end

NS_ASSUME_NONNULL_END
