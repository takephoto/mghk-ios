//
//  MGKLinechartCoinInfoModel.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

// 币种返回模型
@interface MGKLinechartCoinInfoModel : NSObject

// 货币图标
@property (nonatomic, strong) NSString *logoUrl;
// 项目全称
@property (nonatomic, strong) NSString *shortName;
// 币种所在区域 1是主区2是创新区
@property (nonatomic, assign) NSInteger area;
// 项目简称
@property (nonatomic, strong) NSString *tradeCode;
// 项目定位
@property (nonatomic, strong) NSString *orientation;
// 众筹起始时间
@property (nonatomic, strong) NSString *benTime;
// 众筹结束时间
@property (nonatomic, strong) NSString *endTime;
// 成功众筹数量
@property (nonatomic, strong) NSString *numbers;
// 众筹均价
@property (nonatomic, strong) NSString *avgPrice;
// 项目介绍
@property (nonatomic, strong) NSString *introduction;
// 网站
@property (nonatomic, strong) NSString *website;
// 项目白皮书
@property (nonatomic, strong) NSString *whitePaper;
// 社交媒体以及社区
@property (nonatomic, strong) NSString *community;
// 融资状况
@property (nonatomic, strong) NSString *situation;


@end
