//
//  MGEntrustCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "CoinEntrustModelList.h"

@interface MGEntrustCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CoinEntrustModelList * model;
@end
