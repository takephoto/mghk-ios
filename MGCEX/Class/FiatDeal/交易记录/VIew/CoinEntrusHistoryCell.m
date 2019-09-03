// MGC
//
// CoinEntrusHistoryCell.m
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinEntrusHistoryCell.h"

@interface CoinEntrusHistoryCell()

@property (nonatomic, strong) UILabel *queueLabel;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *dealLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *riceStrLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *numberStrLab;
@property (nonatomic, strong) UILabel * timeStrLab;



@property (nonatomic, strong) UILabel *timeLab2;
@property (nonatomic, strong) UILabel *priceLab2;
@property (nonatomic, strong) UILabel *riceStrLab2;
@property (nonatomic, strong) UILabel *numberLab2;
@property (nonatomic, strong) UILabel *numberStrLab2;
@property (nonatomic, strong) UILabel * timeStrLab2;

@property (nonatomic, assign) float heightSpace;
@end

@implementation CoinEntrusHistoryCell

-(void)setUpViews{
    
    self.heightSpace = Adapted(50);
    
    self.contentView.backgroundColor = white_color;
    self.backgroundColor = kBackGroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //币种队列
    UILabel *queueLabel = [self getLabel];
    //queueLabel.text = @"BYC/BTC";
    queueLabel.font = H15;
    self.queueLabel = queueLabel;
    [self.contentView addSubview:queueLabel];
    queueLabel.textColor = kTextColor;
    [queueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(21));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset((kScreenW - Adapted(24) - Adapted(30)) / 3.0);
    }];
    
    
    //买入/卖出
    UILabel *dealLab = [self getLabel];
    //dealLab.text = @"买入";
    dealLab.font = [UIFont systemFontOfSize:15];
    dealLab.textColor = kGreenColor;
    [self.contentView addSubview:dealLab];
    self.dealLab = dealLab;
    [dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(queueLabel);
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];
    
    for(int i=0;i<2;i++){
        float space = Adapted(15);
        //时间
        UILabel *timeLab = [self getLabel];
        //timeLab.text = @"9:57 12/18";
        timeLab.font = H13;
        timeLab.textColor = kTextColor;
//        timeLab.numberOfLines = 0;
        timeLab.tag = 10+i;
//        timeLab.numberOfLines = 2;
        timeLab.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:timeLab];
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(queueLabel.mas_bottom).offset(space+i*self.heightSpace);
            make.left.mas_equalTo(queueLabel);
            make.width.mas_offset((kScreenW - Adapted(24) - Adapted(30)) / 3.0);
            make.height.mas_offset(Adapted(22));
        }];
        //时间String
        UILabel *timeStrLab = [self getLabel];
        timeStrLab.text =kLocalizedString(@"时间");
        timeStrLab.font = H11;
        timeStrLab.textColor = k99999Color;
        timeStrLab.tag = 20+i;
        [self.contentView addSubview:timeStrLab];
        [timeStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(5));
            make.height.mas_equalTo(Adapted(13));
            make.left.mas_equalTo(queueLabel);
        }];

        //委托价
        UILabel *priceLab = [self getLabel];
        //priceLab.text = @"0.432432423";
        priceLab.font = H15;
        priceLab.textColor = kGreenColor;
        [self.contentView addSubview:priceLab];
        priceLab.tag = 30+i;
//        priceLab.numberOfLines = 2;
        priceLab.adjustsFontSizeToFitWidth = YES;
        priceLab.textAlignment = NSTextAlignmentLeft;
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(queueLabel.mas_bottom).offset(space+i*self.heightSpace);
            make.left.mas_equalTo(dealLab);
            make.width.mas_offset((kScreenW - Adapted(24) - Adapted(30)) / 3.0);
            make.height.mas_offset(Adapted(22));
        }];

        //委托价String
        UILabel *riceStrLab = [self getLabel];
        riceStrLab.text =  kLocalizedString(@"委托价");
        riceStrLab.font = H11;
        riceStrLab.textColor = k99999Color;
        [self.contentView addSubview:riceStrLab];
        riceStrLab.tag = 40+i;
        [riceStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(5));
            make.left.mas_equalTo(priceLab);
        }];

        //委托量
        UILabel *numberLab = [self getLabel];
        numberLab.text = @"  ";
        numberLab.font = H13;
        numberLab.textColor = kTextColor;
        [self.contentView addSubview:numberLab];
        numberLab.tag = 50+i;
