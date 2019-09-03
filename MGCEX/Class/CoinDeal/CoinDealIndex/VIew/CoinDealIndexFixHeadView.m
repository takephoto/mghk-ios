// MGC
//
// CoinDealIndexFixHeadView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealIndexFixHeadView.h"

@interface CoinDealIndexFixHeadView()

@end

@implementation CoinDealIndexFixHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    QSButton * leftBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftBtn];
    self.leftBtn = leftBtn;
    leftBtn.style = QSButtonImageStyleRight;
    leftBtn.space = Adapted(5);
    [leftBtn setImage:IMAGE(@"coinDeal_down") forState:UIControlStateNormal];
    [leftBtn setImage:IMAGE(@"coinDeal_up") forState:UIControlStateSelected];
    [leftBtn setTitleColor:kTextColor forState:UIControlStateNormal];
   // [leftBtn setTitle:@"BYC/CNY" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = H15;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(Adapted(48));
        make.width.mas_equalTo(10);
    }];
    [leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIView getLabelWidthByHeight:Adapted(20) Title:@"KBC/CNY" font:H15]+Adapted(20));
    }];
    [leftBtn addTarget:self action:@selector(selectLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * midLabel = [[UILabel alloc]init];
    [self addSubview:midLabel];
    self.midLabel = midLabel;
    midLabel.textColor = kTextColor;
    midLabel.font = H15;
    //midLabel.text = @"0.014528745";
    midLabel.textAlignment = NSTextAlignmentLeft;
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(160));
        make.top.mas_equalTo(Adapted(6) + kStatusBarHeight);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
        
    }];
    
    UILabel * submidLabel = [[UILabel alloc]init];
    [self addSubview:submidLabel];
    self.submidLabel = submidLabel;
    submidLabel.textColor = kTextColor;
    submidLabel.font = H11;
    //submidLabel.text = @"58.25 CNY";
    submidLabel.textAlignment = NSTextAlignmentLeft;
    [submidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midLabel);
        make.right.mas_equalTo(midLabel);
        make.top.mas_equalTo(midLabel.mas_bottom).offset(Adapted(3));
        
    }];
    
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midLabel.mas_left).offset(Adapted(-16));
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(leftBtn);
        make.height.mas_equalTo(Adapted(24));
    }];
    
    
    UILabel * rightLabel = [[UILabel alloc]init];
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
    rightLabel.textColor = kRedColor;
    rightLabel.font = H15;
    //rightLabel.text = @"-538.88%";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftBtn);
        make.right.mas_equalTo(Adapted(-8));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
        
    }];
    
    UIView * bottomLineView =[[ UIView alloc]init];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(Adapted(3));
    }];
}

-(void)selectLeftClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if(self.segBlock){
        self.segBlock(self);
    }
    
}


@end
