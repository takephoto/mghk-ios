//
//  MGWithdrawPoundageCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGWithdrawPoundageCell.h"

@interface MGWithdrawPoundageCell()
@property (nonatomic, strong) UILabel *numberBgLab;
@end

@implementation MGWithdrawPoundageCell

-(void)bindModel
{
    [RACObserve(self, model)subscribeNext:^(MGWithdrawModel *x) {
        NSString *fee = [NSString stringWithFormat:@"%f",x.destructionRate *100];
        fee = fee.removeFloatAllZero;
        fee = string(fee, @"%");
        //destructionRate销毁率可能为空
        NSString *destructionRate = x.destructionRate>0 ? string(fee, @"+"):@"";
        self.numberBgLab.text = string(destructionRate,string( x.drawFee.length>0?x.drawFee:@"", x.feeUnit.length > 0?x.feeUnit:@""));
    }];
}

-(void)setUpViews
{
    self.backgroundColor = kBgGrayColor;
    self.contentView.backgroundColor = white_color;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(6.0));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-6));
    }];
    UILabel *priceLab = [[UILabel alloc]init];
    [self.contentView addSubview:priceLab];
    priceLab.textColor = kTextBlackColor;
    priceLab.text = kLocalizedString(@"手续费");
    priceLab.font = H15;
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(Adapted(15));
    }];
    
    UILabel *numberBgLab = [[UILabel alloc]init];
    [self.contentView addSubview:numberBgLab];
    numberBgLab.textColor = kTextBlackColor;
    numberBgLab.font = H15;
    [numberBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(16));
        make.bottom.mas_equalTo(Adapted(-16));
        make.left.mas_equalTo(Adapted(120));
        make.right.mas_equalTo(Adapted(-12));
        make.height.mas_equalTo(Adapted(42));
    }];
    self.numberBgLab = numberBgLab;
}
@end
