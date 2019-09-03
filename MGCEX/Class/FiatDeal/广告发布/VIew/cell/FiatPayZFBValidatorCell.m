// MGC
//
// FiatPayZFBValidatorCell.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPayZFBValidatorCell.h"
@interface FiatPayZFBValidatorCell(){
}
//姓名
@property (nonatomic, strong) UILabel * ZFLabel;
//账户名称
@property (nonatomic, strong) UILabel * nameLabel;
//账号
@property (nonatomic, strong) UILabel * accountLabel;
//备注
@property (nonatomic, strong) UILabel * noteLabel;
@end
@implementation FiatPayZFBValidatorCell
- (void)bindModel{
    @weakify(self);
    [RACObserve(self, model)subscribeNext:^(id x) {
        @strongify(self);
        self.ZFLabel.text = self.model.bankName;
        self.nameLabel.text = self.model.payeeName;
        self.accountLabel.text = self.model.payeeAccount;
        self.noteLabel.text = self.model.summary;
    }];
}
-(void)setUpViews{
    
    self.backgroundColor = white_color;
    UIButton * logImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:logImageBtn];
    [self.contentView bringSubviewToFront:logImageBtn];
    [logImageBtn mg_setEnlargeEdgeWithTop:Adapted(20) right:Adapted(100) bottom:Adapted(100) left:Adapted(15)];
    [logImageBtn setImage:IMAGE(@"icon_choice_more_off") forState:UIControlStateNormal];
    [logImageBtn setImage:IMAGE(@"icon_choice_more_on") forState:UIControlStateSelected];
    [logImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(13));
        make.top.mas_equalTo(Adapted(15));
        make.width.height.mas_equalTo(Adapted(20));
    }];
    [logImageBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.logImageBtn = logImageBtn;
    //微信支付宝
    self.ZFLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.ZFLabel];
    self.ZFLabel.font = H15;
    self.ZFLabel.textColor = kTextColor;
//    self.ZFLabel.text = kLocalizedString(@"支付宝");
    [self.ZFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageBtn.mas_right).offset(Adapted(10));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
        make.centerY.mas_equalTo(logImageBtn);
    }];
    
    //账户名称
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = H15;
    self.nameLabel.textColor = kTextColor;
//    self.nameLabel.text = @"高鹏阿斯";
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo([UIView getLabelHeightByWidth:20 Title:self.nameLabel.text font:H15]);
        make.top.mas_equalTo(logImageBtn.mas_bottom).offset(Adapted(13));
    }];
    
    //账号
    self.accountLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.accountLabel];
    self.accountLabel.font = H15;
    self.accountLabel.textColor = kTextColor;
//    self.accountLabel.text = @"123654894131";
    self.accountLabel.textAlignment = NSTextAlignmentLeft;
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    
    //备注
    self.noteLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.noteLabel];
    self.noteLabel.font = H13;
    self.noteLabel.numberOfLines = 0;
    self.noteLabel.textColor = k99999Color;
//    self.noteLabel.text = @"打哈就是看到哈UI大师大手大脚啊等哈空间的哈大师大师教大家大家看大家看的";
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(Adapted(13));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(Adapted(0));
    }];
    self.lineView = lineView;
}


-(void)changeStatus:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.selectBlock(btn.selected);
}

@end
