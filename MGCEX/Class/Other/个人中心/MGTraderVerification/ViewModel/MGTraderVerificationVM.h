//
//  MGTraderVerificationVM.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseViewModel.h"
#import "MGTraderVerificationCellVM.h"


@interface MGTraderVerificationVM : BaseViewModel

// 导航标题
@property (nonatomic, strong) NSString *navTitleText;

// section标题
@property (nonatomic, strong) NSString *sectionTitleText;

// cell0标题
@property (nonatomic, strong) NSString *cell0TitleText;

// 协议
@property (nonatomic, strong) NSString *protocolText;

// 申请按钮文字
@property (nonatomic, strong) NSString *applyButtonText;

// footerView输入框文字
@property (nonatomic, strong) NSString *footerViewInputText;

// footerView的第一个子标题
@property (nonatomic, strong) NSString *footerViewSubTitle1Text;

// footerView的第二个子标题
@property (nonatomic, strong) NSString *footerViewSubTitle2Text;

// cellVM
@property (nonatomic, strong) NSMutableArray<MGTraderVerificationCellVM *> *cellVMs;

// 请求参数
@property (nonatomic, strong) NSString *nikeName;

// 获取数据信号
@property (nonatomic, strong) RACSignal *getFormerChartWaySignal;

// 获取商家认证状态
@property (nonatomic, strong) RACSignal *getForMerChartSignal;

// 提交数据信号
@property (nonatomic, strong) RACSignal *applySignal;

@property (nonatomic, assign) MGMerchantsApplyStatus applyStatus;

/**
 初始化

 @param sectionTitleText 审核不通过原因  (传@""不显示)
 @param  applyStatus
 @return self
 */
- (id)initWithSectionTitleText:(NSString *)sectionTitleText applyStatus:(MGMerchantsApplyStatus)applyStatus;



@end
