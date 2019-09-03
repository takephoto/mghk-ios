// MGC
//
// FiatSetAccountVC.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetAccountVC.h"
#import "PersonalCenterCell.h"
#import "FiatSetZFBVC.h"
#import "FiatSetAccountVM.h"
#import "FiatSetBankVC.h"
#import "FiatSetAccountModel.h"
#import "accountBankModel.h"
#import "accountZfbModel.h"
#import "accountWxModel.h"

@interface FiatSetAccountVC ()
@property (nonatomic, strong) FiatSetAccountVM * viewModel;
@property (nonatomic, assign) BOOL isBankCard;
@property (nonatomic, assign) BOOL isZFB;
@property (nonatomic, assign) BOOL isWX;
@property (nonatomic, strong) FiatSetAccountModel *  accountModel;

@property (nonatomic, strong) accountBankModel * bankModel;
@property (nonatomic, strong) accountZfbModel * zfbModel;
@property (nonatomic, strong) accountWxModel * wxModel;
@property (nonatomic, assign) BOOL isNetWork;
@end

@implementation FiatSetAccountVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isNetWork = NO;
    self.title = kLocalizedString(@"C2C/B2C支付设置");
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorColor = kLineColor;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"personalCell"];
    
    [self dropDownToRefreshData:^{
        [self getNewData];
    }];
}

-(void)getNewData{

    //订阅信号
    @weakify(self);
    [self.viewModel.getAccountSignal subscribeNext:^(FiatSetAccountModel * model) {
        @strongify(self);
        self.accountModel = model;
        self.bankModel = model.bank;
        self.zfbModel = model.pay;
        self.wxModel = model.micro;
        self.isBankCard = (self.bankModel.payeeAccount.length>0)?YES:NO;
        self.isZFB = (self.zfbModel.payeeAccount.length>0)?YES:NO;
        self.isWX = (self.wxModel.payeeAccount.length>0)?YES:NO;
        self.isNetWork = YES;
        [self.tableView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    sectionView.backgroundColor = kBackGroundColor;
    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PersonalCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row >= [tableView numberOfRowsInSection:indexPath.section]-1){
        
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
    }
    if(indexPath.row == 0){
        if(self.isBankCard){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"银行卡");
            cell.subLabel.text = [TWAppTool mg_securePhoneMailText:self.bankModel.payeeAccount];
           
        }else{
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"银行卡");
            cell.subLabel.text = kLocalizedString(@"未绑定");
            cell.subLabel.textColor = kRedColor;
        }
        
    }else if (indexPath.row == 1){
        if(self.isZFB){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"支付宝");
            cell.subLabel.text = [TWAppTool mg_securePhoneMailText:self.zfbModel.payeeAccount];
         
        }else{
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"支付宝");
            cell.subLabel.text = kLocalizedString(@"未绑定");
            cell.subLabel.textColor = kRedColor;
        }
        
    }else if (indexPath.row == 2){
        if(self.isWX){
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"微信");
            cell.subLabel.text = [TWAppTool mg_securePhoneMailText:self.wxModel.payeeAccount];
   
        }else{
            cell.personCellType = 0;
            cell.titleLabel.text = kLocalizedString(@"微信");
            cell.subLabel.text = kLocalizedString(@"未绑定");
            cell.subLabel.textColor = kRedColor;
        }
        
    }

    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adapted(12);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

     if(self.isNetWork == NO) return ;//无网络不让点击
    
        if(indexPath.row == 0){
            //银行卡
            FiatSetBankVC * vc = [[FiatSetBankVC alloc]init];
            vc.changeStatus = (self.isBankCard)? @"2":@"1";
            vc.payType = @"1";
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 1){
            //支付宝
            FiatSetZFBVC * vc = [[FiatSetZFBVC alloc]init];
            vc.payType = @"2";
            vc.changeStatus = (self.isZFB)? @"2":@"1";
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 2){
            //微信
            FiatSetZFBVC * vc = [[FiatSetZFBVC alloc]init];
            vc.payType = @"3";
            vc.changeStatus = (self.isWX)? @"2":@"1";;
            [self.navigationController pushViewController:vc animated:YES];

        }


}


-(FiatSetAccountVM *)viewModel{
    if(!_viewModel){
        _viewModel = [FiatSetAccountVM new];
    }
    return _viewModel;
}

@end
