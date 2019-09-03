//
//  MGTraderVerificationFooterView.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationFooterView.h"
#import "MGTraderVerificationVM.h"
#import "NSString+QSExtension.h"
#import "UITextField+QSExtension.h"

@interface MGTraderVerificationFooterView ()

// 上部白色线
@property (nonatomic, strong) UIView *lineView;

// 内容视图
@property (nonatomic, strong) UIView *contentView;

// 输入框
@property (nonatomic, strong) UITextField *inputTextFiled;

// 子标题1
@property (nonatomic, strong) UILabel *subTitle1Label;

// 子标题2
@property (nonatomic, strong) UILabel *subTitle2Label;

@end

@implementation MGTraderVerificationFooterView

#pragma mark  -- Super Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.lineView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.inputTextFiled];
    [self.contentView addSubview:self.subTitle1Label];
    [self.contentView addSubview:self.subTitle2Label];
    // 布局
    [self setUpLayouts];
}

#pragma mark -- Public Method

- (void)congfigWithViewModel:(MGTraderVerificationVM *)viewModel
{
    self.inputTextFiled.placeholder = viewModel.footerViewInputText;
    self.subTitle1Label.text = viewModel.footerViewSubTitle1Text;
    self.subTitle2Label.text = viewModel.footerViewSubTitle2Text;
}

- (NSString *)getInputText
{
    return [self.inputTextFiled.text clearAllBlankStr];
}

#pragma mark -- Private Method

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineColor;
    }
    return _lineView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = white_color;
    }
    return _contentView;
}

- (UITextField *)inputTextFiled
{
    if (!_inputTextFiled) {
        _inputTextFiled = [[UITextField alloc] init];
        _inputTextFiled.textAlignment = NSTextAlignmentCenter;
        _inputTextFiled.borderStyle = UITextBorderStyleNone;
//        _inputTextFiled.layer.borderColor = RGBACOLOR(221, 221, 221, 1).CGColor;
//        _inputTextFiled.layer.borderWidth = 0.5;
        _inputTextFiled.font = H15;
        _inputTextFiled.limitTextLength = 8;
        
    }
    return _inputTextFiled;
}

- (UILabel *)subTitle1Label
{
    if (!_subTitle1Label) {
        _subTitle1Label = [[UILabel alloc] init];
        _subTitle1Label.textColor = k99999Color;
        _subTitle1Label.font = H13;
        _subTitle1Label.numberOfLines = 0;
        _subTitle1Label.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitle1Label;
}

- (UILabel *)subTitle2Label
{
    if (!_subTitle2Label) {
        _subTitle2Label = [[UILabel alloc] init];
        _subTitle2Label.textColor = k99999Color;
        _subTitle2Label.font = H13;
        _subTitle2Label.numberOfLines = 0;
        _subTitle2Label.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitle2Label;
}

- (void)setUpLayouts
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(68));
        make.right.mas_equalTo(Adapted(-68));
        make.top.mas_equalTo(Adapted(15));
        make.height.mas_equalTo(Adapted(40));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Adapted(68));
        make.right.mas_offset(Adapted(-68));
        make.top.mas_equalTo(self.inputTextFiled.mas_bottom).offset(0);
        make.height.mas_equalTo(Adapted(1));
    }];
    
    [self.subTitle1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self.inputTextFiled.mas_bottom).offset(15);
    }];
    
    [self.subTitle2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self.subTitle1Label.mas_bottom).offset(5);
        make.bottom.mas_equalTo(Adapted(-15));
    }];
}


@end
