//
//  LocationManagerTool.h
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//  定位权限

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *KeyLastLongitude = @"KeyLastLongitude";
static NSString *KeyLastLatitude = @"KeyLastLatitude";
static NSString *KeyLastCity = @"KeyLastCity";
static NSString *KeyLastAddress = @"KeyLastAddress";


typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *addresString);
typedef void (^LocationAuthorizationBlock)(CLAuthorizationStatus status);

@interface LocationManagerTool : NSObject
@property (nonatomic,assign) CLLocationCoordinate2D lastCoordinate; // 定位信息
@property (nonatomic,assign) CLAuthorizationStatus status; // 定位状态

@property (nonatomic,strong)NSString *lastCity; // 市
@property (nonatomic, copy) NSString* province; //省
@property (nonatomic,strong) NSString *lastAddress; //具体地址

@property(nonatomic,assign)float latitude; // 维度
@property(nonatomic,assign)float longitude; // 经度

+ (LocationManagerTool *)shareLocation;

// 获取定位状态
- (void) getLocationAuthorization:(LocationAuthorizationBlock)authorizationBlock ;

 // 获取坐标
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock ;

//  获取坐标和详细地址
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

// 获取坐标和省地址
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withProvince:(NSStringBlock) provinceBlock;

// 获取详细地址
- (void) getAddress:(NSStringBlock)addressBlock;

// 获取城市
- (void) getCity:(NSStringBlock)cityBlock;

// 获取省
- (void) getProvince:(NSStringBlock)provinceBlock;

@end



/*
 从 CLLocationManager 取出来的经纬度放到 mapView 上显示，是错误的!
 从 CLLocationManager 取出来的经纬度去 Google Maps API 做逆地址解析，当然是错的！
 从 MKMapView 取出来的经纬度去 Google Maps API 做逆地址解析终于对了。去百度地图API做逆地址解析，依旧是错的！
 从上面两处取的经纬度放到百度地图上显示都是错的！错的！的！
 
 分为 地球坐标，火星坐标（iOS mapView 高德 ， 国内google ,搜搜、阿里云 都是火星坐标），百度坐标(百度地图数据主要都是四维图新提供的)
 
 火星坐标: MKMapView
 地球坐标: CLLocationManager
 
 当用到CLLocationManager 得到的数据转化为火星坐标, MKMapView不用处理
 
 
 API                坐标系
 百度地图API         百度坐标
 腾讯搜搜地图API      火星坐标
 搜狐搜狗地图API      搜狗坐标
 阿里云地图API       火星坐标
 图吧MapBar地图API   图吧坐标
 高德MapABC地图API   火星坐标
 灵图51ditu地图API   火星坐标
 
 */

@interface CLLocation (Location)

//从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;
@end

NS_ASSUME_NONNULL_END
