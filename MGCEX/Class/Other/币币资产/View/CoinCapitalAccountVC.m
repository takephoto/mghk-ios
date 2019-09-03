// MGC
//
// CoinCapitalAccountVC.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinCapitalAccountVC.h"
#import "CoinCapitalAccountCell.h"
#import "UserInformationVM.h"
#import "RechargeAddressVC.h"
#import "MGTransferTVC.h"
#import "MGWithdrawTVC.h"
#import "MGCapitalTransferVC.h"

@interface CoinCapitalAccountVC ()
@property (nonatomic, strong) FiatAccountSectionHeadView * CoinHeadSectionView;
@property (nonatomic, strong) UserInformationVM * viewModel;
@end

@implementation CoinCapitalAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"币币资产");
    
    self.headView = [[FiatCapitalAccountHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(135))];
    self.headView.titleLabel.text = kLocalizedString(@"币币资产估值");
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[CoinCapitalAccountCell class] forCellReuseIdentifier:@"coinCell"];
    
    
    self.viewModel.type = @"N";
    
    
    [self dropDownToRefreshData:^{
        [self getNewData2];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
     [self setNavBarStyle:NavigationBarStyleBlack backBtn:YES];
//    [self setNavBarWithTextColor:white_color barTintColor:black_color tintColor:white_color statusBarStyle:UIStatusBarStyleLightContent];
    [self getNewData2];
}

-(void)getNewData2{

    //订阅信号
    @weakify(self);
    [self.viewModel.coinInfoSignal subscribeNext:^(FiatAccountModel *model) {
        @strongify(self);
        self.headView.accountLabel.text = [NSString stringWithFormat:@"%@ BTC",[model.btcCount keepDecimal:8]] ;
        self.headView.cuyLabel.text = [NSString stringWithFormat:@"%@ CNY",[model.cnySum keepDecimal:2]];
        self.dataArray = [NSMutableArray arrayWithArray:model.ufflist];
        
        [self.tableView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CoinCapitalAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:@"coinCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CoinCapListModel *model =  self.dataArray[indexPath.row];
    cell.model = model;
    
    @weakify(self);
    cell.btnClickBlock = ^(NSInteger btnTag) {
        @strongify(self);
        [self clickBottomBtnHandleWithTag:btnTag cell:cell];
    };
    cell.capitalTransferClickBlock = ^{
        MGCapitalTransferVM *vm = [[MGCapitalTransferVM alloc] initWithTradeCode:model.tradeCode availableBalance:kNotNumber([model.availableBalance keepDecimal:8])];
        MGCapitalTransferVC *vc = [[MGCapitalTransferVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    };

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Adapted(62);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Adapted(170);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    @weakify(self);
    self.CoinHeadSectionView.btnBlock = ^(BOOL index) {
        @strongify(self);
        if(index == YES){
            self.viewModel.type = @"Y";
        }else{
            self.viewModel.type = @"N";
        }
        
        [self.tableView.mj_header beginRefreshing];
    };
    
    return self.CoinHeadSectionView;
}

#pragma mark-- btnClick
-(void)clickBottomBtnHandleWithTag:(NSInteger )btntag cell:(CoinCapitalAccountCell *)cell{
    
    switch (btntag) {
        case 10://充币
        {
                RechargeAddressVC *vc = [[RechargeAddressVC alloc]init];
                vc.isfucUrl = cell.model.isfucUrl;
                vc.tradeCode = cell.model.tradeCode;
                [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 11://提币
        {
            MGWithdrawTVC *vc = [[MGWithdrawTVC alloc]init];
            vc.tradeCode = cell.model.tradeCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12://币币
        {
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 13://资金划转
        {
            MGTransferTVC *vc = [[MGTransferTVC alloc]init];
            vc.type = cell.model.is;
            vc.defaultCoinTypeStr = cell.model.tradeCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(FiatAccountSectionHeadView *)CoinHeadSectionView{
    if(!_CoinHeadSectionView){
        _CoinHeadSectionView = [[FiatAccountSectionHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(64))];
    }
    return _CoinHeadSectionView;
}

-(UserInformationVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[UserInformationVM alloc]init];
    }
    return _viewModel;
}
@end
