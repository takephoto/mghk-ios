//
//  MGTransferAccountCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTransferAccountCell.h"
@interface MGTransferAccountCell()
@property (nonatomic, strong) UILabel *fiatAccountLab;
@property (nonatomic, strong) UILabel *coinAccountLab;
@end
@implementation MGTransferAccountCell

-(void)bindModel
{
    @weakify(self);
    [RACObserve(self, type)subscribeNext:^(id x) {
        @strongify(self);
        NSArray *titleArr = @[kLocalizedString(@"C2C/B2C账户"),kLocalizedString(@"币币账户")];
        if ([self.type isEqualToString:@"ucc"]) {
            titleArr = @[kLocalizedString(@"币币账户"),kLocalizedString(@"C2C/B2C账户")];
        }
        self.fiatAccountLab.text = titleArr[0];
        self.coinAccountLab.text = titleArr[1];
    }];
}
- (void)setUpViews
{
    
    self.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = white_color;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(6.0));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(Adapted(48.0)));
        make.bottom.mas_equalTo(0);
    }];
    //法币账户
    UILabel *fiatAccountLab = [[UILabel alloc]init];
    
    fiatAccountLab.textColor = kTextColor;
    fiatAccountLab.font = H15;
    [self.contentView addSubview:fiatAccountLab];
    [fiatAccountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.bottom.mas_equalTo(Adapted(16.0));
    }];
    self.fiatAccountLab = fiatAccountLab;
    //图标
    UIImageView *imgv = [[UIImageView alloc]init];
    [imgv setImage:IMAGE(@"icon_transfer")];
    [self.contentView addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapted(12.0));
        make.height.mas_equalTo(Adapted(10.0));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(fiatAccountLab.mas_right).offset(Adapted(16.0));
    }];
    ///币币账户
    UILabel *coinAccountLab = [[UILabel alloc]init];
    
    coinAccountLab.textColor = kTextColor;
    coinAccountLab.font = H15;
    [self.contentView addSubview:coinAccountLab];
    [coinAccountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(imgv.mas_right).offset(Adapted(16.0));
    }];
    self.coinAccountLab = coinAccountLab;
    
}








@end
