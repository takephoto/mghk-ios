//
//  MGTraderVerificationFooterView.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"

@class MGTraderVerificationVM;

@interface MGTraderVerificationFooterView : BaseView


- (void)congfigWithViewModel:(MGTraderVerificationVM *)viewModel;

- (NSString *)getInputText;

@end
