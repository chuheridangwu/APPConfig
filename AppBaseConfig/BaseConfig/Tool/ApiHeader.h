//
//  ApiHeader.h
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//

#ifndef ApiHeader_h
#define ApiHeader_h

#define BASE_HOST  [MNetworkTool baseHost]
#define kCommitBaseHost(url)   [NSString stringWithFormat:@"%@%@",BASE_HOST,url]

// 示例接口
#define GET_AppConfig  kCommitBaseHost(@"/api/video/params2") // 获取配置

#endif /* ApiHeader_h */
