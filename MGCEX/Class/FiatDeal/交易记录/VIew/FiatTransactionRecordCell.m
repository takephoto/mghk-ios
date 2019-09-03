// MGC
//
// FiatTransactionRecordCell.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTransactionRecordCell.h"
@interface FiatTransactionRecordCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * vipImageV;
@property (nonatomic, strong) UILabel * statusLabel;

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * subLeftLabel;

@property (nonatomic, strong) UILabel * midleLabel;
@property (nonatomic, strong) UILabel * subMidLabel;

@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * subRightLabel;

@property (nonatomic, strong) UIImageView * backImageV;

@end

@implementation FiatTransactionRecordCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    UIImageView * backImageV = [[UIImageView alloc]init];
    [self addSubview:backImageV];
    self.backImageV = backImageV;
    backImageV.image = IMAGE(@"icon_publish");
    [backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(Adapted(-85));
        make.width.mas_equalTo(Adapted(80));
        make.height.mas_equalTo(Adapted(60));
    }];
    backImageV.hidden = YES;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"";
    titleLabel.font = H15;
    titleLabel.textColor = kTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(18));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.titleLabel = titleLabel;
    
    
    UILabel * statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:statusLabel];
    statusLabel.text = kLocalizedString(@"未发货");
    statusLabel.font = H15;
    statusLabel.textColor = kTextColor;
    statusLabel.textAlignment = NSTextAlignmentLeft;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset((MAIN_SCREEN_WIDTH-Adapted(30))/3.0 + Adapted(15));
        make.centerY.mas_equalTo(titleLabel);
    }];
    self.statusLabel = statusLabel;
    
    //查看
    UILabel *lab = [[UILabel alloc] init];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(Adapted(-15));
        make.centerY.mas_equalTo(statusLabel);
        make.width.mas_greaterThanOrEqualTo(Adapted(56));
        make.height.mas_offset(Adapted(24));
    }];
    lab.font = H13;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = kLocalizedString(@"查看");
    ViewBorderRadius(lab, 0, 1, UIColorFromRGB(0x666666));
    lab.textColor = UIColorFromRGB(0x666666);
    
    //VIP
    float titleWidth = [UIView getLabelWidthByHeight:20 Title:titleLabel.text font:H15]+Adapted(15)+Adapted(5);
    if(titleWidth > MAIN_SCREEN_WIDTH/2.0)  titleWidth = MAIN_SCREEN_WIDTH/2.0+10;
    UIImageView * vipImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:vipImageV];
    vipImageV.image = IMAGE(@"sjrz");
    [vipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleWidth);
        make.centerY.mas_equalTo(titleLabel);
        make.width.mas_equalTo(Adapted(16));
        make.height.mas_equalTo(Adapted(12));
    }];
    self.vipImageV = vipImageV;
    
    //左----
    UILabel * leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:leftLabel];
    leftLabel.textColor = kGreenColor;
    leftLabel.font = H15;
    leftLabel.text = @"";
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(21));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.leftLabel = leftLabel;
    
    UILabel * subLeftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLeftLabel];
    subLeftLabel.textColor = k99999Color;
    subLeftLabel.font = H11;
    subLeftLabel.text = kLocalizedString(@"单价(CNY)");
    [subLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(leftLabel.mas_bottom).offset(Adapted(8));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subLeftLabel = subLeftLabel;
    
    //中----
    UILabel * midleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:midleLabel];
    midleLabel.textColor = kTextColor;
    midleLabel.font = H13;
    midleLabel.text = @"";
    [midleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLabel.mas_right);
        make.top.mas_equalTo(leftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.midleLabel = midleLabel;
    
    UILabel * subMidLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subMidLabel];
    subMidLabel.textColor = k99999Color;
    subMidLabel.font = H11;
    //subMidLabel.text = kLocalizedString(@"数量(BYC)");
    [subMidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midleLabel);
        make.top.mas_equalTo(subLeftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subMidLabel = subMidLabel;
    
    //右----
    UILabel * rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:rightLabel];
    rightLabel.textColor = kTextColor;
    rightLabel.font = H13;
    rightLabel.text = @"";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(midleLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.rightLabel = rightLabel;
    
    UILabel * subRightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subRightLabel];
    subRightLabel.textColor = k99999Color;
    subRightLabel.font = H11;
    subRightLabel.text = kLocalizedString(@"交易总价(CNY)");
    subRightLabel.textAlignment = NSTextAlignmentRight;
    [subRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(subLeftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subRightLabel = subRightLabel;
    
    
  
    
}

-(void)setModel:(FiatTransactionRecordsModel *)model{
    _model = model;

    
    self.titleLabel.text = model.nikeName;
    
    float titleWidth = [UIView getLabelWidthByHeight:20 Title:self.titleLabel.text font:H15]+Adapted(15)+Adapted(5);
    if(titleWidth > MAIN_SCREEN_WIDTH/2.0)  titleWidth = MAIN_SCREEN_WIDTH/2.0+10;
    
    [self.vipImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleWidth);
    }];
    
    self.vipImageV.hidden = ([model.isMerchart integerValue] ==1)? YES:NO;
    
    self.leftLabel.text = [NSString stringWithFormat:@"%.2f",[model.priceVal doubleValue]];
    
    self.midleLabel.text = [NSString stringWithFormat:@"%.8f",[model.tradeQuantity doubleValue]];
    
    self.rightLabel.text = model.tradeAmount;
    
    self.subMidLabel.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"数量"), model.tradeCode];
    
    self.statusLabel.text = model.statusString;
    self.statusLabel.textColor = model.statusColor;
    
    self.backImageV.hidden =  ([model.isAdvertising integerValue] == 1)? NO:YES;
  
}

@end
