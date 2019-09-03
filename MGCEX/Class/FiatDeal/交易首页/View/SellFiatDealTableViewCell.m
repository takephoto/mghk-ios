// MGC
//
// SellFiatDealTableViewCell.m
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "SellFiatDealTableViewCell.h"
#import "FiatDealBuyOrSellModel.h"

@interface SellFiatDealTableViewCell()
@property (nonatomic, strong) NSMutableArray * payTypeArr;
@property (nonatomic, strong) NSMutableArray * payImageVArr;
@property (nonatomic, copy) NSMutableString * payTypeString;
@end

@interface SellFiatDealTableViewCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * vipImageV;
@property (nonatomic, strong) UILabel * ratioLabel;

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * subLeftLabel;

@property (nonatomic, strong) UILabel * midleLabel;
@property (nonatomic, strong) UILabel * subMidLabel;

@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * subRightLabel;

@property (nonatomic, strong) UIButton * buyBtn;
@end

@implementation SellFiatDealTableViewCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"";
    titleLabel.font = H15;
    titleLabel.textColor = kTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(16));
        
    }];
    self.titleLabel = titleLabel;
    
    //VIP
    UIImageView * vipImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:vipImageV];
    vipImageV.image = IMAGE(@"sjrz");
    [vipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(titleLabel);
        make.width.mas_equalTo(Adapted(16));
        make.height.mas_equalTo(Adapted(12));
    }];
    self.vipImageV = vipImageV;
    
    UILabel * ratioLabel = [[UILabel alloc]init];
    [self.contentView addSubview:ratioLabel];
    ratioLabel.text = @"98% (100/98)";
    ratioLabel.textColor = k99999Color;
    ratioLabel.font = H11;
    [ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(7));
    }];
    self.ratioLabel = ratioLabel;
    
    
    
    //左----
    UILabel * leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:leftLabel];
    leftLabel.textColor = k99999Color;
    leftLabel.font = H11;
    leftLabel.text = kLocalizedString(@"单价(CNY)");
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(44));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.leftLabel = leftLabel;
    
    UILabel * subLeftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLeftLabel];
    subLeftLabel.textColor = kGreenColor;
    subLeftLabel.font = H15;
    [subLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(leftLabel.mas_bottom).offset(Adapted(8));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subLeftLabel = subLeftLabel;
    
    //中----
    UILabel * midleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:midleLabel];
    midleLabel.textColor = k99999Color;
    midleLabel.font = H11;
    [midleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_equalTo(leftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.midleLabel = midleLabel;
    
    UILabel * subMidLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subMidLabel];
    subMidLabel.textColor = kTextColor;
    subMidLabel.font = H13;
    [subMidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(midleLabel.mas_bottom).offset(Adapted(6));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subMidLabel = subMidLabel;
    
    //右----
    UILabel * rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:rightLabel];
    rightLabel.textColor = k99999Color;
    rightLabel.font = H11;
    rightLabel.text = kLocalizedString(@"单笔限额(CNY)");
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(midleLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.rightLabel = rightLabel;
    
    UILabel * subRightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subRightLabel];
    subRightLabel.textColor = kTextColor;
    subRightLabel.font = H13;
    subRightLabel.textAlignment = NSTextAlignmentRight;
    [subRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(subLeftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subRightLabel = subRightLabel;
    
    //购买
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:buyBtn];
    [buyBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [buyBtn setTitle:kLocalizedString(@"卖出") forState:UIControlStateNormal];
    buyBtn.titleLabel.font = H15;
    [buyBtn setBackgroundColor:white_color forState:UIControlStateNormal];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.width.mas_equalTo(Adapted(90));
        make.height.mas_equalTo(Adapted(38));
        make.top.mas_equalTo(Adapted(16));
    }];
    self.buyBtn = buyBtn;
    
    [buyBtn addTarget:self action:@selector(SellClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * bottomLine = [[UIView alloc]init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = kBackGroundColor;
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(Adapted(1));
        make.height.mas_equalTo(Adapted(6));
    }];
    
}

-(void)SellClick:(UIButton *)btn{
    if([self.sellDelegate respondsToSelector:@selector(SellFiatDealWithBuy:)]){
        
        FiatDealBuyOrSellModel * model = [FiatDealBuyOrSellModel sharedFiatDealBuyOrSellModel];
        model.title = self.titleLabel.text;
        model.unitPrice = [self.model.priceVal keepDecimal:2];
        model.number = [self.model.salesVal keepDecimal:8];
        //向上取保留2位,可能会只有2位小数，所有+0.01保险
        model.limitMin = [NSString stringWithFormat:@"%.2f",[self.model.lowVal floatValue]];
        model.limitMax = [self.model.hightVal keepDecimal:2];
        model.isVip = ([self.model.merchartType integerValue] ==1)? YES:NO;
        model.currency = self.model.tradeCode;
        model.payString = self.payTypeString;
        model.isBuy = NO;
        model.adUserId = self.model.userId;
        model.advertisingOrderId = self.model.advertisingOrderId;
        [self.sellDelegate SellFiatDealWithBuy:model];
    }
}

-(void)setModel:(FiatDealBuyOrSellmodels *)model{
    _model = model;
    
    self.titleLabel.text = model.nickname;
    
    float titleWidth = [UIView getLabelWidthByHeight:20 Title:self.titleLabel.text font:H15]+Adapted(15)+Adapted(5);
    if(titleWidth > MAIN_SCREEN_WIDTH/2.0)  titleWidth = MAIN_SCREEN_WIDTH/2.0+10;
    
    [self.vipImageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleWidth);
    }];
    
    self.vipImageV.hidden = ([model.merchartType integerValue] ==1)? NO:YES;
    
    self.subLeftLabel.text = [model.priceVal keepDecimal:2];
    
    self.subMidLabel.text = [model.remainOrderNumber keepDecimal:8];
    
    self.subRightLabel.text = [NSString stringWithFormat:@"%.0f~%.0f",[model.lowVal doubleValue],[model.hightVal doubleValue]];
    
    self.midleLabel.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"剩余数量"), model.tradeCode];
    
    self.ratioLabel.text = [NSString stringWithFormat:@"%.2f%% (%.2f/%.2f)",[model.completionOrderVal floatValue]/([model.completionOrderVal floatValue] +[model.remainOrderNumber floatValue]),[model.completionOrderVal floatValue] +[model.remainOrderNumber floatValue],[model.completionOrderVal floatValue]];
    
    self.ratioLabel.text = @"";
    
    //初始化支付方式可变字符串
    self.payTypeString = nil;
    //先移除所有图标数组
    [self.payTypeArr removeAllObjects];
    //先移除所有图标imageView
    for (UIImageView * imaV in self.payImageVArr) {
        [imaV removeFromSuperview];
    }
    
    
    //小图标
    if([model.payVal intValue]&1){
        //有银行卡
        [self.payTypeString appendString:[NSString stringWithFormat:@"  %@",kLocalizedString(@"银行卡")] ];
        [self.payTypeArr addObject:@"yhk"];
    }
    if ([model.payVal intValue]&2){
        //有支付宝
        [self.payTypeString appendString:[NSString stringWithFormat:@"  %@",kLocalizedString(@"支付宝")]];
        [self.payTypeArr addObject:@"zfb"];
    }
    if ([model.payVal intValue]&4){
        //有微信
        [self.payTypeString appendString:[NSString stringWithFormat:@"  %@",kLocalizedString(@"微信")]];
        [self.payTypeArr addObject:@"wx"];
    }
    
    for(int i=0;i<self.payTypeArr.count;i++){
        UIImageView * logImageV = [[UIImageView alloc]init];
        [self.contentView addSubview:logImageV];
        logImageV.tag = 50+i;
        [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15)+i*Adapted(20));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(Adapted(5));
            make.width.height.mas_equalTo(Adapted(15));
        }];
        logImageV.image = IMAGE(self.payTypeArr[i]);
        [self.payImageVArr addObject:logImageV];
    }
    
    
    
}



-(NSMutableArray *)payTypeArr{
    if(!_payTypeArr){
        _payTypeArr = [NSMutableArray new];
    }
    return _payTypeArr;
}

-(NSMutableArray *)payImageVArr{
    if(!_payImageVArr){
        _payImageVArr = [NSMutableArray new];
    }
    return _payImageVArr;
}
-(NSMutableString *)payTypeString{
    if(!_payTypeString){
        _payTypeString = [[NSMutableString alloc]init];
    }
    return _payTypeString;
}
@end
