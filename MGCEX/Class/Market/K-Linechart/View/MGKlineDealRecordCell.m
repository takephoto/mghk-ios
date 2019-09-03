//
//  MGKlineDealRecordCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGKlineDealRecordCell.h"

@implementation MGKlineDealRecordCell

-(void)bindModel
{
    @weakify(self);
    [RACObserve(self, model)subscribeNext:^(MGKLinechartRecordModel *x) {
        @strongify(self);
        if (x) {
            if ([x.buysell isEqualToString:@"1"]) {
                self.dealLab.text = kLocalizedString(@"买入");
                self.dealLab.textColor = self.priceLab.textColor = kGreenColor;
            }else{
                self.dealLab.text = kLocalizedString(@"卖出");
                self.dealLab.textColor = self.priceLab.textColor = kRedColor;
            }
            
            self.priceLab.text = [x.price keepDecimal:8];
            self.numberLab.text = [x.volume autoLimitDecimals];
            self.timeLab.text = x.time;
        }
        
    }];
}

-(void)setUpViews
{
    self.backgroundColor = kKLineBGColor;
    
    //时间
    UILabel *timeLab = [self getLabel];
    timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(Adapted(0));
        make.left.mas_equalTo(Adapted(12));
        make.height.mas_equalTo(Adapted(40));
    }];
    self.timeLab = timeLab;
    
    //买/卖
    UILabel *dealLab = [self getLabel];
    dealLab.textColor = kGreenColor;
    [self.contentView addSubview:dealLab];
    [dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(Adapted(0));
        make.left.mas_equalTo(kScreenW*0.31);
    }];
    self.dealLab = dealLab;
    
    //价格
    UILabel *priceLab = [self getLabel];
    priceLab.textColor = kGreenColor;
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.mas_equalTo(Adapted(0));
        make.left.mas_equalTo(kScreenW*0.48);
    }];
    self.priceLab = priceLab;
    //数量
    UILabel *numberLab = [self getLabel];
    [self.contentView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(Adapted(0));
        make.right.mas_equalTo(Adapted(-12));
    }];
    self.numberLab = numberLab;
    
}
- (UILabel *)getLabel
{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor whiteColor];
    return lab;
}

/**
 满足某种类型的特殊处理
 */
- (void)changeColor{
    self.dealLab.textColor = self.priceLab.textColor = self.numberLab.textColor = self.timeLab.textColor = kAssistColor;
    self.dealLab.font = self.priceLab.font = self.numberLab.font = self.timeLab.font = H13;
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    self.dealLab.text = kLocalizedString(@"类型");
    self.numberLab.text = kLocalizedString(@"数量");
    self.timeLab.text = kLocalizedString(@"时间");
}
@end
