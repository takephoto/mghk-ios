//
//  MGPaymentInfoCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/28.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGPaymentInfoCell.h"

@implementation MGPaymentInfoCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * infoTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:infoTitleLabel];
    [infoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Adapted(15));
        make.width.mas_equalTo(Adapted(130));
        make.centerY.mas_equalTo(self.contentView);
    }];
    infoTitleLabel.textColor = kTextColor;
    infoTitleLabel.font = H15;
    self.infoTitleLabel = infoTitleLabel;
    
    UILabel * infoLabel = [[UILabel alloc]init];
    [self.contentView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Adapted(156));
        make.right.mas_equalTo(self.contentView).offset(Adapted(-15));
        make.centerY.mas_equalTo(self.contentView);
    }];
    infoLabel.textColor = kTextColor;
    infoLabel.font = H15;
    infoLabel.numberOfLines = 0;
    self.infoLabel = infoLabel;
    
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

@end