//        numberLab.numberOfLines = 2;
        numberLab.adjustsFontSizeToFitWidth = YES;
        numberLab.textAlignment = NSTextAlignmentRight;
        [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(queueLabel.mas_bottom).offset(space+i*self.heightSpace);
            make.right.mas_equalTo(Adapted(-12));
            make.width.mas_offset((kScreenW - Adapted(24) - Adapted(30)) / 3.0);
            make.height.mas_offset(Adapted(22));
        }];
        //委托价String
        UILabel *numberStrLab = [self getLabel];
        numberStrLab.text = kLocalizedString(@"委托量");
        numberStrLab.font = H11;
        numberStrLab.textAlignment = NSTextAlignmentRight;
        numberStrLab.textColor = k99999Color;
        [self.contentView addSubview:numberStrLab];
        numberStrLab.tag = 60+i;
        [numberStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLab.mas_bottom).offset(Adapted(5));
            make.right.mas_equalTo(Adapted(-12));
            //        make.bottom.mas_equalTo(Adapted(-16));
        }];


    }

    self.timeLab2 = [self viewWithTag:10];
    self.timeStrLab2 = [self viewWithTag:20];
    self.priceLab = [self viewWithTag:30];
    self.riceStrLab = [self viewWithTag:40];
    self.numberLab = [self viewWithTag:50];
    self.numberStrLab = [self viewWithTag:60];
    
    self.timeLab = [self viewWithTag:11];
    self.timeStrLab = [self viewWithTag:21];
    self.priceLab2 = [self viewWithTag:31];
    self.priceLab2.hidden = YES;
    self.riceStrLab2 = [self viewWithTag:41];
    self.riceStrLab2.hidden = YES;
    self.numberLab2 = [self viewWithTag:51];
    self.numberStrLab2 = [self viewWithTag:61];
    

    
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

-(void)setModel:(CoinEntrusHistoryModelList *)model{
    _model = model;
    
    self.queueLabel.text = [NSString stringWithFormat:@"%@/%@",model.symbol,model.market];
    self.dealLab.text = model.buySellString;
    self.dealLab.textColor = model.buySellColor;
    
    self.timeLab.text = model.amount;
    self.timeStrLab.text = kLocalizedString(@"时间");
    self.priceLab.text = model.price;
    self.priceLab.textColor = model.buySellColor;
    NSString * str1 = kLocalizedString(@"委托价");
    NSString * str2 = kLocalizedString(@"委托量");
    self.riceStrLab.text = [NSString stringWithFormat:@"%@(%@)",str1,model.market];
    self.numberLab.text = model.volume;
    self.numberStrLab.text = [NSString stringWithFormat:@"%@(%@)",str2,model.symbol];

    self.timeLab2.text = model.finishDate;
    NSString * str3 = kLocalizedString(@"交易总额");
    self.timeStrLab.text = [NSString stringWithFormat:@"%@(%@)",str3,model.market];
    self.priceLab2.text = kStringIsEmpty(model.averagePrice)?@"   ":model.averagePrice;
    self.priceLab2.textColor = model.buySellColor;
    NSString * str4 = kLocalizedString(@"交易均价");
    self.riceStrLab2.text = [NSString stringWithFormat:@"%@(%@)",str4,model.market];
    self.numberLab2.text = [model.doneVolume keepDecimal:8].removeFloatAllZero;
    NSString * str5 = kLocalizedString(@"交易量");
    self.numberStrLab2.text = [NSString stringWithFormat:@"%@(%@)",str5,model.symbol];
}

@end
