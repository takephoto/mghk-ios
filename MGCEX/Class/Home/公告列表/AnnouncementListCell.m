// MGC
//
// AnnouncementListCell.m
// MGCEX
//
// Created by MGC on 2018/7/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AnnouncementListCell.h"

@interface AnnouncementListCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@end

@implementation AnnouncementListCell

-(void)setUpViews{
    
    self.contentView.backgroundColor = kBackAssistColor;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UILabel * timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.textColor = k99999Color;
    timeLabel.font = H13;
    timeLabel.numberOfLines = 1;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(10));
        make.right.mas_equalTo(Adapted(-15));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
    
}

-(void)setModel:(HomeIndexModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    
    self.timeLabel.text = [model.notceTime time_timestampToStringFmt:@"YYYY-MM-dd HH:MM:ss"];
    
}

@end
