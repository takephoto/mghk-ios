//
//  MGShareLinkCell.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"

@class MGShareVM;

@interface MGShareLinkCell : BaseTableViewCell

// 按钮
@property (nonatomic, strong) UIButton *copyButton;

- (void)configWithViewModel:(MGShareVM *)viewModel;

@end
