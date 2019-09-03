//
//  BuyFialDealTableViewCell.h
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"

@class PlaceOrderItemModel;
@interface BuyFialDealTableViewCell : BaseTableViewCell
@property (nonatomic, strong) PlaceOrderItemModel *model;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, copy) void(^enterBlock)(NSString *text);
@property (nonatomic, copy) void(^endEditBlock)(NSString *text);
@end
