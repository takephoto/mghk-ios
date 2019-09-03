//
//  MGWithdrawInputCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGWithdrawInputCell.h"

@implementation MGWithdrawInputCell
-(void)bindModel
{
    [RACObserve(self, model)subscribeNext:^(MGWithdrawModel *x) {
        self.availableLab.text = [NSString stringWithFormat:@"%@%@ %@ ~ %@ %@,%@ %@ %@",kLocalizedString(@"提现限额 "),kNotNumber(x.drawLow),kNotNull(x.tradeCode),kNotNumber(x.drawHigh),kNotNull(x.tradeCode),kLocalizedString(@"当日上限:"),kNotNumber(x.drawHigh),kNotNull(x.tradeCode)];
    }];
}

-(void)setUpViews{
    [super setUpViews];
    self.backgroundColor = kBgGrayColor;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(6));
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.numLab.text = kLocalizedString(@"提现数额(币数)");
    self.numTextFiled.placeholder = kLocalizedString(@"请输入提现数额");
    self.allBtn.hidden = YES;
    self.availableLab.font = H12;
    
}
@end
