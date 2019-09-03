//
//  MGCapitalTransferVC.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferVC.h"
#import "MGCapitalTransferNameCell.h"
#import "MGCapitalTransferAccountCell.h"
#import "MGCapitalTransferNumberCell.h"
#import "MGCapitalTransferVerifierCell.h"
#import "MGCapitalTransferFooterView.h"

#define KMGCapitalTransferNameCellID            @"KMGCapitalTransferNameCellID"
#define KMGCapitalTransferAccountCellID         @"KMGCapitalTransferAccountCellID"
#define KMGCapitalTransferNumberCellID          @"KMGCapitalTransferNumberCellID"
#define KMGCapitalTransferVerifierCellID        @"KMGCapitalTransferVerifierCellID"

@interface MGCapitalTransferVC ()

@property (nonatomic, strong) MGCapitalTransferVM *viewModel;

@property (nonatomic, strong) MGCapitalTransferFooterView *footerView;

///保存cell
@property (nonatomic, strong) MGCapitalTransferVerifierCell *tempCell;

@end

@implementation MGCapitalTransferVC

- (id)initWithViewModel:(MGCapitalTransferVM *)viewModel
{
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)setUpTableViewUI
{
    [super setUpTableViewUI];
    self.title = self.viewModel.navTitleText;
    self.tableView.backgroundColor = kBackGroundColor;
    [self.tableView registerClass:[MGCapitalTransferNameCell class] forCellReuseIdentifier:KMGCapitalTransferNameCellID];
    [self.tableView registerClass:[MGCapitalTransferAccountCell class] forCellReuseIdentifier:KMGCapitalTransferAccountCellID];
    [self.tableView registerClass:[MGCapitalTransferNumberCell class] forCellReuseIdentifier:KMGCapitalTransferNumberCellID];
    [self.tableView registerClass:[MGCapitalTransferVerifierCell class] forCellReuseIdentifier:KMGCapitalTransferVerifierCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView  = self.footerView;
    [self.footerView.summitBtn setTitle:self.viewModel.footerButtonTitleText forState:UIControlStateNormal];
    
    @weakify(self);
    [[self.footerView.summitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        @strongify(self);
        
        if (self.viewModel.account.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入对方手机号码/邮箱")];
            return;
        }
        if ([NSString jl_checkEmail:self.viewModel.account] || [NSString jl_isValidMobile:self.viewModel.account]) {
        }else{
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入正确的手机号码/邮箱")];
            return;
        }
        if (self.viewModel.capitalNum.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入转移数量")];
            return;
        }
        if ([self.viewModel.capitalNum doubleValue] > [self.viewModel.availableBalance doubleValue]) {
            [TTWHUD showCustomMsg:kLocalizedString(@"转移数量不能大于可用数量")];
            return;
        }
        if (self.viewModel.pwd.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入资金密码")];
            return;
        }
        if (self.viewModel.code.length < 1) {
            [TTWHUD showCustomMsg:kLocalizedString(@"请输入验证码")];
            return;
        }
        self.viewModel.loginNum = self.tempCell.viewModel.loginNum;
        [self.viewModel.coinMoveSignal subscribeNext:^(id x) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
}



#pragma mark -- 表格代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    NSArray *cellIDArr = @[KMGCapitalTransferNameCellID,KMGCapitalTransferAccountCellID,KMGCapitalTransferNumberCellID,KMGCapitalTransferVerifierCellID];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDArr[indexPath.row] forIndexPath:indexPath];
    @weakify(self);
    if (indexPath.row == 0) {
        MGCapitalTransferNameCell *tCell = (MGCapitalTransferNameCell*)cell;
        [tCell configWithViewModel:self.viewModel];
    }else if (indexPath.row == 1) {
        MGCapitalTransferAccountCell *tCell = (MGCapitalTransferAccountCell*)cell;
        [[[tCell.accountTextField rac_textSignal]takeUntil:tCell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            self.viewModel.account = x;
        }];
    }else if (indexPath.row == 2) {
        MGCapitalTransferNumberCell *tCell = (MGCapitalTransferNumberCell*)cell;
        [tCell configWithViewModel:self.viewModel];
        [[[tCell.numberTextFiled rac_textSignal]takeUntil:tCell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            self.viewModel.capitalNum = x;
        }];
        
        //监听按钮(全部转移)
        [[[tCell.allTransferButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:tCell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self);
            tCell.numberTextFiled.text = self.viewModel.availableBalance;
            self.viewModel.capitalNum = self.viewModel.availableBalance;
        }];
    }
    else if (indexPath.row == 3) {
        MGCapitalTransferVerifierCell *tCell = (MGCapitalTransferVerifierCell*)cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tCell.password.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.pwd = text;
        };
        tCell.verifierCode.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            self.viewModel.code = text;
        };
        self.tempCell = tCell;
    }
    
    return cell;
}


- (MGCapitalTransferFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[MGCapitalTransferFooterView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(70.0))];
        _footerView.backgroundColor = kBgGrayColor;
    }
    return _footerView;
}



@end
