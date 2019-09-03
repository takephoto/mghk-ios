// MGC
//
// FiatZfbWxCell.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatZfbWxCell.h"
@interface FiatZfbWxCell()
@property (nonatomic, strong) UIImageView * logImageV;
@property (nonatomic, strong) UILabel * ZFLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * accountLabel;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, assign) NSInteger cellType;// 2支付宝。3微信
@end

@implementation FiatZfbWxCell

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
    
    //微信支付宝
    UILabel * ZFLabel = [[UILabel alloc]init];
    [self.contentView addSubview:ZFLabel];
    self.ZFLabel = ZFLabel;
    ZFLabel.font = H14;
    ZFLabel.textColor = UIColorFromRGB(0x00B7EE);
    //ZFLabel.text = kLocalizedString(@"支付宝");
    [ZFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageV.mas_right).offset(Adapted(10));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
        make.centerY.mas_equalTo(logImageV);
    }];
    
    //名字
    UILabel *nameTag = [[UILabel alloc] init];
    [self.contentView addSubview:nameTag];
    [nameTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(ZFLabel.mas_bottom).offset(Adapted(17));
    }];
    nameTag.font = H14;
    nameTag.textColor = kAssistTextColor;
    nameTag.text = kLocalizedString(@"卖家姓名");
    
    UILabel * nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.font = H15;
    nameLabel.textColor = kTextColor;
    //nameLabel.text = @"高鹏";
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
        pab.string = kStringIsEmpty(self.zfbModel.payeeName) ? self.wxModel.payeeName : self.zfbModel.payeeName;
        if(pab){
            
            [TTWHUD showCustomMsg:kLocalizedString(@"已成功复制到粘贴板")];
        }
    }];
    
    //账号
    UILabel *accountTag = [[UILabel alloc] init];
    [self.contentView addSubview:accountTag];
    [accountTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_offset(Adapted(60));
        make.top.mas_equalTo(nameTag.mas_bottom).offset(Adapted(17));
    }];
    accountTag.font = H14;
    accountTag.textColor = kAssistTextColor;
    accountTag.tag = 102;
    
    UILabel * accountLabel = [[UILabel alloc]init];
    [self.contentView addSubview:accountLabel];
    self.accountLabel = accountLabel;
    accountLabel.font = H14;
    accountLabel.textColor = kTextColor;
   // accountLabel.text = @"12365489465";
    accountLabel.textAlignment = NSTextAlignmentCenter;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountTag.mas_right).offset(Adapted(15));
        make.centerY.mas_equalTo(accountTag);
    }];
    
    UIButton *accountCpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:accountCpbtn];
    [accountCpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(accountLabel.mas_right).offset(Adapted(35));
        make.centerY.mas_equalTo(accountLabel);
    }];
    [accountCpbtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [accountCpbtn setTitleColor:kRedColor forState:UIControlStateNormal];
    accountCpbtn.titleLabel.font = H14;
    [[accountCpbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = kStringIsEmpty(self.zfbModel.payeeAccount) ? self.wxModel.payeeAccount : self.zfbModel.payeeAccount;
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
        make.top.mas_equalTo(accountTag.mas_bottom).offset(Adapted(17));
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
    
    
    QSButton * btn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    btn.style = QSButtonImageStyleTop;
    btn.space =  Adapted(15);
    [btn setImage:IMAGE(@"icon_jy_code") forState:UIControlStateNormal];
    [btn setTitle:kLocalizedString(@"查看收款码") forState:UIControlStateNormal];
    [btn setTitleColor:red_color forState:UIControlStateNormal];
    btn.titleLabel.font = H14;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(nameLabel);
    }];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
 
}

-(void)btnClick{
    
    if([self.btnDelegate respondsToSelector:@selector(lookCodeImageWithType:)]){
        [self.btnDelegate lookCodeImageWithType:self.cellType];
    }
}

//支付宝
-(void)setZfbModel:(accountZfbModel *)zfbModel{
    _zfbModel = zfbModel;
    self.logImageV.image = IMAGE(@"icon_jy_zfb");
    self.ZFLabel.text = kLocalizedString(@"支付宝");
    self.nameLabel.text = zfbModel.payeeName;
    self.accountLabel.text = zfbModel.payeeAccount;
    self.cellType = 2;
    UILabel *accountTag = [self.contentView viewWithTag:102];
    accountTag.text = kLocalizedString(@"支付宝号");
    
    UILabel *lab =  [self.contentView viewWithTag:101];
    zfbModel.summary = [zfbModel.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(kStringIsEmpty(zfbModel.summary)){
        
        self.noteLabel.hidden = YES;
        lab.hidden = YES;
    } else {
        self.noteLabel.hidden = NO;
        lab.hidden = NO;
        lab.text = kLocalizedString(@"备注");
        self.noteLabel.text = zfbModel.summary;
    }
    
}

//微信
-(void)setWxModel:(accountWxModel *)wxModel{
    _wxModel = wxModel;
    self.logImageV.image = IMAGE(@"icon_jy_wechat");
    self.ZFLabel.text = kLocalizedString(@"微信");
    self.nameLabel.text = wxModel.payeeName;
    self.accountLabel.text = wxModel.payeeAccount;
    self.cellType = 3;
    
    UILabel *accountTag = [self.contentView viewWithTag:102];
    accountTag.text = kLocalizedString(@"微信号");
    
    UILabel *lab =  [self.contentView viewWithTag:101];
    wxModel.summary = [wxModel.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(kStringIsEmpty(wxModel.summary)){
        
        self.noteLabel.hidden = YES;
        lab.hidden = YES;
    } else {
        self.noteLabel.hidden = NO;
        lab.hidden = NO;
        lab.text = kLocalizedString(@"备注");
        self.noteLabel.text = wxModel.summary;
    }
    
}
@end
