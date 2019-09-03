// MGC
//
// RechargeAddressCell.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "RechargeAddressCell.h"
#import "HGDQQRCodeView.h"
@interface RechargeAddressCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel *warmPromptLabel1;
@end
@implementation RechargeAddressCell
- (void)bindModel
{
    @weakify(self);
    [RACObserve(self, addressStr)subscribeNext:^(id x) {
        @strongify(self);
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocalizedString(@"请将"),self.tradeCode,kLocalizedString(@"转入如下地址")];
        self.warmPromptLabel1.text = [NSString stringWithFormat:@"%@%@ %@%@%@%@%@",kLocalizedString(@"• 请通过 "),self.tradeCode,kLocalizedString(@"客户端或在线钱包将您需要充值的"),self.tradeCode,kLocalizedString(@"数目发送到该地址。发送完成后，系统会自动在此交易获得 12 个确认后将该笔虚拟币充值到您在本站的账户，12 个确认需要大约 0.5 到 1 小时时间，请耐心等待。 同一个地址可多次充值，不影响到账，最小充值金额0.0001。\n• 请务向上述地址充值任何非"),self.tradeCode,@"资产，否则资产将不可找回。\n• 您充值上述地址后，需要整个网络节点的确认，1次网络确认后到账，6次网络确认后可提币。\n• 您的充值地址不会经常改变，可以重复充值；如有更改，我们会尽量通过网站公告或邮件通知您。"];
        self.codeArrress.text = x;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HGDQQRCodeView creatQRCodeWithURLString:x superView:self.codeImageV logoImage:nil logoImageSize:CGSizeZero logoImageWithCornerRadius:0];
        });
        
        
    }];
    
}
-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UIView * segmentationView0 = [[UIView alloc]init];
    [self.contentView addSubview:segmentationView0];
    segmentationView0.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [segmentationView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(Adapted(6));
        
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = kBackAssistColor;
    titleLabel.font = H15;
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(segmentationView0.mas_bottom).offset(Adapted(17));
        make.right.mas_equalTo(Adapted(-100));
    }];
    self.titleLabel = titleLabel;
    
    UIButton * copyBtn = [UIButton buttonWithType:0];
    [self.contentView addSubview:copyBtn];
    copyBtn.clipsToBounds = YES;
    copyBtn.layer.borderColor = kRedColor.CGColor;
    copyBtn.layer.borderWidth = 1;
    copyBtn.layer.cornerRadius = Adapted(28)/2.0;
    [copyBtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [copyBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(segmentationView0.mas_bottom).offset(Adapted(12));
        make.width.mas_equalTo(Adapted(64));
        make.height.mas_equalTo(Adapted(28));
    }];

    [copyBtn mg_addTapBlock:^(UIButton *button) {
     
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.codeArrress.text];
        if (pasteboard == nil) {
            [TTWHUD showCustomMsg:kLocalizedString(@"复制失败")];
        }else
        {
            [TTWHUD showCustomMsg:kLocalizedString(@"复制成功")];
        }
        
        
    }];
    
    //币种地址
    UILabel * codeArrress = [[UILabel alloc]init];
    [self.contentView addSubview:codeArrress];
    codeArrress.numberOfLines = 0;
    codeArrress.font = H14;
    [codeArrress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(25);
    }];
    self.codeArrress = codeArrress;
    
    UIView * segmentationView1 = [[UIView alloc]init];
    [self.contentView addSubview:segmentationView1];
    segmentationView1.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [segmentationView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(codeArrress.mas_bottom).offset(Adapted(20));
        make.height.mas_equalTo(Adapted(6));
    }];
    
    UILabel * subLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLabel];
    subLabel.textColor = kBackAssistColor;
    subLabel.font = H15;
    subLabel.text = kLocalizedString(@"或者扫描二维码");
    subLabel.numberOfLines = 0;
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(segmentationView1.mas_bottom).offset(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        
    }];
    

    //二维码
    UIImageView * codeImageV = [[UIImageView alloc]init];
    codeImageV.image = [UIImage imageWithColor:UIColorFromRGB(0xe7e7e7)];
    [self.contentView addSubview:codeImageV];

    [codeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(Adapted(180));
        make.top.mas_equalTo(subLabel.mas_bottom).offset(Adapted(30));

    }];
    self.codeImageV = codeImageV;
    
    UIView * segmentationView2 = [[UIView alloc]init];
    [self.contentView addSubview:segmentationView2];
    segmentationView2.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [segmentationView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(codeImageV.mas_bottom).offset(Adapted(30));
        make.height.mas_equalTo(Adapted(6));

    }];

    //温馨提示
    UILabel * warmTitle = [[UILabel alloc]init];
    [self.contentView addSubview:warmTitle];
    warmTitle.textColor = kBackAssistColor;
    warmTitle.font = H15;
    warmTitle.text = kLocalizedString(@"温馨提示");
    warmTitle.numberOfLines = 0;
    [warmTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(segmentationView2.mas_bottom).offset(Adapted(15));

    }];

    UILabel * warmPromptLabel1 = [[UILabel alloc]init];
    [self.contentView addSubview:warmPromptLabel1];
    warmPromptLabel1.textColor = kBackAssistColor;
    warmPromptLabel1.numberOfLines = 0;
    warmPromptLabel1.font = H15;
    [warmPromptLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(warmTitle.mas_bottom).offset(Adapted(18));
        make.bottom.mas_equalTo(self.contentView).offset(Adapted(-50));
    }];
    self.warmPromptLabel1 = warmPromptLabel1;
};

@end
