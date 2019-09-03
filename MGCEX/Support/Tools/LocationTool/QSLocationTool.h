//
/*! 文件信息

 * @project   MGCPay

 * @header    QSLocationTool.h

 * @abstract  描述

 * @author    Song

 * @version   1.00 2018/3/9

 * @copyright Copyright © 2018年 Joblee. All rights reserved..

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSLocationTool : NSObject
singletonInterface(QSLocationTool);

/**
 *  开始定位并返回城市名
 */
- (void)startLocationSuccess:(void (^)(NSString *cityName,float latitude,float longitude))successBlock failed:(void (^)(void))failedBlock;
@end
