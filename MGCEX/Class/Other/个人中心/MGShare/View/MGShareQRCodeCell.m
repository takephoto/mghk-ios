//
//  MGShareQRCodeCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGShareQRCodeCell.h"
#import "MGShareVM.h"

@interface MGShareQRCodeCell ()

// 二维码标题
@property (nonatomic, strong) UILabel *qrCodeTitleLabel;

// 背景图
@property (nonatomic, strong) UIImageView *qrCodeImageView;



@end

@implementation MGShareQRCodeCell


#pragma mark -- Super Method

- (void)setUpViews
{
    self.backgroundColor = white_color;
    [self.contentView addSubview:self.qrCodeTitleLabel];
    [self.contentView addSubview:self.qrCodeImageView];
    [self.contentView addSubview:self.qrCodeButton];
    // 布局
    [self setupLayout];
}

#pragma mark -- Public Method

- (void)configWithViewModel:(MGShareVM *)viewModel
{
    self.qrCodeTitleLabel.text = viewModel.qrCodeTitleText;
    [self.qrCodeButton setTitle:viewModel.qrCodeButtonTitleText forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     self.qrCodeView = [HGDQQRCodeView creatQRCodeWithURLString:viewModel.qrCodeUrlText superView:self.qrCodeImageView logoImage:[UIImage imageNamed:@"40"] logoImageSize:CGSizeMake(Adapted(30), Adapted(30)) logoImageWithCornerRadius:0];
    });
}

#pragma mark -- Private Method

- (UILabel *)qrCodeTitleLabel
{
    if (!_qrCodeTitleLabel) {
        _qrCodeTitleLabel = [[UILabel alloc] init];
        _qrCodeTitleLabel.font = H15;
        _qrCodeTitleLabel.textColor = kBackAssistColor;
        _qrCodeTitleLabel.numberOfLines = 0;
        _qrCodeTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _qrCodeTitleLabel;
}

- (UIImageView *)qrCodeImageView
{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
        _qrCodeImageView.userInteractionEnabled = YES;
    }
    return _qrCodeImageView;
}

- (UIButton *)qrCodeButton
{
    if (!_qrCodeButton) {
        _qrCodeButton = [[UIButton alloc] init];
        _qrCodeButton.backgroundColor = white_color;
        [_qrCodeButton setTitleColor:kRedColor forState:UIControlStateNormal];
        [_qrCodeButton setStatusWithEnableColor:white_color disableColor:k99999Color];
        [_qrCodeButton setButtonCornerRadius:Adapted(18) borderColor:kRedColor borderWidth:1.0];
    }
    return _qrCodeButton;
}

- (void)setupLayout
{
    [self.qrCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(15));
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_greaterThanOrEqualTo(Adapted(15));
    }];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrCodeTitleLabel.mas_bottom).offset(Adapted(25));
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(Adapted(140));
        make.height.mas_equalTo(Adapted(140));
    }];
    
    [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrCodeImageView.mas_bottom).offset(Adapted(20));
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_greaterThanOrEqualTo(Adapted(140));
        make.height.mas_greaterThanOrEqualTo(Adapted(36));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
}


@end
