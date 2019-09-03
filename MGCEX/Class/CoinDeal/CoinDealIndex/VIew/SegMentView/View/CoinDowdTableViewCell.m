// MGC
//
// CoinDowdTableViewCell.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDowdTableViewCell.h"


@interface CoinDowdTableViewCell()

@property (nonatomic, strong) UIImageView * logImageV;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * gouImageV;
@end


@implementation CoinDowdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kNavTintColor;
        [self setUpViews];

    }
    return self;
}


-(void)setUpViews{
//    UIImageView * logImageV = [[UIImageView alloc]init];
//    [self.contentView addSubview:logImageV];
//    logImageV.image = IMAGE(@"");
//    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(Adapted(15));
//        make.centerY.mas_equalTo(self);
//        make.width.height.mas_equalTo(Adapted(20));
//    }];
//    self.logImageV = logImageV;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = k99999Color;
    titleLabel.font = H15;
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(Adapted(-50));
    }];
    self.titleLabel = titleLabel;
    
    UIImageView * gouImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:gouImageV];
    gouImageV.image = IMAGE(@"gou");
    [gouImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(15));
        make.height.mas_equalTo(Adapted(13));
    }];
    gouImageV.hidden = YES;
    self.gouImageV = gouImageV;
}



-(void)setModel:(CoinDealPrivateModel *)model{
    _model = model;

    //self.logImageV.image = [UIImage imageNamed:model.image];

    if(model.selected == YES){
        self.titleLabel.textColor = kTextColor;
        self.gouImageV.hidden = NO;
    }else{
        self.titleLabel.textColor = k99999Color;
        self.gouImageV.hidden = YES;
    }
    self.titleLabel.text = model.title;
    self.gouImageV.hidden = !model.selected;
}

@end
