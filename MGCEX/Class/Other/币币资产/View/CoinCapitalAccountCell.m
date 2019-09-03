// MGC
//
// CoinCapitalAccountCell.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinCapitalAccountCell.h"

@interface CoinCapitalAccountCell()
@property (nonatomic, strong) UIImageView * logImageV;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * subLeftLabel;
@property (nonatomic, strong) UILabel * midleLabel;
@property (nonatomic, strong) UILabel * subMidLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * subRightLabel;
@property (nonatomic, strong) UIButton *rechargeBtn;
@end

@implementation CoinCapitalAccountCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    NSArray * btnTitles = @[kLocalizedString(@"充币"),kLocalizedString(@"提币"),kLocalizedString(@"币币"),kLocalizedString(@"资金划转")];
    for(int i=0 ;i<btnTitles.count;i++){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:kRedColor forState:UIControlStateNormal];
        [btn setTitleColor:k99999Color forState:UIControlStateDisabled];
        btn.titleLabel.font = H15;
        btn.tag = 10+i;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*MAIN_SCREEN_WIDTH/btnTitles.count);
            make.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(MAIN_SCREEN_WIDTH/btnTitles.count);
            make.height.mas_equalTo(Adapted(56));
        }];
        [btn addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * shuxian = [[UIView alloc]init];
        [self.contentView addSubview:shuxian];
        shuxian.backgroundColor = kBackGroundColor;
        [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((i+1)*MAIN_SCREEN_WIDTH/btnTitles.count);
            make.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(Adapted(50));
        }];
        
    }
    self.rechargeBtn = [self.contentView viewWithTag:10];
    UIView * bottomSpace = [[UIView alloc]init];
    [self addSubview:bottomSpace];
    bottomSpace.backgroundColor = kBackGroundColor;
    [bottomSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo (Adapted(6));
    }];
    
    
    UIImageView * logImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:logImageV];
    self.logImageV = logImageV;
    //logImageV.image = IMAGE(@"zfb");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Adapted(12));
        make.width.height.mas_equalTo(Adapted(18));
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    //titleLabel.text = @"NHYG";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageV.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(logImageV);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    
    UILabel * statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    statusLabel.textColor = kRedColor;
    statusLabel.font = H15;
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.text = kLocalizedString(@"资金转移");
    statusLabel.userInteractionEnabled = YES;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-12));
        make.centerY.mas_equalTo(logImageV);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(capitalTransferClick)];
    [self.statusLabel addGestureRecognizer:tap];
    
    //左----
    UILabel * leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:leftLabel];
    leftLabel.textColor = kTextColor;
    leftLabel.font = H13;
    leftLabel.numberOfLines = 2;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(21));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.leftLabel = leftLabel;
    
    UILabel * subLeftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLeftLabel];
    subLeftLabel.textColor = k99999Color;
    subLeftLabel.font = H11;
    subLeftLabel.text = kLocalizedString(@"可用");
    [subLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.bottom.mas_equalTo(self.rechargeBtn.mas_top).offset(Adapted(-5));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subLeftLabel = subLeftLabel;
    
    //中----
    UILabel * midleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:midleLabel];
    midleLabel.textColor = kTextColor;
    midleLabel.font = H13;
    midleLabel.text = @"0";
    midleLabel.numberOfLines = 2;
    [midleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(142));
        make.top.mas_equalTo(leftLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(50))/3.0);
    }];
    self.midleLabel = midleLabel;
    
    UILabel * subMidLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subMidLabel];
    subMidLabel.textColor = k99999Color;
    subMidLabel.font = H11;
    subMidLabel.text = kLocalizedString(@"冻结");
    [subMidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midleLabel);
        make.bottom.mas_equalTo(self.rechargeBtn.mas_top).offset(Adapted(-5));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(50))/3.0);
    }];
    self.subMidLabel = subMidLabel;
    
    //右----
    UILabel * rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:rightLabel];
    rightLabel.textColor = kTextColor;
    rightLabel.font = H13;
    rightLabel.numberOfLines = 2;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(midleLabel);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(40))/3.0);
    }];
    self.rightLabel = rightLabel;
    
    UILabel * subRightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subRightLabel];
    subRightLabel.textColor = k99999Color;
    subRightLabel.font = H11;
    subRightLabel.text = kLocalizedString(@"估值(CNY)");
    subRightLabel.textAlignment = NSTextAlignmentRight;
    subRightLabel.userInteractionEnabled = YES;
    [subRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-12));
        make.bottom.mas_equalTo(self.rechargeBtn.mas_top).offset(Adapted(-5));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
    }];
    self.subRightLabel = subRightLabel;
    
    UIView * bottomLineView = [[UIView alloc]init];
    [self addSubview:bottomLineView];
    bottomLineView.backgroundColor = kBackGroundColor;
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-50));
        make.height.mas_equalTo(1);
    }];
}

-(void)btnTitleClick:(UIButton *)btn{
    
    if(self.btnClickBlock){
        self.btnClickBlock(btn.tag);
    }
}

- (void)capitalTransferClick
{
    if (self.capitalTransferClickBlock) {
        self.capitalTransferClickBlock();
    }
}

-(void)setModel:(CoinCapListModel *)model{
    _model = model;
    
    self.titleLabel.text = model.tradeCode;
    [self.logImageV sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    if ([model.tradeCode isEqualToString:@"KBC"]) {
        self.statusLabel.hidden = NO;
    }else{
        self.statusLabel.hidden = YES;
    }
    //self.statusLabel.hidden = ([model.isintegral integerValue] == 1)?NO:YES;
    self.leftLabel.text = kNotNumber([model.availableBalance keepDecimal:8]);
    self.midleLabel.text = kNotNumber([model.frozenBalance keepDecimal:8]);
    self.rightLabel.text = kNotNumber([model.cny keepDecimal:2]);
}
@end
