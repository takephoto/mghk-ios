//
//  MGTraderVerificationBottomView.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"

@class MGTraderVerificationVM;

@interface MGTraderVerificationBottomView : BaseView

@property (nonatomic, strong) UIButton *checkButton;

@property (nonatomic, strong) UILabel *protocolLabel;

@property (nonatomic, strong) UIButton *applyButton;

- (void)congfigWithViewModel:(MGTraderVerificationVM *)viewModel;

@end
