// MGC
//
// SubFiatDealHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "SubFiatDealHeadView.h"

@implementation SubFiatDealHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    QSButton * leftBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftBtn];
    leftBtn.style = QSButtonImageStyleRight;
    leftBtn.space = Adapted(4);
    [leftBtn setImage:IMAGE(@"icon_gdown") forState:UIControlStateNormal];
    [leftBtn setImage:IMAGE(@"icon_gup") forState:UIControlStateSelected];
    [leftBtn setTitle:kLocalizedString(@"所有卖家") forState:UIControlStateNormal];
    [leftBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [leftBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    leftBtn.titleLabel.font = H13;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(-12));
        make.centerY.mas_equalTo(self).offset(Adapted(-3));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    
    [leftBtn addTarget:self action:@selector(selectLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
  
    QSButton * middleBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:middleBtn];
    middleBtn.style = QSButtonImageStyleRight;
    middleBtn.space = Adapted(4);
    [middleBtn setImage:IMAGE(@"icon_gdown") forState:UIControlStateNormal];
    [middleBtn setImage:IMAGE(@"icon_gup") forState:UIControlStateSelected];
    [middleBtn setTitle:kLocalizedString(@"所有支付方式") forState:UIControlStateNormal];
    [middleBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [middleBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    middleBtn.titleLabel.font = H13;
    [middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(Adapted(-3));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    
    [middleBtn addTarget:self action:@selector(selectMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.middleBtn = middleBtn;
    
    QSButton * rightBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rightBtn];
    rightBtn.style = QSButtonImageStyleRight;
    rightBtn.space = Adapted(4);
    [rightBtn setImage:IMAGE(@"icon_gdown") forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"icon_gup") forState:UIControlStateSelected];
    [rightBtn setTitle:kLocalizedString(@"所有交易额度") forState:UIControlStateNormal];
    [rightBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [rightBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    rightBtn.titleLabel.font = H13;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self).offset(Adapted(-3));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    
    [rightBtn addTarget:self action:@selector(selectRightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    
    UIView * bottomLine = [[UIView alloc]init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = kBackGroundColor;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(Adapted(6));
    }];
}

-(void)selectLeftClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if([self.btnDelegate respondsToSelector:@selector(sendSubFrameValue:withBtnTag:)]){
        [self.btnDelegate sendSubFrameValue:self withBtnTag:2];
        
    }
}

-(void)selectMiddleClick:(UIButton *)btn{
     btn.selected = !btn.selected;
    if([self.btnDelegate respondsToSelector:@selector(sendSubFrameValue:withBtnTag:)]){
        [self.btnDelegate sendSubFrameValue:self withBtnTag:3];
    }
}

-(void)selectRightClick:(UIButton *)btn{
     btn.selected = !btn.selected;
    if([self.btnDelegate respondsToSelector:@selector(sendSubFrameValue:withBtnTag:)]){
        [self.btnDelegate sendSubFrameValue:self withBtnTag:4];
    }
}
@end
