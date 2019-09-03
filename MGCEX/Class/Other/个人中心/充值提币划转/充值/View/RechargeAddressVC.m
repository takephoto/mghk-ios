// MGC
//
// RechargeAddressVC.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 描述

#import "RechargeAddressVC.h"
#import "RechargeAddressCell.h"
#import "MGRechargeVM.h"

#define kCellID @"cell"

@interface RechargeAddressVC ()
@property (nonatomic, strong) MGRechargeVM *viewModel;
///服务器返回的地址
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, assign) NSInteger rowNumber;
@end

@implementation RechargeAddressVC
- (void)viewWillAppear:(BOOL)animated{
    
    [self setNavBarStyle:NavigationBarStyleBlack backBtn:YES];
//     [self setNavBarWithTextColor:white_color barTintColor:black_color tintColor:black_color statusBarStyle:UIStatusBarStyleLightContent];
}
-(void)setUpTableViewUI
{
    
    [super setUpTableViewUI];
    self.title = string(self.tradeCode, kLocalizedString(@"充值"));
    self.tableView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RechargeAddressCell class] forCellReuseIdentifier:kCellID];

}
-(void)bindViewModel
{
    self.viewModel.tradeCode = self.tradeCode;
    [self.viewModel.rechargeSignal subscribeNext:^(id x) {
        self.isfucUrl = x[@"walletAddress"];
        if (!kStringIsEmpty(self.isfucUrl)) {
            self.rowNumber = 1;
            [self.tableView reloadData];
        }
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tradeCode = self.tradeCode;
    cell.addressStr = self.isfucUrl;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
-(MGRechargeVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MGRechargeVM new];
    }
    return _viewModel;
}











@end
