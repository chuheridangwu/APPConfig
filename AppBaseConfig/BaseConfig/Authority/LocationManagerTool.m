//
//  LocationManagerTool.m
//  AppBaseConfig
//
//  Created by mlive on 2021/11/11.
//

#import "LocationManagerTool.h"

@interface LocationManagerTool ()<CLLocationManagerDelegate>
{
    CLLocationManager *_manager;
}

@property (nonatomic, copy) LocationBlock locationBlock;
@property (nonatomic, copy) NSStringBlock cityBlock;
@property (nonatomic, copy) NSStringBlock provinceBlock;//省
@property (nonatomic, copy) NSStringBlock addressBlock;
@property (nonatomic, copy) LocationErrorBlock errorBlock;
@property (nonatomic, copy) LocationAuthorizationBlock authorizationBlock;

@end

@implementation LocationManagerTool

+ (LocationManagerTool *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:KeyLastLongitude];
        float latitude = [standard floatForKey:KeyLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:KeyLastCity];
        self.lastAddress=[standard objectForKey:KeyLastAddress];
    }
    return self;
}

- (void) getLocationAuthorization:(LocationAuthorizationBlock)authorizationBlock{
    self.authorizationBlock = authorizationBlock;
    [self startLocation];
}

//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = locaiontBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withProvince:(NSStringBlock) provinceBlock
{
    self.locationBlock = locaiontBlock;
    self.provinceBlock = provinceBlock;
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = addressBlock;
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = cityBlock;
    [self startLocation];
}
- (void)getProvince:(NSStringBlock)provinceBlock
{
    self.provinceBlock = provinceBlock;
    [self startLocation];
}

#pragma mark -- 开始定位
-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestAlwaysAuthorization];
        _manager.distanceFilter = 100;
        [_manager startUpdatingLocation];
    }
    
}

#pragma mark -- 定位代理
// 权限发生变化
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    self.status = status;
    if (_authorizationBlock) {
        _authorizationBlock(status);
    }
    
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    if (@available(iOS 14.0, *)) {
        self.status = manager.authorizationStatus;
        if (_authorizationBlock) {
            _authorizationBlock(manager.authorizationStatus);
        }
    }
}

// 更新定位信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    float latitude = locations.firstObject.coordinate.latitude;
    float longitude = locations.firstObject.coordinate.longitude;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];


    __block typeof(self) ws = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             ws.lastCity = placemark.locality;
             ws.province = placemark.administrativeArea;//省
             [standard setObject:ws.lastCity forKey:KeyLastCity];//省市地址
             ws.lastAddress = placemark.name;
             NSLog(@"当前定位地址为: %@ -> %@",ws.lastCity,ws.lastAddress);
         }
         if (ws.cityBlock) {
             ws.cityBlock(ws.lastCity);
             ws.cityBlock = nil;
         }
         if (ws.addressBlock) {
             ws.addressBlock(ws.lastAddress);
             ws.addressBlock = nil;
         }
         if (ws.provinceBlock) {
             ws.provinceBlock(ws.province);
             ws.provinceBlock = nil;
         }
         
     }];
    
    

    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }

    NSLog(@"经纬度:%f--%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:KeyLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:KeyLastLongitude];

    [manager stopUpdatingLocation];
}
@end


#pragma mark -- 坐标转换扩展
void transform_earth_from_mars(double lat, double lng, double* tarLat, double* tarLng);
void transform_mars_from_baidu(double lat, double lng, double* tarLat, double* tarLng);
void transform_baidu_from_mars(double lat, double lng, double* tarLat, double* tarLng);

@implementation CLLocation (Location)

- (CLLocation*)locationMarsFromEarth
{
    double lat = 0.0;
    double lng = 0.0;
    transform_earth_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}

- (CLLocation*)locationEarthFromMars
{
    // 二分法查纠偏文件
    // http://xcodev.com/131.html
    return nil;
}

- (CLLocation*)locationBaiduFromMars
{
    double lat = 0.0;
    double lng = 0.0;
    transform_mars_from_baidu(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}

- (CLLocation*)locationMarsFromBaidu
{
    double lat = 0.0;
    double lng = 0.0;
    transform_baidu_from_mars(self.coordinate.latitude, self.coordinate.longitude, &lat, &lng);
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng)
                                         altitude:self.altitude
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:self.verticalAccuracy
                                           course:self.course
                                            speed:self.speed
                                        timestamp:self.timestamp];
}

@end

// --- transform_earth_from_mars ---
// 参考来源：https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

bool transform_sino_out_china(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transform_earth_from_mars_lat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transform_earth_from_mars_lng(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

void transform_earth_from_mars(double lat, double lng, double* tarLat, double* tarLng)
{
    if (transform_sino_out_china(lat, lng))
    {
        *tarLat = lat;
        *tarLng = lng;
        return;
    }
    double dLat = transform_earth_from_mars_lat(lng - 105.0, lat - 35.0);
    double dLon = transform_earth_from_mars_lng(lng - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *tarLat = lat + dLat;
    *tarLng = lng + dLon;
}

// --- transform_earth_from_mars end ---
// --- transform_mars_vs_bear_paw ---
// 参考来源：http://blog.woodbunny.com/post-68.html
const double x_pi = M_PI * 3000.0 / 180.0;

void transform_mars_from_baidu(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon)
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    *bd_lon = z * cos(theta) + 0.0065;
    *bd_lat = z * sin(theta) + 0.006;
}

void transform_baidu_from_mars(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon)
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}

