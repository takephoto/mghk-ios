//
//  MGShareQRCodeCell.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HGDQQRCodeView.h"

@class MGShareVM;

@interface MGShareQRCodeCell : BaseTableViewCell

// 二维码视图
@property (nonatomic, strong) HGDQQRCodeView *qrCodeView;

// 按钮
@property (nonatomic, strong) UIButton *qrCodeButton;

- (void)configWithViewModel:(MGShareVM *)viewModel;

@end
