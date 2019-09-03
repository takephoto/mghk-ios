//
//  MGWithdrawTVC.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGWithdrawTVC.h"
#import "MGWithdrawTVCCell.h"
#import "MGWithdrawInputCell.h"
#import "MGWithdrawPoundageCell.h"
#import "MGWithdrawVerifierCell.h"
#import "MGWithdrawVM.h"
#import "MGWithdrawModel.h"
///第一行
#define kAddressCellID @"kAddressCellID"
//第二行输入数量
#define kNumberCellID @"kNumberCellID"
//第三行手续费
#define kChargeCellID @"kChargeCellID"
//资金密码
#define kPswCellID @"kPswCellID"

@interface MGWithdrawTVC ()
@property (nonatomic, strong) UIView *footerView;
///提交按钮
@property (nonatomic, strong) QSButton *summitBtn;
@property (nonatomic, strong) MGWithdrawVM *viewModel;
///查询限额等信息
@property (nonatomic, strong) MGWithdrawModel *model;
///保存cell
@property (nonatomic, strong) MGWithdrawVerifierCell *tempCell;
@end

@implementation MGWithdrawTVC

-(void)bindViewModel{
    self.viewModel.tradeCode = self.tradeCode;
    @weakify(self)
    [self.viewModel.withdrawLimitSignal subscribeNext:^(id x) {
        @strongify(self)
        self.model = x;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }];
}
-(void)setUpTableViewUI
{
    [super setUpTableViewUI];
    [self setNavBarStyle:NavigationBarStyleBlack backBtn:YES];
    self.title = string(self.tradeCode, kLocalizedString(@"提币"));
    self.tableView.backgroundColor = kBackGroundColor;
    [self.tableView registerClass:[MGWithdrawTVCCell class] forCellReuseIdentifier:kAddressCellID];
    [self.tableView registerClass:[MGWithdrawInputCell class] forCellReuseIdentifier:kNumberCellID];
    [self.tableView registerClass:[MGWithdrawPoundageCell class] forCellReuseIdentifier:kChargeCellID];
    [self.tableView registerClass:[MGWithdrawVerifierCell class] forCellReuseIdentifier:kPswCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView  = self.footerView;
//    self.tableView.hidden = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:VerifierEmail];
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:VerifierPhone];
        if (email.length > 0 && phone.length> 0) {
            return Adapted(140);
        }
        return Adapted(110);
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellIDArr = @[kAddressCellID,kNumberCellID,kChargeCellID,kPswCellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDArr[indexPath.row] forIndexPath:indexPath];
    @weakify(self);
    if (indexPath.row == 0) {
        MGWithdrawTVCCell *tCell = (MGWithdrawTVCCell*)cell;
        tCell.numLab.text = string(self.tradeCode, kLocalizedString(@"提现地址"));
        tCell.numTextFiled.placeholder = [NSString stringWithFormat:@"%@%@%@",kLocalizedString(@"请输入"), self.tradeCode, kLocalizedString(@"提现地址")];
        ///监听textfield
        [[[tCell.numTextFiled rac_textSignal]takeUntil:tCell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            self.viewModel.address = x;
        }];
    }else if (indexPath.row == 1) {
        MGWithdrawInputCell *tCell = (MGWithdrawInputCell*)cell;
        self.model.tradeCode = self.tradeCode;
        tCell.model = self.model;
        [[[tCell.numTextFiled rac_textSignal]takeUntil:tCell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            self.viewModel.amount = x;
        }];
    }else if (indexPath.row == 2) {
        MGWithdrawPoundageCell *tCell = (MGWithdrawPoundageCell*)cell;
        tCell.model = self.model;
    }
    else if (indexPath.row == 3) {
        MGWithdrawVerifierCell *tCell = (MGWithdrawVerifierCell*)cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tCell.password.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.reMoneyPassword = text;
        };
        tCell.verifierCode.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.authCode = text;
        };
        
        self.tempCell = tCell;
    }
    // Configure the cell...
    
    return cell;
}


-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.frame =  CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(70.0));
        _summitBtn = [[UIButton alloc]init];
        [_summitBtn setTitleColor:white_color forState:UIControlStateNormal];
        [_summitBtn setBackgroundColor:kRedColor];
        ViewRadius(_summitBtn, Adapted(2));
        [_summitBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
        [_summitBtn.titleLabel setFont:H15];
        [_footerView addSubview:_summitBtn];
        [_summitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Adapted(30));
            make.left.mas_equalTo(Adapted(16));
            make.right.mas_equalTo(Adapted(-16));
            make.bottom.mas_equalTo(0);
        }];
        @weakify(self);
        [[_summitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            @strongify(self);
            if (self.viewModel.address.length < 1) {
                [TTWHUD showCustomMsg:kLocalizedString(@"请输入地址")];
                return;
            }
            if (self.viewModel.amount.length < 1) {
                [TTWHUD showCustomMsg:kLocalizedString(@"请输提现数额")];
                return;
            }
//            if (self.model.destructionRate.length > 0) {
//                double scale = [self.model.destructionRate doubleValue];
//                if ([self.viewModel.amount doubleValue]*scale > [self.model.availableBalance doubleValue]) {
//                    [TTWHUD showCustomMsg:@"提现金额不能超过总额."];
//                }
//            }
            if ([self.viewModel.amount doubleValue] > [self.model.drawHigh doubleValue]) {
                [TTWHUD showCustomMsg:kLocalizedString(@"提现金额不能超过单笔限额")];
                return;
            }
            if ([self.viewModel.amount doubleValue] < [self.model.drawLow doubleValue]) {
                [TTWHUD showCustomMsg:kLocalizedString(@"提现金额不能低于限额")];
                return;
            }
            
            if ([self.viewModel.amount doubleValue] > [self.model.availableBalance doubleValue]) {
                [TTWHUD showCustomMsg:kLocalizedString(@"提现金额不能高于可用余额")];
                return;
            }
            if (self.viewModel.reMoneyPassword.length < 1) {
                [TTWHUD showCustomMsg:kLocalizedString(@"请输入资金密码")];
                return;
            }
            if (self.viewModel.authCode.length < 1) {
                [TTWHUD showCustomMsg:kLocalizedString(@"请输入验证码")];
                return;
            }
            self.viewModel.loginNum = self.tempCell.viewModel.loginNum;
            [self.viewModel.withdrawSignal subscribeNext:^(id x) {
                @strongify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }];
    }
    return _footerView;
}
- (MGWithdrawVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MGWithdrawVM alloc]init];
    }
    return _viewModel;
    
}

-(void)dealloc
{
    
}









@end
