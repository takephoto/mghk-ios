//
//  MGTraderVerificationBottomView.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationBottomView.h"
#import "MGTraderVerificationVM.h"

@interface MGTraderVerificationBottomView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation MGTraderVerificationBottomView

#pragma mark  -- Super Method

-(void)setupSubviews
{
    [self addSubview:self.lineView];
    [self addSubview:self.checkButton];
    [self addSubview:self.protocolLabel];
    [self addSubview:self.applyButton];
    // 布局
    [self setUpLayouts];
}

#pragma mark -- Public Method

- (void)congfigWithViewModel:(MGTraderVerificationVM *)viewModel
{
    self.protocolLabel.text = viewModel.protocolText;
    [self.applyButton setTitle:viewModel.applyButtonText forState:UIControlStateNormal];
}


#pragma mark -- Private Method

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return _lineView;
}

- (UIButton *)checkButton
{
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setImage:IMAGE(@"icon_choice_off") forState:UIControlStateNormal];
        [_checkButton setImage:IMAGE(@"icon_choice_on") forState:UIControlStateSelected];
        [_checkButton mg_setEnlargeEdgeWithTop:Adapted(20) right:Adapted(100) bottom:Adapted(100) left:Adapted(20)];
        [_checkButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.selected = YES;
    }
    return _checkButton;
}


- (UILabel *)protocolLabel
{
    if (!_protocolLabel) {
        _protocolLabel = [[UILabel alloc] init];
        _protocolLabel.font = H13;
        _protocolLabel.textColor = kTextColor;
        _protocolLabel.textAlignment = NSTextAlignmentLeft;
        _protocolLabel.userInteractionEnabled = YES;
        _protocolLabel.numberOfLines = 0;
    }
    return _protocolLabel;
}

- (UIButton *)applyButton
{
    if (!_applyButton) {
        _applyButton = [[UIButton alloc] init];
        _applyButton.titleLabel.font = H13;
        _applyButton.clipsToBounds = YES;
        _applyButton.layer.cornerRadius = Adapted(2);
        _applyButton.backgroundColor = kRedColor;
        [_applyButton setTitleColor:white_color forState:UIControlStateNormal];
    }
    return _applyButton;
}

- (void)setUpLayouts
{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(6));
    }];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(Adapted(-16));
        make.width.height.mas_equalTo(Adapted(20));
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.bottom.mas_equalTo(Adapted(-8));
        make.width.mas_equalTo(Adapted(100));
        make.height.mas_equalTo(Adapted(32));
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkButton.mas_right).offset(10);
        make.right.mas_equalTo(self.applyButton.mas_left).offset(-5);
        make.top.mas_equalTo(Adapted(0));
        make.bottom.mas_equalTo(Adapted(0));
    }];
    
    
    
}

-(void)changeStatus:(UIButton *)btn{
    btn.selected = !btn.selected;
}


@end
