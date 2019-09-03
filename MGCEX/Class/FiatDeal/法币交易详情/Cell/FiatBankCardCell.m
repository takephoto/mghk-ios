// MGC
//
// FiatBankCardCell.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatBankCardCell.h"
@interface FiatBankCardCell()

@property (nonatomic, strong) UIImageView * logImageV;
@property (nonatomic, strong) UILabel * bankcardLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * bankNameLabel;
@property (nonatomic, strong) UILabel * cardNumber;
@property (nonatomic, strong) UILabel * cardAddress;
@property (nonatomic, strong) UILabel * noteLabel;


@end
@implementation FiatBankCardCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    UIImageView * logImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:logImageV];
    self.logImageV = logImageV;
    logImageV.image = IMAGE(@"icon_jy_card");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.width.height.mas_equalTo(Adapted(20));
    }];
    
    //银行卡
    UILabel * bankcardLabel = [[UILabel alloc]init];
    [self.contentView addSubview:bankcardLabel];
    self.bankcardLabel = bankcardLabel;
    bankcardLabel.font = H14;
    bankcardLabel.textColor = kMainColor;
    bankcardLabel.text = kLocalizedString(kLocalizedString(@"银行卡支付"));
    [bankcardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageV.mas_right).offset(Adapted(10));
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(logImageV);
    }];
    
    //名字
    UILabel *nameTag = [[UILabel alloc] init];
    [self.contentView addSubview:nameTag];
    [nameTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(bankcardLabel.mas_bottom).offset(Adapted(17));
    }];
    nameTag.font = H14;
    nameTag.textColor = kAssistTextColor;
    nameTag.text = kLocalizedString(@"卖家姓名");

    UILabel * nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.font = H14;
    nameLabel.textColor = kTextColor;
    nameLabel.text = @"";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameTag.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(nameTag);
    }];
    
    UIButton *nameCpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:nameCpbtn];
    [nameCpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(nameLabel.mas_right).offset(Adapted(35));
        make.centerY.mas_equalTo(nameTag);
    }];
    [nameCpbtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [nameCpbtn setTitleColor:kRedColor forState:UIControlStateNormal];
    nameCpbtn.titleLabel.font = H14;
    [[nameCpbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.bankModel.payeeName;
        if(pab){
            
            [TTWHUD showCustomMsg:kLocalizedString(@"已成功复制到粘贴板")];
        }
    }];
    
    //银行名字
    UILabel *bankNameTag = [[UILabel alloc] init];
    [self.contentView addSubview:bankNameTag];
    [bankNameTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(nameTag.mas_bottom).offset(Adapted(17));
    }];
    bankNameTag.font = H14;
    bankNameTag.textColor = kAssistTextColor;
    bankNameTag.text = kLocalizedString(@"银行");
    
    UILabel * bankNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:bankNameLabel];
    self.bankNameLabel = bankNameLabel;
    bankNameLabel.font = H14;
    bankNameLabel.textColor = kTextColor;
   // bankNameLabel.text = @"中国建设银行";
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankNameTag.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(bankNameTag);
    }];
    
    UIButton *bankNameCpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:bankNameCpbtn];
    [bankNameCpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(bankNameLabel.mas_right).offset(Adapted(35));
        make.centerY.mas_equalTo(bankNameTag);
    }];
    [bankNameCpbtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [bankNameCpbtn setTitleColor:kRedColor forState:UIControlStateNormal];
    bankNameCpbtn.titleLabel.font = H14;
    [[bankNameCpbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.bankModel.bankName;
        if(pab){
            
            [TTWHUD showCustomMsg:kLocalizedString(@"已成功复制到粘贴板")];
        }
    }];
    
    //银行支行名称
    UILabel *cardAddrTag = [[UILabel alloc] init];
    [self.contentView addSubview:cardAddrTag];
    [cardAddrTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(bankNameTag.mas_bottom).offset(Adapted(17));
    }];
    cardAddrTag.font = H14;
    cardAddrTag.textColor = kAssistTextColor;
    cardAddrTag.text = kLocalizedString(@"支行");
    
    UILabel * cardAddress = [[UILabel alloc]init];
    [self.contentView addSubview:cardAddress];
    self.cardAddress = cardAddress;
    cardAddress.font = H14;
    cardAddress.numberOfLines = 0;
    cardAddress.textColor = kTextColor;
    [cardAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cardAddrTag.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(cardAddrTag);
    }];
    
    UIButton *cardAddrCpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cardAddrCpbtn];
    [cardAddrCpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cardAddress.mas_right).offset(Adapted(35));
        make.left.mas_offset(Adapted(-15)).priority(100);
        make.centerY.mas_equalTo(cardAddrTag);
    }];
    [cardAddrCpbtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [cardAddrCpbtn setTitleColor:kRedColor forState:UIControlStateNormal];
    cardAddrCpbtn.titleLabel.font = H14;
    [[cardAddrCpbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.bankModel.bankBrachName;
        if(pab){
            
            [TTWHUD showCustomMsg:kLocalizedString(@"已成功复制到粘贴板")];
        }
    }];
    
    
    //银行卡号
    UILabel *cardNumTag = [[UILabel alloc] init];
    [self.contentView addSubview:cardNumTag];
    [cardNumTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(cardAddrTag.mas_bottom).offset(Adapted(17));
    }];
    cardNumTag.font = H14;
    cardNumTag.textColor = kAssistTextColor;
    cardNumTag.text = kLocalizedString(@"银行卡号");
    
    UILabel * cardNumber = [[UILabel alloc]init];
    [self.contentView addSubview:cardNumber];
    self.cardNumber = cardNumber;
    cardNumber.font = H14;
    cardNumber.textColor = kTextColor;
    //cardNumber.text = @"48946548646556456545";
    [cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardNumTag.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(cardNumTag);
    }];
    
    UIButton *cardNumCpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cardNumCpbtn];
    [cardNumCpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cardNumber.mas_right).offset(Adapted(35));
        make.centerY.mas_equalTo(cardNumTag);
    }];
    [cardNumCpbtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [cardNumCpbtn setTitleColor:kRedColor forState:UIControlStateNormal];
    cardNumCpbtn.titleLabel.font = H14;
    [[cardNumCpbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.bankModel.payeeAccount;
        if(pab){
            
            [TTWHUD showCustomMsg:kLocalizedString(@"已成功复制到粘贴板")];
        }
    }];
    
    //备注
    UILabel *noteTag = [[UILabel alloc] init];
    [self.contentView addSubview:noteTag];
    [noteTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(cardNumTag.mas_bottom).offset(Adapted(17));
    }];
    noteTag.font = H14;
    noteTag.textColor = kAssistTextColor;
    noteTag.tag = 101;
    
    UILabel * noteLabel = [[UILabel alloc]init];
    [self.contentView addSubview:noteLabel];
    self.noteLabel = noteLabel;
    noteLabel.font = H13;
    noteLabel.numberOfLines = 0;
    noteLabel.textColor = kTextColor;
   // noteLabel.text = @"打哈就是看到哈UI大师大手大脚啊等哈空间的哈大师大师教大家大家看大家看的";
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(noteTag);
        make.bottom.mas_equalTo(self.contentView).offset(Adapted(-13));
    }];
    
}

-(void)setBankModel:(accountBankModel *)bankModel{
    _bankModel = bankModel;
    self.nameLabel.text = bankModel.payeeName;
    self.bankNameLabel.text = bankModel.bankName;
    self.cardNumber.text = bankModel.payeeAccount;
    self.cardAddress.text = bankModel.bankBrachName;
    UILabel *lab =  [self.contentView viewWithTag:101];
    bankModel.summary = [bankModel.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(kStringIsEmpty(bankModel.summary)){
        
        self.noteLabel.hidden = YES;
        lab.hidden = YES;
    } else {
        self.noteLabel.hidden = NO;
        lab.hidden = NO;
        lab.text = kLocalizedString(@"备注");
        self.noteLabel.text = bankModel.summary;
    }
}

@end
