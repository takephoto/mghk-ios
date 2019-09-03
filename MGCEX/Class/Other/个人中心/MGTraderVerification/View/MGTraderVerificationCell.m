//
//  MGTraderVerificationCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationCell.h"
#import "MGTraderVerificationCellVM.h"

@interface MGTraderVerificationCell ()

// 背景图片
@property (nonatomic, strong) UIView *bgView;

// 背景图片
@property (nonatomic, strong) UIImageView *bgIconImageView;

// icon图标
@property (nonatomic, strong) UIImageView *iconImageView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 子标题1
@property (nonatomic, strong) UILabel *subTitle1Label;

// 子标题2
@property (nonatomic, strong) UILabel *subTitle2Label;

@end

@implementation MGTraderVerificationCell


#pragma mark  -- Super Method

- (void)setUpViews
{
    self.backgroundColor = white_color;
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.iconImageView];
   // [self.bgView addSubview:self.bgIconImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.subTitle1Label];
    [self.bgView addSubview:self.subTitle2Label];
    // 布局
    [self setUpLayouts];
}

#pragma mark -- Public Method

- (void)congfigWithViewModel:(MGTraderVerificationCellVM *)cellViewModel
{
    [self.bgIconImageView setImage:cellViewModel.bgImage];
    [self.iconImageView setImage:cellViewModel.iconImage];
    self.titleLabel.text = cellViewModel.titleText;
    self.subTitle1Label.text = cellViewModel.subTitle1Text;
    self.subTitle2Label.text = cellViewModel.subTitle2Text;
}


#pragma mark -- Private Method

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = white_color;
    }
    return _bgView;
}

- (UIImageView *)bgIconImageView
{
    if (!_bgIconImageView) {
        _bgIconImageView = [[UIImageView alloc] init];
    }
    return _bgIconImageView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = H15;
        _titleLabel.textColor = kTextColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitle1Label
{
    if (!_subTitle1Label) {
        _subTitle1Label = [[UILabel alloc] init];
        _subTitle1Label.textColor = kTextColor;
        _subTitle1Label.font = H13;
        _subTitle1Label.numberOfLines = 0;
        _subTitle1Label.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitle1Label;
}

- (UILabel *)subTitle2Label
{
    if (!_subTitle2Label) {
        _subTitle2Label = [[UILabel alloc] init];
        _subTitle2Label.textColor = kTextColor;
        _subTitle2Label.font = H13;
        _subTitle2Label.numberOfLines = 0;
        _subTitle2Label.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitle2Label;
}

- (void)setUpLayouts
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-6));
    }];
    
//    [self.bgIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.width.height.mas_equalTo(100);
//    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(30));
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(Adapted(56));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(Adapted(25));
    }];
    
    [self.subTitle1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.subTitle2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.subTitle1Label.mas_bottom).offset(10);
        make.bottom.mas_equalTo(Adapted(-21));
    }];
}


@end
