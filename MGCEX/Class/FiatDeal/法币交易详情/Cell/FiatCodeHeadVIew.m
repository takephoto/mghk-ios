// MGC
//
// FiatCodeHeadVIew.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatCodeHeadVIew.h"

@implementation FiatCodeHeadVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    UILabel * leftLabel = [[UILabel alloc]init];
    [self addSubview:leftLabel];
    leftLabel.textColor = UIColorFromRGB(0x666666);
    leftLabel.font = H15;
    leftLabel.text = kLocalizedString(@"付款标识码:");
    leftLabel.numberOfLines = 0;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
        
    }];

    UILabel * codeLabel = [[UILabel alloc]init];
    [self addSubview:codeLabel];
    self.codeLabel = codeLabel;
    codeLabel.textColor = kRedColor;
    codeLabel.numberOfLines = 0;
    codeLabel.font = H16;
    codeLabel.textAlignment = NSTextAlignmentRight;
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-40));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.jiantouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_jiantouBtn];
    [_jiantouBtn setImage:IMAGE(@"jt_xs_down") forState:UIControlStateNormal];
    [_jiantouBtn setImage:IMAGE(@"jt_xs_up") forState:UIControlStateSelected];
    [_jiantouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(10));
        make.height.mas_equalTo(Adapted(6));
    }];

    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UIColorFromRGBA(0xdddddd, 0.6);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_offset(Adapted(15));
        make.bottom.mas_equalTo(Adapted(0));
        make.height.mas_equalTo(Adapted(1));
    }];
    lineView.hidden = NO;
    
}


@end
