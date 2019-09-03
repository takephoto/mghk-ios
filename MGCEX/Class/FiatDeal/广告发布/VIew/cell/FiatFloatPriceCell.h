//
//  FiatFloatPriceCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/20.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface FiatFloatPriceCell : BaseTableViewCell
//左边图片按钮
@property (nonatomic, strong) UIButton * logImageBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, copy) void(^selectBlock)(BOOL selected);
@end
