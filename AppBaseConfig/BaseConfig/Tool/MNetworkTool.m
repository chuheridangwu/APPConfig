//
//  MNetworkTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//

#import "MNetworkTool.h"


@implementation ApiSetting
@end

@implementation ResponseData
@end

@interface MNetworkTool()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation MNetworkTool

+ (instancetype)sharedTool {
    static MNetworkTool *singleton;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        singleton.manager = [singleton AFNConfig];
    });
    
    return  singleton;
}

+ (NSString *)baseHost{
    return @"http://w.vm6.cc"; //正式
}

//get
+ (NSURLSessionDataTask *)mm_getWithApi:(apiBlock)apiBlock
                              success:(successBlock)successBlock
                              failure:(failureBlock)failureBlock {

    ApiSetting *setting = [ApiSetting new];
    apiBlock(setting);
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithDictionary:setting.paramer];

    return [[self sharedTool] mm_getWithUrlStr:setting.api Paramer:paramer Success:^(id responseBody) {
                
        ResponseData *data = [ResponseData yy_modelWithJSON:responseBody];
        if (!data) {
            data = [ResponseData new];
        }
        data.responseBody = responseBody;
        
        !successBlock ?: successBlock(data);
        
    } Failure:^(NSError *error) {
        
        !failureBlock ?: failureBlock(error);
        
    }];
}

- (NSURLSessionDataTask *)mm_getWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock {

    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"当前Get请求: url-> :%@%@",urlStr,[self changeStringWithDict:paramer withUrl:urlStr]);

    NSDictionary *headers = @{};
    
    NSURLSessionDataTask *task = [self.manager GET:urlStr parameters:paramer headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"url:%@ \n responseBody:%@", urlStr, responseObject);

        if (successBlock) {
            successBlock(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
    NSLog(@"请求头信息:%@\n",task.originalRequest.allHTTPHeaderFields);
    
    return task;
}


//post
+ (NSURLSessionDataTask *)mm_postWithApi:(apiBlock)apiBlock
                              success:(successBlock)successBlock
                              failure:(failureBlock)failureBlock {

    ApiSetting *setting = [ApiSetting new];
    apiBlock(setting);
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithDictionary:setting.paramer];

    return [[self sharedTool] mm_postWithUrlStr:setting.api Paramer:paramer Success:^(id responseBody) {
        
        ResponseData *data = [ResponseData yy_modelWithJSON:responseBody];
        if (!data) {
            data = [ResponseData new];
        }
        data.responseBody = responseBody;
        
        !successBlock ?: successBlock(data);
        
    } Failure:^(NSError *error) {

        !failureBlock ?: failureBlock(error);
    }];
}

- (NSURLSessionDataTask *)mm_postWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock {

    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"当前Post请求: url-> :%@%@",urlStr,[self changeStringWithDict:paramer withUrl:urlStr]);


    NSDictionary *headers = @{};
    
    return [self.manager POST:urlStr parameters:paramer headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"url:%@ \n responseBody:%@", urlStr, responseObject);

        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}



//图片上传接口
+ (NSURLSessionDataTask *)mm_uploadpicWithFile:(NSData *)file
                                    success:(successBlock)successBlock
                                    failure:(failureBlock)failureBlock {

    NSDateFormatter* dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *filename = [dateFormat stringFromDate:[NSDate date]];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@&source=ios&shop_url=shop262&source_key=%@&filetype=img&filename=%@&format=jpg&token=%@",API_HOST,@"uploadfile.htm?",XUserShared.deviceInfo.deviceId,filename,XUserShared.userInfo.token];
    NSString *urlString = @"上传图片接口地址";
    NSDictionary *param = @{};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    return [manager POST:urlString parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:file name:@"file" fileName:filename mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ResponseData *data = [ResponseData yy_modelWithJSON:responseObject];
        if (!data) {
            data = [ResponseData new];
        }
        data.responseBody = responseObject;
        
        !successBlock ?: successBlock(data);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failureBlock ?: failureBlock(error);
    }];

}


//文件下载
+ (void)mm_downLoadWithFile:(NSString *)url
                    name:(NSString *)name
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
                
        NSString *fullPath = [filePath stringByAppendingPathComponent:name];
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                !failureBlock ?: failureBlock(error);
            } else {
                
                ResponseData *data = [ResponseData new];
                data.data = @{@"filePath" : filePath};
                !successBlock ?: successBlock(data);

            }

        });

    }];
    
    [downTask resume];
}


- (NSURLSessionDataTask *)mm_deleteWithUrlStr:(NSString *)urlStr Success:(successBlock)successBlock Failure:(failureBlock)failureBlock {

    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSDictionary *headers = @{};
    
    return [self.manager DELETE:urlStr parameters:0 headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ResponseData *data = [ResponseData yy_modelWithJSON:responseObject];
        if (!data) {
            data = [ResponseData new];
        }
        data.responseBody = responseObject;
        !successBlock ?: successBlock(data);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
}


+ (void)mm_startMonitoring:(void (^)(AFNetworkReachabilityStatus status))block {
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        !block ?: block(status);
    }];
    [mgr startMonitoring];
}

#pragma mark -- 懒加载
- (AFHTTPSessionManager *)AFNConfig {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",@"multipart/form-data", nil];
    return manager;
}

- (NSString*)changeStringWithDict:(NSDictionary*)dict withUrl:(NSString*)url{
    if ([dict isEqual:[NSNull class]]) {
        return @"";
    }
    NSMutableString *str = [NSMutableString stringWithFormat:@"?"];
    if ([url containsString:@"?"]) {
        str = [NSMutableString stringWithFormat:@"&"];
    }
    if (dict.count) {
        for (NSString *key in dict) {
            NSString *value = dict[key];
            NSString *subString = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
            str = [NSMutableString stringWithFormat:@"%@",subString];
        }
    }
    return str;
}
@end
