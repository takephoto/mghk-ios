//
//  MGCoinIntroductionImageCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCoinIntroductionImageCell.h"

@interface MGCoinIntroductionImageCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation MGCoinIntroductionImageCell

- (void)setUpViews
{
    self.backgroundColor = kKLineBGColor;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];
    [self setUpLayout];
}

- (void)setUpLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(Adapted(20));
        make.width.mas_equalTo(Adapted(130));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(20);
        make.right.mas_offset(Adapted(-15));
    }];
}


#pragma mark -- Public Method

- (void)configWithModel:(MGKLinechartCoinInfoFillModel *)model
{
    self.titleLabel.text = model.title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlStr]];
}

#pragma mark -- 懒加载

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x89A0D6);
        _titleLabel.font = H15;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}


@end
