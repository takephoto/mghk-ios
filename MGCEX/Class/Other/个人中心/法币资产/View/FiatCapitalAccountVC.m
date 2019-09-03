// MGC
//
// FiatCapitalAccountVC.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatCapitalAccountVC.h"
#import "FiatCapitalAccountHeadView.h"
#import "FiatAccountSectionHeadView.h"
#import "FiatCapitaAccountCell.h"
#import "UserInformationVM.h"
#import "FiatCapListModel.h"
#import "RechargeAddressVC.h"
#import "MGTransferTVC.h"
#import "MGWithdrawTVC.h"


@interface FiatCapitalAccountVC ()
@property (nonatomic, strong) UserInformationVM * viewModel;
@end

@implementation FiatCapitalAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"C2C/B2C资产");
    
    self.view.backgroundColor = kBackGroundColor;
    
     [self setNavBarStyle:NavigationBarStyleBlack backBtn:YES];
//    [self setNavBarWithTextColor:white_color barTintColor:black_color tintColor:black_color statusBarStyle:UIStatusBarStyleLightContent];
    
    self.headView = [[FiatCapitalAccountHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(135))];
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FiatCapitaAccountCell class] forCellReuseIdentifier:@"cell"];
    
    self.viewModel.type = @"N";
    
    [self dropDownToRefreshData:^{
        [self getNewData];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNewData];
}
-(void)getNewData{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.fiatInfoSignal subscribeNext:^(FiatAccountModel *model) {
        @strongify(self);

        self.headView.accountLabel.text = [NSString stringWithFormat:@"%@ BTC",[model.btcCount keepDecimal:8]];
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

    FiatCapitaAccountCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.statusLabel.hidden = YES;
    
    @weakify(self);
    cell.btnClickBlock = ^(NSInteger btnTag) {
        @strongify(self);
        [self clickBottomBtnHandleWithTag:btnTag cell:cell];
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
    self.sectionOneView.btnBlock = ^(BOOL index) {
        @strongify(self);
        if(index == YES){
          self.viewModel.type = @"Y";
        }else{
            self.viewModel.type = @"N";
        }
   
        [self.tableView.mj_header beginRefreshing];
        
    };
    
    return self.sectionOneView;
}

#pragma mark-- btnClick
-(void)clickBottomBtnHandleWithTag:(NSInteger )btntag  cell:(FiatCapitaAccountCell *)cell{
    
    switch (btntag) {
        case 10://充币
            {
                RechargeAddressVC *vc = [[RechargeAddressVC alloc]init];
                vc.isfucUrl = cell.model.isfucUrl;
                vc.tradeCode = cell.model.tradeCode;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 11://法币
        {
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 12://资金划转
        {
            MGTransferTVC *vc = [[MGTransferTVC alloc]init];
            vc.type = @"uff";
            vc.defaultCoinTypeStr = cell.model.tradeCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(FiatAccountSectionHeadView *)sectionOneView{
    if(!_sectionOneView){
        _sectionOneView = [[FiatAccountSectionHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(64))];
    }
    return _sectionOneView;
}

-(UserInformationVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[UserInformationVM alloc]init];
    }
    return _viewModel;
}
@end
