// MGC
//
// FiatPublicAdvRecordCell.m
// MGCEX
//
// Created by MGC on 2018/6/3.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPublicAdvRecordCell.h"
@interface FiatPublicAdvRecordCell()

// 记录编号
@property (nonatomic, strong) UILabel * orderLabel;

// 市价发布图标
@property (nonatomic, strong) UIImageView * markImageView;

// 发布时间
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * timeSubTitleLabel;

// 单价
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * priceSubTitleLabel;

// 交易限额
@property (nonatomic, strong) UILabel * transactionLabel;
@property (nonatomic, strong) UILabel * transactionSubTitleLabel;

// 数量
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * numberSubTitleLabel;

// 当前状态
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * statusSubTitleLabel;

// 支付方式图片
@property (nonatomic, strong) UIImageView *payTypeImageView0;
@property (nonatomic, strong) UIImageView *payTypeImageView1;
@property (nonatomic, strong) UIImageView *payTypeImageView2;

@end
@implementation FiatPublicAdvRecordCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    UILabel * orderLabel = [[UILabel alloc]init];
    [self.contentView addSubview:orderLabel];
    orderLabel.font = H15;
    orderLabel.textColor = kTextColor;
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(18));
        make.right.mas_equalTo(Adapted(-50));
    }];
    self.orderLabel = orderLabel;
    
    UIImageView *markImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:markImageView];
    [markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    self.markImageView = markImageView;
    
    UILabel * timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeLabel];
    timeLabel.font = H13;
    timeLabel.textColor = kTextColor;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(Adapted(23));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.timeLabel = timeLabel;

    UILabel * timeSubTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeSubTitleLabel];
    timeSubTitleLabel.text = kLocalizedString(@"发布时间");
    timeSubTitleLabel.font = H11;
    timeSubTitleLabel.textColor = k99999Color;
    timeSubTitleLabel.textAlignment = NSTextAlignmentLeft;
    [timeSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(Adapted(11));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.timeSubTitleLabel = timeSubTitleLabel;

    UILabel * priceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:priceLabel];
    priceLabel.font = H15;
    priceLabel.textColor = kRedColor;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(Adapted(23));
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(0);;
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.priceLabel = priceLabel;

    UILabel * priceSubTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:priceSubTitleLabel];
    priceSubTitleLabel.text = kLocalizedString(@"单价(CNY)");
    priceSubTitleLabel.font = H11;
    priceSubTitleLabel.textColor = k99999Color;
    priceSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    [priceSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(Adapted(10));
        make.left.mas_equalTo(self.timeSubTitleLabel.mas_right).offset(0);;
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.priceSubTitleLabel = priceSubTitleLabel;

    UILabel * transactionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:transactionLabel];
    transactionLabel.font = H13;
    transactionLabel.textColor = kTextColor;
    transactionLabel.textAlignment = NSTextAlignmentRight;
    [transactionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel);
        make.left.mas_equalTo(self.priceLabel.mas_right);
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.transactionLabel = transactionLabel;

    UILabel * transactionSubTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:transactionSubTitleLabel];
    transactionSubTitleLabel.text = kLocalizedString(@"交易限额(CNY)");
    transactionSubTitleLabel.font = H11;
    transactionSubTitleLabel.textColor = k99999Color;
    transactionSubTitleLabel.textAlignment = NSTextAlignmentRight;
    [transactionSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeSubTitleLabel);
        make.left.mas_equalTo(self.priceSubTitleLabel.mas_right);
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.transactionSubTitleLabel = transactionSubTitleLabel;

    UILabel * numberLabel = [[UILabel alloc]init];
    [self.contentView addSubview:numberLabel];
    numberLabel.font = H13;
    numberLabel.textColor = kTextColor;
    numberLabel.textAlignment = NSTextAlignmentLeft;
    [numberLabel sizeToFit];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeSubTitleLabel.mas_bottom).offset(Adapted(21));
        make.left.mas_equalTo(Adapted(15));
    }];
    self.numberLabel = numberLabel;

    UILabel * numberSubTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:numberSubTitleLabel];
    numberSubTitleLabel.font = H11;
    numberSubTitleLabel.textColor = k99999Color;
    numberSubTitleLabel.textAlignment = NSTextAlignmentRight;
    [numberSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(Adapted(9));
        make.left.mas_equalTo(Adapted(15));
    }];
    self.numberSubTitleLabel = numberSubTitleLabel;

    UILabel * statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:statusLabel];
    statusLabel.font = H13;
    statusLabel.textColor = kTextColor;
    statusLabel.textAlignment = NSTextAlignmentRight;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.numberLabel);
        make.left.mas_equalTo(self.numberLabel.mas_right);
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.statusLabel = statusLabel;

    UILabel * statusSubTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:statusSubTitleLabel];
    statusSubTitleLabel.text = kLocalizedString(@"当前状态");
    statusSubTitleLabel.font = H11;
    statusSubTitleLabel.textColor = k99999Color;
    statusSubTitleLabel.textAlignment = NSTextAlignmentRight;
    [statusSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.numberSubTitleLabel);
        make.left.mas_equalTo(self.numberSubTitleLabel.mas_right);
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.statusSubTitleLabel = statusSubTitleLabel;

    //图标1
    UIImageView * payTypeImageView0 = [[UIImageView alloc]init];
    [self.contentView addSubview:payTypeImageView0];
    [payTypeImageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberSubTitleLabel.mas_bottom).offset(Adapted(15));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    self.payTypeImageView0 = payTypeImageView0;

    // 图标2
    UIImageView * payTypeImageView1 = [[UIImageView alloc]init];
    [self.contentView addSubview:payTypeImageView1];
    [payTypeImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payTypeImageView0);
        make.left.mas_equalTo(self.payTypeImageView0.mas_right).offset(Adapted(6));
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    self.payTypeImageView1 = payTypeImageView1;

    // 图标3
    UIImageView * payTypeImageView2 = [[UIImageView alloc]init];
    [self.contentView addSubview:payTypeImageView2];
    [payTypeImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payTypeImageView1);
        make.left.mas_equalTo(self.payTypeImageView1.mas_right).offset(Adapted(6));
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    self.payTypeImageView2 = payTypeImageView2;

    //撤单
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:kLocalizedString(@"撤单") forState:UIControlStateNormal];
    button.titleLabel.font = H13;
    [button setTitleColor:k99999Color forState:UIControlStateNormal];
    button.layer.borderColor = k99999Color.CGColor;
    button.layer.borderWidth = 0.5;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payTypeImageView2);
        make.width.mas_equalTo(Adapted(70));
        make.height.mas_equalTo(Adapted(24));
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.undoButton = button;
    

}

