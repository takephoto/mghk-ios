//
//  MGComplainVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGComplainModel.h"
@interface MGComplainVM : NSObject
///提交申诉
@property (nonatomic, copy) RACSignal *commitComplainSignal;

///上传多张图片
@property (nonatomic, strong) RACSignal *uploadImagesSignal;
///图片数组
@property (nonatomic, strong) NSMutableArray *imageArr;
///上传图片返回model
@property (nonatomic, strong) MGComplainModel *model;

@property (nonatomic, strong) NSString *fiatDealTradeOrderId;
@property (nonatomic, strong) NSString *sellBuy;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankBrachName;
@property (nonatomic, strong) NSString *payeeAccount;
@property (nonatomic, strong) NSString *payeeAccountUrl;
@property (nonatomic, strong) NSString *evidenceAUrl;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *payeeName;
@property (nonatomic, strong) NSString *transactionNum;
@end

