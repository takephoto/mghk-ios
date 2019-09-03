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
    //logImageV.image = IMAGE(@"");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(Adapted(20));
    }];
    self.logImageV = logImageV;
    self.logImageV.layer.cornerRadius = Adapted(10);
    self.logImageV.clipsToBounds = YES;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = k99999Color;
    titleLabel.font = H15;
    //titleLabel.text = @"MGC/CNY";
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
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(15));
        make.height.mas_equalTo(Adapted(13));
    }];
    gouImageV.hidden = YES;
    self.gouImageV = gouImageV;
}

-(void)setCellStyle:(NSInteger)cellStyle{
    _cellStyle = cellStyle;
    if(_cellStyle == 0){

        [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
        }];
        
    }else{
        [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
        }];
    }
}


-(void)setModel:(downTableModel *)model{
    _model = model;
    if(self.cellStyle == 0){
       // self.logImageV.image = [UIImage imageNamed:model.image];
        [self.logImageV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageWithColor:kBackGroundColor]];
        
        [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
        }];
    }else{
        if(model.image){
            self.logImageV.image = [UIImage imageNamed:@""];
            [self.logImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(0);
            }];
        }else{
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapted(15));
            }];
        }
        
    }
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
