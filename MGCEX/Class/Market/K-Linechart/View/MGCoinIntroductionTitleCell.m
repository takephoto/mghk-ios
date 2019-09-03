//
//  MGCoinIntroductionTitleCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCoinIntroductionTitleCell.h"

@interface MGCoinIntroductionTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MGCoinIntroductionTitleCell

- (void)setUpViews
{
    self.backgroundColor = kKLineBGColor;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self setUpLayout];
}

- (void)setUpLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(Adapted(130));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(150));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
}

- (void)configWithModel:(MGKLinechartCoinInfoFillModel *)model
{
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    if(model.cellType == CoinInfoFillBigTitleCellType){
        self.titleLabel.textColor = white_color;
        self.titleLabel.font = H18;
    } else {
        self.titleLabel.textColor = UIColorFromRGB(0x89A0D6);
        self.titleLabel.font = H14;
    }
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


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = white_color;
        _contentLabel.font = H14;
        _contentLabel.numberOfLines = 0;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel;
}


@end
