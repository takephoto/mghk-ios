//
//  MGWithdrawTVCCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGWithdrawTVCCell : BaseTableViewCell
@property (nonatomic, strong) UITextField * numTextFiled;
@property (nonatomic, strong) UIView * lineView;
//划转数量
@property (nonatomic, strong) UILabel *numLab;
@end
