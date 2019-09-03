//
//  YWChooseAddressView.h
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWChooseAddressView;

@interface YWChooseAddressView : UIView

@property (nonatomic, copy) void(^chooseFinish)(NSString *address,NSString * province,NSString * city,NSString *  district);

//重新打开时，默认上次选中的省市区
-(void)upDataTableViewsProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

-(void)show;
- (void)dismiss;

@end
