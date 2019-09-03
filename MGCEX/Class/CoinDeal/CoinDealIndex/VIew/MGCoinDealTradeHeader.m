//
//  MGCoinDealTradeHeader.m
//  MGCEX
//
//  Created by HFW on 2018/7/20.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCoinDealTradeHeader.h"

@interface MGCoinDealTradeHeader ()

@property (nonatomic, strong) UILabel * midLabel;
@property (nonatomic, strong) UILabel * submidLabel;
@property (nonatomic, strong) UILabel * rightLabel;

@end
@implementation MGCoinDealTradeHeader

- (void)setupSubviews{
    
    UILabel * midLabel = [[UILabel alloc]init];
    [self addSubview:midLabel];
    self.midLabel = midLabel;
    midLabel.textColor = kTextColor;
    midLabel.font = H12;
    //midLabel.text = @"0.014528745";
    midLabel.textAlignment = NSTextAlignmentLeft;
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(10));
        make.bottom.mas_equalTo(self.mas_centerY).offset(Adapted(3.0));
    }];
    
    UILabel * submidLabel = [[UILabel alloc]init];
    [self addSubview:submidLabel];
    self.submidLabel = submidLabel;
    submidLabel.textColor = kTextColor;
    submidLabel.font = H10;
    //submidLabel.text = @"58.25 CNY";
    submidLabel.textAlignment = NSTextAlignmentLeft;
    [submidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midLabel);
        make.top.mas_equalTo(midLabel.mas_bottom).offset(Adapted(3));
    }];

    UILabel * rightLabel = [[UILabel alloc]init];
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
    rightLabel.textColor = kRedColor;
    rightLabel.font = H12;
    //rightLabel.text = @"-538.88%";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(Adapted(-8));  
    }];
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.midLabel.text = price;
}

- (void)setCnyPrice:(NSString *)cnyPrice{
    
    _cnyPrice = cnyPrice;
    self.submidLabel.text = cnyPrice;
}

- (void)setRose:(NSString *)rose{
    
    _rose = rose;
    self.rightLabel.text = rose;
    
    if([rose containsString:@"-"]){
        self.rightLabel.textColor = kRedColor;
    }else if([rose containsString:@"+"]){
        self.rightLabel.textColor = kGreenColor;
    }
}

@end
