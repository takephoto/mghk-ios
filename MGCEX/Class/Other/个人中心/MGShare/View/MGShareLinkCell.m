//
//  MGShareLinkCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGShareLinkCell.h"
#import "UIButton+TWButton.h"
#import "MGShareVM.h"

@interface MGShareLinkCell ()

// 连接标题
@property (nonatomic, strong) UILabel *linkTitleLabel;

// 连接
@property (nonatomic, strong) UILabel *linkUrlLabel;

@end

@implementation MGShareLinkCell

#pragma mark -- Super Method

- (void)setUpViews
{
    self.backgroundColor = white_color;
    [self.contentView addSubview:self.linkTitleLabel];
    [self.contentView addSubview:self.linkUrlLabel];
    [self.contentView addSubview:self.copyButton];
    // 布局
    [self setupLayout];
}

#pragma mark -- Public Method

- (void)configWithViewModel:(MGShareVM *)viewModel
{
    self.linkTitleLabel.text = viewModel.linkTitleText;
    self.linkUrlLabel.text = viewModel.linkUrlText;
    [self.copyButton setTitle:viewModel.linkButtonTitleText forState:UIControlStateNormal];

}

#pragma mark -- Private Method

- (UILabel *)linkTitleLabel
{
    if (!_linkTitleLabel) {
        _linkTitleLabel = [[UILabel alloc] init];
        _linkTitleLabel.font = H15;
        _linkTitleLabel.textColor = kTextColor;
        _linkTitleLabel.numberOfLines = 0;
        _linkTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _linkTitleLabel;
}

- (UILabel *)linkUrlLabel
{
    if (!_linkUrlLabel) {
        _linkUrlLabel = [[UILabel alloc] init];
        _linkUrlLabel.font = H15;
        _linkUrlLabel.textColor = kTextColor;
        _linkUrlLabel.numberOfLines = 0;
        _linkUrlLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _linkUrlLabel;
}

- (UIButton *)copyButton
{
    if (!_copyButton) {
        _copyButton = [[UIButton alloc] init];
        _copyButton.backgroundColor = white_color;
        [_copyButton setTitleColor:kRedColor forState:UIControlStateNormal];
        [_copyButton setStatusWithEnableColor:white_color disableColor:k99999Color];
        [_copyButton setButtonCornerRadius:Adapted(18) borderColor:kRedColor borderWidth:1.0];
    }
    return _copyButton;
}

- (void)setupLayout
{
    [self.linkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(15));
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_greaterThanOrEqualTo(Adapted(15));
    }];
    
    [self.linkUrlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.linkTitleLabel.mas_bottom).offset(Adapted(25));
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_greaterThanOrEqualTo(Adapted(15));
    }];
    
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.linkUrlLabel.mas_bottom).offset(Adapted(20));
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_greaterThanOrEqualTo(Adapted(140));
        make.height.mas_greaterThanOrEqualTo(Adapted(36));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
}




@end
