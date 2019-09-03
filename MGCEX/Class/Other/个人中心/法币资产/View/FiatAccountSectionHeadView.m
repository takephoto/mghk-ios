// MGC
//
// FiatAccountSectionHeadView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatAccountSectionHeadView.h"

@implementation FiatAccountSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
    self.backgroundColor = kBackAssistColor;
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:IMAGE(@"icon_conceal_off") forState:UIControlStateNormal];
    [selectBtn setImage:IMAGE(@"icon_conceal_on") forState:UIControlStateSelected];
    [selectBtn setTitle:kLocalizedString(@"   隐藏0资金的币种") forState:UIControlStateNormal];
    [selectBtn setTitleColor:UIColorFromRGB(0xafafaf) forState:UIControlStateNormal];
    selectBtn.titleLabel.font = H13;
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self).offset(3);
        make.height.mas_equalTo(Adapted(44));
    }];
    
    [selectBtn addTarget:self action:@selector(selectCapitalAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * headLineView = [[UIView alloc]init];
    [self addSubview:headLineView];
    headLineView.backgroundColor = kBackGroundColor;
    [headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo (Adapted(12));
    }];
    
    UIView * bottomLineView = [[UIView alloc]init];
    [self addSubview:bottomLineView];
    bottomLineView.backgroundColor = kBackGroundColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo (Adapted(6));
    }];
}

-(void)selectCapitalAccount:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(self.btnBlock){
        self.btnBlock(btn.selected);
    }
}

@end
