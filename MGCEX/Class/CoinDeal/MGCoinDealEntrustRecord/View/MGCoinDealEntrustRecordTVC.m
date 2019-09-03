//
//  MGCoinDealEntrustRecordTVC.m
//  MGCEX
//
//  Created by Joblee on 2018/6/17.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCoinDealEntrustRecordTVC.h"
#import "FiatTransactionRecordsVM.h"
#import "MGEntrustCell.h"

#define kCellID @"cellID"

@interface MGCoinDealEntrustRecordTVC ()
@property (nonatomic, strong) FiatTransactionRecordsVM *viewModel;
@property (nonatomic, assign) BOOL userLogin;
@end

@implementation MGCoinDealEntrustRecordTVC

- (void)viewWillAppear:(BOOL)animated{
    
    [self setNavBarStyle:NavigationBarStyleWhite backBtn:YES];
}

-(void)getEntrHistory
{
    _userLogin = kUserIsLogin;
    if(_userLogin == NO)  return;
    
    self.viewModel.market = self.markStr;
    self.viewModel.tradeCode = self.trCode;
    self.viewModel.isAllHistory = YES;
#pragma mark--获取币币交易委托队列
    //订阅信号
    @weakify(self);
    [[self.viewModel.entrHistoryCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
}
-(void)setUpTableViewUI
{
    [super setUpTableViewUI];
    self.tableView.backgroundColor = kBackGroundColor;
    self.title = kLocalizedString(@"历史记录");
    [self.tableView registerClass:[MGEntrustCell class] forCellReuseIdentifier:kCellID];
    KWeakSelf;
    [weakSelf dropDownToRefreshData:^{
        
        //刷新当前委托
        _userLogin = kUserIsLogin;
        if(_userLogin == YES){
            [weakSelf.viewModel.entrHistoryCommand execute:kIsRefreshY];
        }
        
    }];
    [weakSelf pullUpToLoadData:^{
        if(_userLogin == YES){
            [weakSelf.viewModel.entrHistoryCommand execute:kIsRefreshN];
        }
    }];
    [self getEntrHistory];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark -- tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGEntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.model = self.dataArray[indexPath.row];
    cell.button.hidden = YES;
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
    }
    return cell;
}

#pragma mark--  懒加载
-(FiatTransactionRecordsVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FiatTransactionRecordsVM alloc]init];
    }
    return _viewModel;
}
@end
