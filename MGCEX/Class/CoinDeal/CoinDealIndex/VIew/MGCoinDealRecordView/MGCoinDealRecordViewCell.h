//
//  MGCoinDealRecordViewCell.h
//  TestDemo
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "UnsettledGearModel.h"

@interface MGCoinDealRecordViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *numberBgLab;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UnsettledGearModel * model;
@end
