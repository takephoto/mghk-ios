//
//  MarketIndexCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MarketIndexCell.h"
@implementation MarketIndexCell
-(void)bindModel{
    @weakify(self);

    [RACObserve(self, marketIndexRealTimeModel)subscribeNext:^(MGMarketIndexRealTimeModel *x) {
        
        NSString *fee = [NSString stringWithFormat:@"%f",[x.gains doubleValue] *100];
        [fee removeFloatAllZero];
        
        //第一列
        self.titleLabel.text = [NSString stringWithFormat:@"%@/%@",x.symbol,x.market];
        NSString *num = [x.accVolume keepDecimal:0].toTenThousandUnit;
        NSString * str = kLocalizedString(@"24H量");
        self.subLabel.text = [NSString stringWithFormat:@"%@ %@",str,num];
        self.subLabel.hidden = YES;
        //第二列
        self.priceLabel.text = [x.c keepDecimal:8];
        self.subPriceLabel.text = string([x.valuation keepDecimal:2], @" CNY");
        //第三列
        self.ratioLabel.text = string([fee keepDecimal:2], @"%");
        self.ratioLabel.backgroundColor = [ self.ratioLabel.text hasPrefix:@"-"]?kRedColor:kGreenColor;
        if (![ self.ratioLabel.text hasPrefix:@"-"]) {
            self.ratioLabel.text = string(@"+", self.ratioLabel.text);
        }
        self.tagImgV.image = x.isOptional?[UIImage imageNamed:@"icon_optional_on"]:[UIImage imageNamed:@"icon_optional_off"];
    }];
}
-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UIImageView * tagImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:tagImgV];
    [tagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(Adapted(10));
        make.width.height.mas_equalTo(Adapted(15));
    }];
    self.tagImgV = tagImgV;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H13;
    titleLabel.text = @"NYTBVFGH";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tagImgV.mas_right).offset(Adapted(16));
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(Adapted(80));
    }];
    self.titleLabel = titleLabel;
    
    UILabel * subLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLabel];
    subLabel.textColor = UIColorFromRGB(0x999999);
    subLabel.font = H11;
    subLabel.text = @"KBC";
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(Adapted(11));
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(Adapted(-8));
    }];
    self.subLabel = subLabel;
    
    UILabel * ratioLabel = [[UILabel alloc]init];
    [self.contentView addSubview:ratioLabel];
    ratioLabel.textColor = white_color;
    ratioLabel.text = @"+999.99%";
    ratioLabel.font = H13;
    ratioLabel.textAlignment = NSTextAlignmentCenter;
    [ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(Adapted(-12));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(Adapted(75));
        make.height.mas_equalTo(Adapted(35));
    }];
    self.ratioLabel = ratioLabel;
    
    UILabel * priceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:priceLabel];
    priceLabel.textColor = kTextColor;
    priceLabel.font = H13;
    priceLabel.text = @"87411452.24";
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(138));
        make.top.mas_equalTo(Adapted(8));
        make.right.mas_equalTo(ratioLabel.mas_left).offset(Adapted(-5));
    }];
    self.priceLabel = priceLabel;
    
    UILabel * subPriceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subPriceLabel];
    subPriceLabel.textColor = UIColorFromRGB(0x999999);
    subPriceLabel.font = H11;
    subPriceLabel.text = @"878946552.65";
    [subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel);
        //        make.bottom.mas_equalTo(Adapted(-8));
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(Adapted(8));
        make.right.mas_equalTo(priceLabel);
    }];
    self.subPriceLabel = subPriceLabel;
    
    UIButton *btn = [[UIButton alloc]init];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if (self.selectBlock) {
            self.selectBlock(self.marketIndexRealTimeModel.isOptional);
        }
        
    }];
}

@end
