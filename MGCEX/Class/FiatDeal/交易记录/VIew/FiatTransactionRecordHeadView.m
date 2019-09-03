// MGC
//
// FiatTransactionRecordHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTransactionRecordHeadView.h"


@interface FiatTransactionRecordHeadView()

@end

@implementation FiatTransactionRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    NSArray * segArr = @[@"C2C/B2C",kLocalizedString(@"币币交易"),kLocalizedString(@"广告发布"),kLocalizedString(@"提币/充币")];
    self.segMentview = [[CustomSegmentedView alloc]initWithSegmentArr:segArr frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(48))];
    self.segMentview.slidView.backgroundColor = kMainColor;
    self.segMentview.backView.backgroundColor = white_color;
    self.segMentview.segLabel1.textColor = kMainColor;
    self.selectedIndex = 0;
    [self addSubview:self.segMentview];
    @weakify(self);
    self.segMentview.segmentCallBlock = ^(NSInteger index,UILabel * label) {
        @strongify(self);
        if (self.selectedIndex == index) {
            return;
        }
        self.selectedIndex = index;
        switch (index) {
            case 0:{
                
                if([self.btnDelegate respondsToSelector:@selector(sendSelectItemValue:)]){
                    [self.btnDelegate sendSelectItemValue:1];
                }
                self.segMentview.segLabel1.textColor = kMainColor;
                self.segMentview.segLabel2.textColor = k99999Color;
                self.segMentview.segLabel3.textColor = k99999Color;
                self.segMentview.segLabel4.textColor = k99999Color;
            }
                break;
            case 1:{
          
                if([self.btnDelegate respondsToSelector:@selector(sendSelectItemValue:)]){
                    [self.btnDelegate sendSelectItemValue:2];
                }
                self.segMentview.segLabel1.textColor = k99999Color;
                self.segMentview.segLabel2.textColor = kMainColor;
                self.segMentview.segLabel3.textColor = k99999Color;
                self.segMentview.segLabel4.textColor = k99999Color;
            }
            break;
            case 2:{
              
                if([self.btnDelegate respondsToSelector:@selector(sendSelectItemValue:)]){
                    [self.btnDelegate sendSelectItemValue:3];
                }
                self.segMentview.segLabel1.textColor = k99999Color;
                self.segMentview.segLabel2.textColor = k99999Color;
                self.segMentview.segLabel3.textColor = kMainColor;
                self.segMentview.segLabel4.textColor = k99999Color;
            }
                break;
            case 3:{
            
                if([self.btnDelegate respondsToSelector:@selector(sendSelectItemValue:)]){
                    [self.btnDelegate sendSelectItemValue:4];
                }
                self.segMentview.segLabel1.textColor = k99999Color;
                self.segMentview.segLabel2.textColor = k99999Color;
                self.segMentview.segLabel3.textColor = k99999Color;
                self.segMentview.segLabel4.textColor = kMainColor;
            }
                break;
                
            default:
                break;
        }
    };
    
    
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:buyBtn];
    self.buyBtn = buyBtn;
    [buyBtn setBackgroundColor:kGreenColor forState:UIControlStateSelected];
    [buyBtn setBackgroundColor:k99999Color forState:UIControlStateNormal];
    buyBtn.titleLabel.textColor = kTextColor;
    buyBtn.titleLabel.font = H15;
    [buyBtn setTitle:kLocalizedString(@"买入") forState:UIControlStateNormal];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(self.segMentview.mas_bottom).offset(Adapted(8));
        make.width.mas_equalTo(Adapted(66));
        make.height.mas_equalTo(Adapted(28));
    }];
    buyBtn.selected = YES;
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sellBtn];
    self.sellBtn = sellBtn;
    [sellBtn setBackgroundColor:kRedColor forState:UIControlStateSelected];
    [sellBtn setBackgroundColor:k99999Color forState:UIControlStateNormal];
    sellBtn.titleLabel.textColor = kTextColor;
    sellBtn.titleLabel.font = H15;
    [sellBtn setTitle:kLocalizedString(@"卖出") forState:UIControlStateNormal];
    [sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyBtn.mas_right);
        make.top.mas_equalTo(self.segMentview.mas_bottom).offset(Adapted(8));
        make.width.mas_equalTo(Adapted(66));
        make.height.mas_equalTo(Adapted(28));
    }];
    [sellBtn addTarget:self action:@selector(sellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    QSButton * leftBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftBtn];
    leftBtn.style = QSButtonImageStyleRight;
    leftBtn.space = Adapted(4);
    [leftBtn setImage:IMAGE(@"jt_xs_down") forState:UIControlStateNormal];
    [leftBtn setImage:IMAGE(@"jt_xs_up") forState:UIControlStateSelected];
    [leftBtn setTitle:kLocalizedString(@"所有币种") forState:UIControlStateNormal];
    [leftBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [leftBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    leftBtn.titleLabel.font = H13;
    leftBtn.tag = 1;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(buyBtn);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0);
        make.height.mas_equalTo(Adapted(48));
    }];
    
    [leftBtn addTarget:self action:@selector(selectLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    
    
    QSButton * rightBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rightBtn];
    rightBtn.style = QSButtonImageStyleRight;
    rightBtn.space = Adapted(4);
    [rightBtn setImage:IMAGE(@"jt_xs_down") forState:UIControlStateNormal];
    [rightBtn setImage:IMAGE(@"jt_xs_up") forState:UIControlStateSelected];
    [rightBtn setTitle:kLocalizedString(@"所有状态") forState:UIControlStateNormal];
    [rightBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [rightBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    rightBtn.titleLabel.font = H13;
    rightBtn.tag = 2;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(leftBtn.mas_left);
        make.centerY.mas_equalTo(buyBtn);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0);
        make.height.mas_equalTo(Adapted(48));
    }];
    
    [rightBtn addTarget:self action:@selector(selectRightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    
    
}

-(void)buyBtnClick:(UIButton  *)btn{
    if(btn.selected == YES){
        return;
    }
    
    btn.selected = !btn.selected;
    self.sellBtn.selected = NO;
    
    if(self.buyBlock){
        self.buyBlock();
    }
}
-(void)sellBtnClick:(UIButton  *)btn{
    
    if(btn.selected == YES){
        return;
    }
    
    btn.selected = !btn.selected;
    self.buyBtn.selected = NO;
    if(self.sellBlock){
        self.sellBlock();
    }
}

-(void)selectLeftClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if([self.btnDelegate respondsToSelector:@selector(sendHeadFrameValue:index:)]){
        [self.btnDelegate sendHeadFrameValue:self index:btn.tag];
    }
}


-(void)selectRightClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if([self.btnDelegate respondsToSelector:@selector(sendHeadFrameValue:index:)]){
        [self.btnDelegate sendHeadFrameValue:self index:btn.tag];
    }
}
@end
