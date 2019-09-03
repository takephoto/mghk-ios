// MGC
//
// CoinEntrustCell.m
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinEntrustCell.h"

@interface CoinEntrustCell()
@property (nonatomic, strong) UILabel *queueLabel;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *dealLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *riceStrLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *numberStrLab;

@end

@implementation CoinEntrustCell

-(void)setUpViews{
    
    self.contentView.backgroundColor = white_color;
    self.backgroundColor = kBackGroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //币种队列
    UILabel *queueLabel = [self getLabel];
    //queueLabel.text = @"BYC/BTC";
    queueLabel.font = [UIFont systemFontOfSize:15];
    self.queueLabel = queueLabel;
    [self.contentView addSubview:queueLabel];
    queueLabel.textColor = kTextColor;
    [queueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(21));
        make.left.mas_equalTo(Adapted(12));
    }];
    //时间
    UILabel *timeLab = [self getLabel];
    //timeLab.text = @"9:57 12/18";
    timeLab.font = [UIFont systemFontOfSize:15];
    timeLab.textColor = kTextColor;
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(queueLabel.mas_bottom).offset(Adapted(20));
        make.left.mas_equalTo(queueLabel);
    }];
    //时间String
    UILabel *timeStrLab = [self getLabel];
    timeStrLab.text = kLocalizedString(@"时间");
    timeStrLab.font = [UIFont systemFontOfSize:12];
    timeStrLab.textColor = k99999Color;
    [self.contentView addSubview:timeStrLab];
    [timeStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(10));
        make.height.mas_equalTo(Adapted(13));
        make.left.mas_equalTo(queueLabel);
        make.bottom.mas_equalTo(-16);
    }];

    //买入/卖出
    UILabel *dealLab = [self getLabel];
    //dealLab.text = @"买入";
    dealLab.font = [UIFont systemFontOfSize:15];
    dealLab.textColor = kGreenColor;
    dealLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:dealLab];
    self.dealLab = dealLab;
    [dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(queueLabel);
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    
    //委托价
    UILabel *priceLab = [self getLabel];
    //priceLab.text = @"0.432432423";
    priceLab.font = [UIFont systemFontOfSize:15];
    priceLab.textColor = kGreenColor;
    [self.contentView addSubview:priceLab];
    self.priceLab = priceLab;
    priceLab.textAlignment = NSTextAlignmentCenter;
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(queueLabel.mas_bottom).offset(Adapted(20));
        make.left.mas_equalTo(dealLab);
    }];
    
    //委托价String
    UILabel *riceStrLab = [self getLabel];
    //riceStrLab.text = @"委托价(BTC)";
    riceStrLab.font = [UIFont systemFontOfSize:12];
    riceStrLab.textColor = k99999Color;
    [self.contentView addSubview:riceStrLab];
    self.riceStrLab = riceStrLab;
    [riceStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(10));
        make.left.mas_equalTo(priceLab);
    }];

    //撤单
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:kLocalizedString(@"撤单") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:kTextColor forState:UIControlStateNormal];
    button.layer.borderColor = kTextColor.CGColor;
    button.layer.borderWidth = 0.5;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(16));
        make.width.mas_equalTo(Adapted(56));
        make.height.mas_equalTo(Adapted(24));
        make.right.mas_equalTo(Adapted(-12));
    }];
    button.hidden = YES;
    self.button = button;
    //委托量
    UILabel *numberLab = [self getLabel];
    //numberLab.text = @"324414";
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.textColor = kTextColor;
    [self.contentView addSubview:numberLab];
    self.numberLab = numberLab;
    numberLab.textAlignment = NSTextAlignmentRight;
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(queueLabel.mas_bottom).offset(Adapted(20));
        make.right.mas_equalTo(Adapted(-12));
    }];
    //委托价String
    UILabel *numberStrLab = [self getLabel];
    //numberStrLab.text = @"委托量(BYC)";
    numberStrLab.font = [UIFont systemFontOfSize:12];
    numberStrLab.textAlignment = NSTextAlignmentRight;
    numberStrLab.textColor = k99999Color;
    [self.contentView addSubview:numberStrLab];
    self.numberStrLab = numberStrLab;
    [numberStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(10));
        make.right.mas_equalTo(Adapted(-12));
        //        make.bottom.mas_equalTo(Adapted(-16));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(Adapted(0));
        make.bottom.mas_equalTo(Adapted(-5));
    }];
}
- (UILabel *)getLabel
{
    UILabel *lab = [[UILabel alloc]init];
    return lab;
}

-(void)setModel:(CoinEntrustModelList *)model{
    _model = model;
    
    self.queueLabel.text = [NSString stringWithFormat:@"%@/%@",model.symbol,model.market];
    self.timeLab.text = model.createDate;
    self.dealLab.text = model.buySellString;
    self.dealLab.textColor = model.buySellColor;
    self.priceLab.text = model.price;
    self.priceLab.textColor = model.buySellColor;
    self.numberLab.text = model.remainVolume = [model.remainVolume keepDecimal:8];
    NSString * str1 = kLocalizedString(@"委托价");
    NSString * str2 = kLocalizedString(@"委托量");
    self.riceStrLab.text = [NSString stringWithFormat:@"%@(%@)",str1,model.market];
    self.numberStrLab.text = [NSString stringWithFormat:@"%@(%@)",str2,model.symbol];
    if([model.status integerValue] == 1){
        self.button.hidden = NO;
    }else{
        self.button.hidden = YES;
    }
    
    //市价交易 不能撤单
    if([model.type integerValue] == 1){
        self.button.hidden = YES;
    }else{
        self.button.hidden = NO;
    }
}

@end
