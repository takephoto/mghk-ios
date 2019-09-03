// MGC
//
// ChargeExtractCell.m
// MGCEX
//
// Created by MGC on 2018/6/12.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ChargeExtractCell.h"

@interface ChargeExtractCell()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * vipImageV;
@property (nonatomic, strong) UILabel * statusLabel;

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * subLeftLabel;

@property (nonatomic, strong) UILabel * midleLabel;
@property (nonatomic, strong) UILabel * subMidLabel;

@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * subRightLabel;

@property (nonatomic, copy) NSMutableString * payTypeString;
@property (nonatomic, strong) UILabel * payAddressLabel;
@end

@implementation ChargeExtractCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    // 单号
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = H15;
    titleLabel.textColor = kTextColor;
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(18));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0*2.0);
    }];
    self.titleLabel = titleLabel;
    
    
    UILabel * statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:statusLabel];
    statusLabel.font = H15;
    statusLabel.textColor = kTextColor;
    statusLabel.textAlignment = NSTextAlignmentRight;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(titleLabel);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.statusLabel = statusLabel;
    
    
    //左---- 时间
    UILabel * leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:leftLabel];
    leftLabel.textColor = kTextColor;
    leftLabel.font = H15;
    leftLabel.numberOfLines = 0;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(21));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.leftLabel = leftLabel;
    
    // 时间提示label
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
    //subMidLabel.text = @"数量()";
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
    
    // 秘钥地址
    UILabel * payAddressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:payAddressLabel];
    payAddressLabel.font = H13;
    payAddressLabel.textColor = k99999Color;
    payAddressLabel.numberOfLines = 0;
    [payAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(self.subLeftLabel.mas_bottom).offset(Adapted(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(Adapted(-15));
    }];
    self.payAddressLabel = payAddressLabel;
    
    
}

-(void)setFillModel:(FillCoinRecodeListModel *)fillModel{
    fillModel = fillModel;
    
    self.statusLabel.text = fillModel.statusString;
    self.leftLabel.text = [fillModel.time handleDefaultTimeFormat];
    self.midleLabel.text = fillModel.amount;
    self.payAddressLabel.text = fillModel.hashStr;
    self.subLeftLabel.text = kLocalizedString(@"时间");
    if([fillModel.status integerValue] == 3){
        self.statusLabel.textColor = kRedColor;
    }else{
        self.statusLabel.textColor = kTextColor;
    }
    
    self.titleLabel.text = fillModel.tradeCode;
    self.subMidLabel.text = kLocalizedString(@"转账金额");
    self.midleLabel.textColor = kGreenColor;
    self.subRightLabel.text = @"";
    self.rightLabel.text = @"";
    
    
}

-(void)setTakeModel:(TakeCoinRecordListModel *)takeModel{
    
    _takeModel = takeModel;
    
    self.statusLabel.text = takeModel.statusString;
    self.leftLabel.text = takeModel.timeStr;
    self.midleLabel.text = takeModel.amount;
    self.payAddressLabel.text = takeModel.address;
    self.subLeftLabel.text = kLocalizedString(@"时间");
    if([takeModel.status integerValue] == 3){
        self.statusLabel.textColor = kRedColor;
    }else{
        self.statusLabel.textColor = kTextColor;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"单号"),takeModel.orderNo];
    self.subMidLabel.text = kLocalizedString(@"金额");
    self.midleLabel.textColor = kRedColor;
    self.subRightLabel.text = kLocalizedString(@"币种");
    self.rightLabel.text = takeModel.tradeCode;
    
}




@end
