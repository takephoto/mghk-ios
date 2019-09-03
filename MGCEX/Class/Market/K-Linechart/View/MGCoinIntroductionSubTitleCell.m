//
//  MGCoinIntroductionSubTitleCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCoinIntroductionSubTitleCell.h"

@interface MGCoinIntroductionSubTitleCell ()

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 子内容
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation MGCoinIntroductionSubTitleCell

- (void)setUpViews
{
    self.backgroundColor = kKLineBGColor;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self setUpLayout];
}

- (void)setUpLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(Adapted(15));
        make.width.mas_equalTo(Adapted(130));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(Adapted(14));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
}

- (void)configWithModel:(MGKLinechartCoinInfoFillModel *)model
{
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}

#pragma mark -- 懒加载

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x89A0D6);
        _titleLabel.font = H14;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = white_color;
        _subTitleLabel.font = H14;
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}


@end

