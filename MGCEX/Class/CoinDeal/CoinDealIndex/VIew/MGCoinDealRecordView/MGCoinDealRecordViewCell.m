//
//  MGCoinDealRecordViewCell.m
//  TestDemo
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 Joblee. All rights reserved.
//

#import "MGCoinDealRecordViewCell.h"

@implementation MGCoinDealRecordViewCell

-(void)setUpViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    float height = Adapted(30);
    self.backgroundColor = kBackAssistColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *numberBgLab = [[UILabel alloc]init];
    [self.contentView addSubview:numberBgLab];
    self.numberBgLab = numberBgLab;
    numberBgLab.backgroundColor = UIColorFromRGB(0xff413437);
    [numberBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(Adapted(2));
        make.bottom.mas_equalTo(Adapted(-2));
        make.width.mas_equalTo(10);
    }];
    self.numberBgLab = numberBgLab;
    
    
    UILabel *priceLab = [[UILabel alloc]init];
    [self.contentView addSubview:priceLab];
    priceLab.textColor = kRedColor;
    //priceLab.text = [NSString stringWithFormat:@"%.2d",rand() % 2000];
    priceLab.font = [UIFont systemFontOfSize:11];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(8));
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(self.width/2.0);
    }];
    self.priceLab = priceLab;
    
 
    UILabel *numberLab = [[UILabel alloc]init];
    [self.contentView addSubview:numberLab];
    numberLab.textColor = UIColorFromRGB(0x969696);
    numberLab.textAlignment = NSTextAlignmentRight;
    //numberLab.text = @"53256789";
    numberLab.font = [UIFont systemFontOfSize:11];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(Adapted(-8));
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(self.width/2.0);
    }];
    self.numberLab = numberLab;
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.hidden = YES;
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView);
    }];
 
}

-(void)setModel:(UnsettledGearModel *)model{
    _model = model;
    
    //特别需求：关于BTC的交易对，数量保留四位小数，大于1000，则用k作为单位，保留1位小数
    if([model.market isEqualToString:@"BTC"] || [model.symbol isEqualToString:@"BTC"]){
        if([model.value doubleValue]>=1000){
            self.numberLab.text = [NSString stringWithFormat:@"%.1fk",[model.value doubleValue]/1000.0f];
        }else{
            self.numberLab.text = [model.value keepDecimal:4];
        }
    }else{
        self.numberLab.text = [model.value doubleValue]<=0?@"--":model.value.toThousandUnit;
    }

    self.priceLab.text = [model.price doubleValue]<=0?@"--":model.price;
    if(![self.priceLab.text isEqualToString:@"--"]){
        self.priceLab.text = [self.priceLab.text keepDecimal:model.limitNumber];
  
    }
    self.priceLab.textColor = model.labelColor;
    self.numberBgLab.backgroundColor = model.backColor;
    
    [self.numberBgLab mas_updateConstraints:^(MASConstraintMaker *make) {
        NSString *scaleStr = [NSString stringWithFormat:@"%f",model.scaleValue];
        NSString *scale = kNotNumber(scaleStr);
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-MAIN_SCREEN_WIDTH/2.0-Adapted(20)-Adapted(3))*[scale floatValue]);
    }];
}

@end