-(void)setModel:(FiatDealBuyOrSellmodels *)model{
    _model = model;
    // 编号记录
    self.orderLabel.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"编号记录"),model.advertisingOrderId];
    // 图标
    if ([model.buysell isEqualToString:@"1"]) { //买
        if (model.type == 1) {
            [self.markImageView setImage:IMAGE(kLocalizedString(@"publish_icon_price_buy"))];
        }else{
            [self.markImageView setImage:nil];
        }
    }else{ //卖
        if (model.type == 1) {
            [self.markImageView setImage:IMAGE(kLocalizedString(@"publish_icon_price_sale"))];
        }else {
            [self.markImageView setImage:nil];
        }
    }
    
    // 时间
    self.timeLabel.text = [model.advertisingTime handleTimeFormat:@"yyyy-MM-dd"];
    // 单价
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.priceVal doubleValue]];
    // 交易额
    self.transactionLabel.text = [NSString stringWithFormat:@"%.0f~%.0f",[model.lowVal doubleValue],[model.hightVal doubleValue]];
    // 数量
    self.numberLabel.text = [NSString stringWithFormat:@"%.8f(%@ %.8f)",[model.salesVal doubleValue],kLocalizedString(@"剩"),[model.remainOrderNumber doubleValue]];
    self.numberSubTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"数量"), model.tradeCode];
    
    //状态
    self.statusLabel.textColor = kTextColor;
    if([model.orderStatus integerValue] == 1){
        self.statusLabel.text = kLocalizedString(@"发布中");
        self.statusLabel.textColor = kRedColor;
        self.undoButton.hidden = NO;
    }else if ([model.orderStatus integerValue] == 2){
        self.statusLabel.text = kLocalizedString(@"已完成");
        self.undoButton.hidden = YES;
    }else if ([model.orderStatus integerValue] == 3){
        self.statusLabel.text = kLocalizedString(@"已撤单");
        self.undoButton.hidden = YES;
    }
    
    
    //小图标
    NSMutableArray *payTypeArr = [NSMutableArray array];
    if([model.payVal intValue]&1){
        //有银行卡
        [payTypeArr addObject:@"yhk"];
     }
    if ([model.payVal intValue]&2){
        //有支付宝
        [payTypeArr addObject:@"zfb"];
    }
    if ([model.payVal intValue]&4){
        //有微信
        [payTypeArr addObject:@"wx"];
    }
    for (int i = 0; i < payTypeArr.count; i ++) {
        NSString *imageStr = [payTypeArr objectAtIndex:i];
        if (i == 0) {
            [self.payTypeImageView0 setImage:IMAGE(imageStr)];
        }else if (i == 1){
            [self.payTypeImageView1 setImage:IMAGE(imageStr)];
        }else if (i == 2){
            [self.payTypeImageView2 setImage:IMAGE(imageStr)];
        }
    }
    // 防止图片复用
    if (payTypeArr.count == 0){
        [self.payTypeImageView0 setImage:nil];
        [self.payTypeImageView1 setImage:nil];
        [self.payTypeImageView2 setImage:nil];
    }else if (payTypeArr.count == 1){
        [self.payTypeImageView1 setImage:nil];
        [self.payTypeImageView2 setImage:nil];
    }else if (payTypeArr.count == 2){
        [self.payTypeImageView2 setImage:nil];
    }
}

@end
