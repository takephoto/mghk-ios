//
//  MGPaymentInfoCell.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/28.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MGPaymentInfoCell : BaseTableViewCell

// 分割线
@property (nonatomic, strong) UIView * lineView;
// 左边标题
@property (nonatomic, strong) UILabel *infoTitleLabel;
// 右边信息
@property (nonatomic, strong) UILabel *infoLabel;

@end
