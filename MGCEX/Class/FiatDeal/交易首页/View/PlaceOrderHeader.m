//
//  PlaceOrderHeader.m
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "PlaceOrderHeader.h"
@interface PlaceOrderHeader ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *logImg;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIImageView *img3;
@end
@implementation PlaceOrderHeader

- (void)setupSubviews{
    
    //店名
    UILabel *titleLab = [[UILabel alloc] init];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(Adapted(15));
        make.centerY.mas_offset(0);
    }];
    titleLab.font = H17;
    titleLab.textColor = kTextColor;
    self.titleLab = titleLab;
    
    //logo
    UIImageView *logImg = [[UIImageView alloc] init];
    [self addSubview:logImg];
    [logImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(titleLab.mas_right).offset(Adapted(5));
        make.centerY.mas_offset(0);
    }];
    logImg.image = IMAGE(@"icon_vip");
    self.logImg = logImg;
    
    ///img1
    UIImageView *img1 = [[UIImageView alloc] init];
    [self addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(Adapted(-15));
        make.centerY.mas_offset(0);
        make.width.height.mas_offset(Adapted(13));
    }];
    self.img1 = img1;
    
    UIImageView *img2 = [[UIImageView alloc] init];
    [self addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(img1.mas_left).offset(Adapted(-5));
        make.centerY.mas_offset(0);
        make.width.height.mas_offset(Adapted(13));
        make.right.mas_offset(Adapted(-15)).priority(200);
    }];
    self.img2 = img2;
    
    UIImageView *img3 = [[UIImageView alloc] init];
    [self addSubview:img3];
    [img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(img2.mas_left).offset(Adapted(-5));
        make.centerY.mas_offset(0);
        make.width.height.mas_offset(Adapted(13));
        make.right.mas_equalTo(img1.mas_left).offset(Adapted(-5)).priority(300);
        make.right.mas_offset(Adapted(-15)).priority(200);
    }];
    self.img3 = img3;
}


- (void)setModel:(FiatDealBuyOrSellModel *)model{
    
    if ([model.payString containsString:@"银行卡"]) {
        self.img1.hidden = NO;
        self.img1.image = IMAGE(@"yhk");
    } else {
        [self.img1 removeFromSuperview];
    }
    if ([model.payString containsString:@"微信"]) {
        self.img2.hidden = NO;
        self.img2.image = IMAGE(@"wx");
    } else {
        [self.img2 removeFromSuperview];
    }
    if ([model.payString containsString:@"支付宝"]) {
        self.img3.hidden = NO;
        self.img3.image = IMAGE(@"zfb");
    }else {
        [self.img3 removeFromSuperview];
    }

    self.titleLab.text = model.title;
    self.logImg.hidden = !model.isVip;
}

@end
