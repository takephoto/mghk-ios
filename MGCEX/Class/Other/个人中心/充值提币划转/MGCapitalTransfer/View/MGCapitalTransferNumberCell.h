//
//  MGCapitalTransferNumberCell.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MGCapitalTransferVM.h"

@interface MGCapitalTransferNumberCell : BaseTableViewCell

@property (nonatomic, strong) UITextField *numberTextFiled;

@property (nonatomic, strong) UIButton *allTransferButton;


- (void)configWithViewModel:(MGCapitalTransferVM *)viewModel;

@end
