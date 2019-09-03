// MGC
//
// FiatPayCardValidatorCell.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPayCardValidatorCell.h"
@interface FiatPayCardValidatorCell(){
    //姓名
    UILabel * nameLabel;
    //银行名字
    UILabel * bankNameLabel;
    //银行卡号
    UILabel * cardNumber;
    //银行支行名称
    UILabel * cardAddress;
    //备注
    UILabel * noteLabel;
}
@end
@implementation FiatPayCardValidatorCell

- (void)bindModel{
    @weakify(self);
    [RACObserve(self, model)subscribeNext:^(id x) {
        @strongify(self);
        self->nameLabel.text = self.model.payeeName;
        self->bankNameLabel.text = self.model.bankName;
        self->cardNumber.text = self.model.payeeAccount;
        self->cardAddress.text = self.model.bankBrachName;
        self->noteLabel.text = self.model.summary;
    }];
}
-(void)setUpViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = white_color;
    //选择框
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
    //银行卡
    UILabel * bankcardLabel = [[UILabel alloc]init];
    [self.contentView addSubview:bankcardLabel];
    bankcardLabel.font = H15;
    bankcardLabel.textColor = kBackAssistColor;
    bankcardLabel.text = kLocalizedString(@"银行卡");
    [bankcardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageBtn.mas_right).offset(Adapted(10));
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(logImageBtn);
    }];
    
    //名字
    nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    nameLabel.font = H15;
    nameLabel.textColor = kBackAssistColor;
    //nameLabel.text = @"搞基吧";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(bankcardLabel.mas_bottom).offset(Adapted(13));
    }];
    
    //银行名字
    bankNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:bankNameLabel];
    bankNameLabel.font = H15;
    bankNameLabel.textColor = kBackAssistColor;
    //bankNameLabel.text = @"中国建设银行";
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self->nameLabel.mas_bottom).offset(Adapted(13));
    }];
    
    //银行卡号
    cardNumber = [[UILabel alloc]init];
    [self.contentView addSubview:cardNumber];
    cardNumber.font = H15;
    cardNumber.textColor = kBackAssistColor;
    //cardNumber.text = @"48946548646556456545";
    [cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self->bankNameLabel.mas_bottom).offset(Adapted(13));
    }];
    
    //银行支行名称
    cardAddress = [[UILabel alloc]init];
    [self.contentView addSubview:cardAddress];
    cardAddress.font = H15;
    cardAddress.numberOfLines = 0;
    cardAddress.textColor = kBackAssistColor;
    //cardAddress.text = @"结婚登记啊谁都会啊大叔的空间啊和大家看圣诞节啊看到噶时间看到噶睡噶回家";
    [cardAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self->cardNumber.mas_bottom).offset(Adapted(13));
    }];
    
    //备注
    noteLabel = [[UILabel alloc]init];
    [self.contentView addSubview:noteLabel];
    noteLabel.font = H13;
    noteLabel.numberOfLines = 0;
    noteLabel.textColor = k99999Color;
    //noteLabel.text = @"打哈就是看到哈UI大师大手大脚啊等哈空间的哈大师大师教大家大家看大家看的";
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(self->cardAddress.mas_bottom).offset(Adapted(13));
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
