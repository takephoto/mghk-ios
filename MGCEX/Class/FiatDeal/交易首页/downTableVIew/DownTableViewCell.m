// MGC
//
// DownTableViewCell.m
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "DownTableViewCell.h"
@interface DownTableViewCell()
@property (nonatomic, strong) UIImageView * logImageV;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * gouImageV;
@end

@implementation DownTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kNavTintColor;
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    UIImageView * logImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:logImageV];
    logImageV.image = IMAGE(@"zfb");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(Adapted(20));
    }];
    self.logImageV = logImageV;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = k99999Color;
    titleLabel.font = H15;
    titleLabel.text = @"MGC/CNY";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageV.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(Adapted(-50));
    }];
    self.titleLabel = titleLabel;
    
    UIImageView * gouImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:gouImageV];
    gouImageV.image = IMAGE(@"baigou");
    [gouImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(Adapted(20));
    }];
    gouImageV.hidden = YES;
    self.gouImageV = gouImageV;
}

-(void)setCellStyle:(NSInteger)cellStyle{
    _cellStyle = cellStyle;
    if(_cellStyle == 0){
        [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
        }];
        
    }else{
        [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
        }];
    }
}

@end
