// MGC
//
// CoinDealSegHeadView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealSegHeadView.h"

@interface CoinDealSegHeadView()
@end

@implementation CoinDealSegHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = kBackGroundColor;
    
    NSArray * segArr = @[kLocalizedString(@"买入"),kLocalizedString(@"卖出")];
    self.segMentview = [[CustomSegmentedView alloc]initWithSegmentArr:segArr frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH/2.0+Adapted(20), self.height)];
    [self addSubview:_segMentview];
    self.segMentview.segmentColor = kBackGroundColor;
    self.segMentview.segLabel1.textColor = kGreenColor;
    self.segMentview.slidView.backgroundColor = kGreenColor;
    self.segMentview.backView.backgroundColor = kBackGroundColor;
    
    @weakify(self);
    self.segMentview.segmentCallBlock = ^(NSInteger index,UILabel * label) {
        @strongify(self);
        switch (index) {
            case 0:{
                self.segMentview.segLabel1.textColor = kGreenColor;
                self.segMentview.segLabel2.textColor = k99999Color;
                self.segMentview.slidView.backgroundColor = kGreenColor;
                
                if(self.segmentBlock){
                    self.segmentBlock(1);
                }
                
            }
                break;
            case 1:{
                self.segMentview.segLabel1.textColor = k99999Color;
                self.segMentview.segLabel2.textColor = kRedColor;
                self.segMentview.slidView.backgroundColor = kRedColor;
                
                if(self.segmentBlock){
                    self.segmentBlock(2);
                }
                
            }
                
            default:
                break;
        }
    };
    
    
    QSButton * K_lineBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:K_lineBtn];
    K_lineBtn.style = QSButtonImageStyleRight;
    K_lineBtn.space = Adapted(5);
//    [K_lineBtn setImage:IMAGE(@"jiantou-heng") forState:UIControlStateNormal];
    [K_lineBtn setTitle:kLocalizedString(@"K 线图") forState:UIControlStateNormal];
    K_lineBtn.titleLabel.font = H15;
    [K_lineBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [K_lineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(6));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0-Adapted(10));
    }];
    
    [K_lineBtn addTarget:self action:@selector(K_lineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    QSButton * optionalBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:optionalBtn];
    self.optionalBtn = optionalBtn;
    optionalBtn.style = QSButtonImageStyleLeft;
    optionalBtn.space = Adapted(5);
    [optionalBtn setImage:IMAGE(@"icon_optional_off") forState:UIControlStateNormal];
    [optionalBtn setImage:IMAGE(@"icon_optional_on") forState:UIControlStateSelected];
    [optionalBtn setTitle:kLocalizedString(@"自选") forState:UIControlStateNormal];
    optionalBtn.titleLabel.font = H15;
    [optionalBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [optionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(K_lineBtn.mas_left);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0-Adapted(10));
    }];
    
    [optionalBtn addTarget:self action:@selector(optionalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//跳K线图
-(void)K_lineBtnClick{
    
    if(self.segmentBlock){
        self.segmentBlock(4);
    }
    
}

//添加自选
-(void)optionalBtnClick:(QSButton *)btn{
    
    if(self.segmentBlock){
        self.segmentBlock(3);
    }
}

@end
