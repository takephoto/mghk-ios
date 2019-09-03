// MGC
//
// AboutUsVC.m
// MGCEX
//
// Created by MGC on 2018/6/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = kBackGroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title =  kLocalizedString(@"关于我们");
    
    UIScrollView *scroller = [[UIScrollView alloc] init];
    [self.view addSubview:scroller];
    [scroller mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scroller addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(scroller);
        make.width.equalTo(scroller);
    }];
    scroller.showsVerticalScrollIndicator = NO;
    
    UIImageView * logImageV = [[UIImageView alloc]init];
    [contentView addSubview:logImageV];
    logImageV.image = IMAGE(@"about_ad");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(Adapted(5));
        make.width.mas_equalTo(Adapted(344));
        make.height.mas_equalTo(Adapted(179));
    }];
    
    UIView *tagV = [[UIView alloc] init];
    [contentView addSubview:tagV];
    [tagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Adapted(15));
        make.top.mas_equalTo(logImageV.mas_bottom).offset(Adapted(15));
        make.width.mas_offset(Adapted(4));
        make.height.mas_offset(Adapted(18));
    }];
    tagV.backgroundColor = kMainColor;
    
    UILabel *lab = [[UILabel alloc] init];
    [contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(tagV.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(tagV);
    }];
    lab.font = HB18;
    lab.text = kLocalizedString(@"美币港交所简介");
    lab.textColor = kTextColor;

    UILabel * label = [[UILabel alloc]init];
    [contentView addSubview:label];
    label.font = H14;
    label.textColor = kAssistTextColor;
    label.numberOfLines = 0;
    label.text = kLocalizedString(@"美币香港数字交易所（简称美币港交所MEIB HKEX ）立足国际金融中心香港，依托自身人工智能、区块链、大数据等先进技术为全球数字货币投资者提供安全的币币交易、场外交易、杠杆交易等加密货币交易服务，旗下区块链全球企业挂牌中心为区块链企业提供免费的挂牌、辅导及品牌宣传服务，运营团队超过100人，均来自知名科技公司、商业银行、互联网金融公司、基金管理公司，核心团队具有15年以上金融或技术研发经验，香港办公面积超过7700平方英呎（715平方米），演播大厅等设施一应俱全，免费为区块链企业提供视频制作场地和沙龙聚会空间。美币港交所设立数字公益基金，积极参与社会公益活动。美币港交所立志成为数字交易所中的纳斯达克，战略目标成为国家级品牌数字交易所。“安全、诚信”是美币港交所坚守的基本准则。");
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_offset(Adapted(15));
        make.right.mas_offset(Adapted(-15));
        make.top.mas_equalTo(lab.mas_bottom).offset(Adapted(15));
        make.bottom.mas_offset(Adapted(-15));
    }];
}

@end
