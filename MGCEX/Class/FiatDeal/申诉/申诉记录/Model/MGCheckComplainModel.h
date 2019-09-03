//
//  MGCheckComplainModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGCheckComplainModel : NSObject
@property (nonatomic, strong) NSString *bankBrachName;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *lawsuitRecordId;
@property (nonatomic, strong) NSString *fiatDealTradeOrderId;
///1、银行卡 2、支付宝 3、微信
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSString *retStatus;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *payeeAccount;
@property (nonatomic, strong) NSString *payeeName;
@property (nonatomic, strong) NSString *transactionNum;
///图片数组
@property (nonatomic, strong) NSArray *payeeAccountUrl;
@end
//
//{
//    "code": 1,
//    "msg": "操作完成",
//    "data": {
//        "summary": "你开心就好",
//        "bankBrachName": "深圳正大",
//        "payType": 1,
//        "retStatus": 1,
//        "evidenceVideoUrl": "http://192.168.22.24:8021/null",
//        "bankName": "正大银行",
//        "payeeAccount": null,
//        "payeeAccountUrl": "http://192.168.22.24:8021/22.jpg",
//        "fiatDealTradeOrderId": "1528200836363865145"
//        }
