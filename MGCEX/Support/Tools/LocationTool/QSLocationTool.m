//
/*! 文件信息

 * @project   MGCPay

 * @header    QSLocationTool.m

 * @abstract  描述

 * @author    Song

 * @version   1.00 2018/3/9

 * @copyright Copyright © 2018年 Joblee. All rights reserved..

*/

#import "QSLocationTool.h"
#import "TWAppTool.h"
#import <CoreLocation/CoreLocation.h>

@interface QSLocationTool ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, copy) void(^locationSuccess)(NSString *cityName,float latitude,float longitude);
@property (nonatomic, copy) void(^locationFailed)(void);
@end

@implementation QSLocationTool

singletonImplementation(QSLocationTool);

/**
 *  开始定位并放回城市名
 */
- (void)startLocationSuccess:(void (^)(NSString *cityName,float latitude,float longitude))successBlock failed:(void (^)(void))failedBlock
{
    // 判断用户是否在设置里面打开了位置服务功能
    if (![CLLocationManager locationServicesEnabled]) {
        // 通过代码跳到设置页面
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocalizedString(@"温馨提示") message:kLocalizedString(@"请在设置中打开定位功能") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertController addAction:action];
        
        UIViewController *currentVC = [TWAppTool currentViewController];
        [currentVC presentViewController:alertController animated:YES completion:nil];
    } else {
        // 创建管理者的对象
        locationManager = [[CLLocationManager alloc]init];

        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = 10;
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        locationManager.allowsBackgroundLocationUpdates = NO;
        
        // 开始定位
        [locationManager startUpdatingLocation];
    }
    
    if (successBlock) {
        self.locationSuccess = successBlock;
    }
    
    if (failedBlock) {
        self.locationFailed = failedBlock;
    }
}

/**
 *  定位成功
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
   
   
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             // 获取城市
             NSString *city = placemark.locality;
             
             if (!city) {
                 // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             if (self.locationSuccess) {
                 self.locationSuccess(city,coordinate.latitude,coordinate.longitude);
             }
             
         } else if (error == nil && [array count] == 0) {
             DLog(@"No results were returned.");
         } else if (error != nil) {
             DLog(@"An error occurred = %@", error);
         }
         
     }];
    
    [manager stopUpdatingLocation];
}

/**
 *  定位失败
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error
{
   
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        if (self.locationFailed) {
            self.locationFailed();
        }
    }
    
}
@end
