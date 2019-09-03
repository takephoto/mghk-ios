//
//  MGEntrustCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGEntrustCell.h"

@interface MGEntrustCell()
@property (nonatomic, strong) UILabel *entrustLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *dealLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *riceStrLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *numberStrLab;

@end

@implementation MGEntrustCell

-(void)setUpViews{
    
    self.contentView.backgroundColor = white_color;
    self.backgroundColor = white_color;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //委托
    UILabel *entrustLab = [self getLabel];
    entrustLab.text = kLocalizedString(@"委托中");
    entrustLab.font = H16;
    [self.contentView addSubview:entrustLab];
    self.entrustLab = entrustLab;
    entrustLab.textColor = kTextColor;
    [entrustLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(21));
        make.left.mas_equalTo(Adapted(12));
    }];
    
    //时间
    UILabel *timeLab = [self getLabel];
    timeLab.font = H16;
    timeLab.textColor = kTextColor;
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(entrustLab.mas_bottom).offset(Adapted(20));
        make.left.mas_equalTo(entrustLab);
    }];
    
    //时间String
    UILabel *timeStrLab = [self getLabel];
    timeStrLab.text = kLocalizedString(@"时间");
    timeStrLab.font = H12;
    timeStrLab.textColor = k99999Color;
    [self.contentView addSubview:timeStrLab];
    [timeStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(10));
        make.height.mas_equalTo(Adapted(13));
        make.left.mas_equalTo(entrustLab);
        make.bottom.mas_equalTo(-16);
    }];

    //买入/卖出
    UILabel *dealLab = [self getLabel];
    dealLab.font = [UIFont systemFontOfSize:15];
    dealLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dealLab];
    [dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(entrustLab);
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    self.dealLab = dealLab;
    
    //委托价
    UILabel *priceLab = [self getLabel];
    priceLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:priceLab];
    self.priceLab = priceLab;
    priceLab.textAlignment = NSTextAlignmentLeft;
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(entrustLab.mas_bottom).offset(Adapted(20));
        make.left.mas_equalTo(dealLab);
    }];
    
    //委托价String
    UILabel *riceStrLab = [self getLabel];
    riceStrLab.text = kLocalizedString(@"委托价(BTC)");
    riceStrLab.font = H12;
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
    [button setTitleColor:k99999Color forState:UIControlStateNormal];
    button.layer.borderColor = k99999Color.CGColor;
    button.layer.borderWidth = 0.5;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(16));
        make.width.mas_equalTo(Adapted(56));
        make.height.mas_equalTo(Adapted(24));
        make.right.mas_equalTo(Adapted(-12));
    }];
    self.button = button;
    //委托量
    UILabel *numberLab = [self getLabel];
    //numberLab.text = @"324414";
    numberLab.font = H16;
    numberLab.textColor = kTextColor;
    [self.contentView addSubview:numberLab];
    self.numberLab = numberLab;
    numberLab.textAlignment = NSTextAlignmentRight;
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(entrustLab.mas_bottom).offset(Adapted(20));
        make.right.mas_equalTo(Adapted(-12));
    }];
    //委托价String
    UILabel *numberStrLab = [self getLabel];
    numberStrLab.text =kLocalizedString(@"委托量(KBC)");
    numberStrLab.font = H12;
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
    
    self.entrustLab.text = model.statusString;
    self.timeLab.text = model.createDate;
    self.dealLab.text = model.buySellString;
    self.dealLab.textColor = model.buySellColor;
    self.priceLab.text = model.price = [model.price keepDecimal:8];
    self.priceLab.textColor = model.buySellColor;
    if ([model.status isEqualToString:@"1"]||[model.status isEqualToString:@"2"]) {//未成交,部分成交、
        self.numberLab.text = model.volume = [model.volume keepDecimal:8];
    }else if([model.status isEqualToString:@"3"]){//完全成交
        self.numberLab.text = model.volume = [model.volume keepDecimal:8];
    }
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
    
    //当前委托
    
    //委托历史
    
}


@end


























