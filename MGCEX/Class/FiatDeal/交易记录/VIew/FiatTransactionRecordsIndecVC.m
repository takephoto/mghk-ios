// MGC
//
// FiatTransactionRecordsIndecVC.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 描述

#import "FiatTransactionRecordsIndecVC.h"
#import "FiatTransactionRecordHeadView.h"
#import "FiatTransactionRecordCell.h"
#import "downTableModel.h"
#import "DownTableView.h"
#import "FiatTransactionRecordsVM.h"
#import "FiatDealIndexVM.h"
#import "FiatPublicAdvRecordCell.h"
#import "ApplyRemindView.h"
#import "FiatTradingVC.h"
#import "CoinEntrusHistoryCell.h"
#import "CoinEntrustCell.h"
#import "ChargeExtractCell.h"

@interface FiatTransactionRecordsIndecVC ()<UITableViewDelegate,UITableViewDataSource,TransactionRecordHeadDelegate,didSelectItemDelegate>
@property (strong ,nonatomic) UITableView *tableView;
@property (nonatomic, strong) FiatTransactionRecordHeadView * headView;
@property (nonatomic, strong) FiatTransactionRecordsVM * viewModel;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * currencySource;//所有币种数据
@property (nonatomic, strong) NSMutableArray * currencyDownArr;//所有币种下拉列表数据
@property (nonatomic, strong) NSMutableArray * statusDownArr;//所有状态下拉列表数据
@property (nonatomic, strong) NSMutableArray * fillCoinStatusArr;//提币充币下拉弹框列表
@property (nonatomic, assign) NSInteger fillCoinStatusIndex;//提币充币下拉弹框列表
@property (nonatomic, assign) NSInteger currencyDownIndex;//所有币种默认选择
@property (nonatomic, assign) NSInteger statusDownIndex;//所有状态默认选择
@property (nonatomic, assign) NSInteger selectTopItem;//顶部栏选择模块
@property (nonatomic, assign) NSInteger entrustItem;//委托队列/成交记录
@property (nonatomic, assign) NSInteger drawCoinItem;//充币记录/提币记录
@property (nonatomic, assign) BOOL isLoadData;

@end

@implementation FiatTransactionRecordsIndecVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isFromAdvertising) {
        self.selectedIndex = 2;
        self.isFromAdvertising = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.headView.segMentview changeToIndex:2];
            [self sendSelectItemValue:3];
        });
        return;
    }
    
    if(self.headView.selectedIndex == self.selectedIndex) return;
    [self.headView.segMentview changeToIndex:self.selectedIndex];
    [self sendSelectItemValue:self.selectedIndex + 1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDefaultData];
    [self setUpTableViews];
    [self getNewData];
    [self getAllcurrencyData];
    [self publicAdsData];
    [self getFiatEntrustListData];
    [self getFiatEntrustHistoryListData];
    [self getFillCoinRecord];
    [self getMentionMoneyRecord];
    // 下拉刷新
    [self dropDownToRefreshData];
    //上拉加载
    [self pullUpToLoadData];

}

#pragma mark--设置默认数据
-(void)configDefaultData{
    self.entrustItem = 1;
    self.selectTopItem = 1;
    self.viewModel.buysell = @"1";
    self.currencyDownIndex = 0;
    self.statusDownIndex = 0;
    self.viewModel.tradeCode = nil;
    self.viewModel.orderStatus = nil;
    self.viewModel.showCurrentUsers = @"1";
    self.drawCoinItem = 1;
    self.fillCoinStatusIndex = 0;
    
}
#pragma mark--撤销广告
-(void)removeAdsOrderWith:(NSString * )advertisingOrderId{
  
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:kLocalizedString(@"确认撤销当前广告？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.viewModel.advertisingOrderId = advertisingOrderId;
                                                              @weakify(self);
                                                              [self.viewModel.removeSignal subscribeNext:^(id x) {
                                                                  @strongify(self);
                                                                  [TTWHUD showCustomMsg:kLocalizedString(@"撤销成功")];
                                                                  [self.tableView.mj_header beginRefreshing];
                                                              } completed:^{
                                                                  
                                                              }];
                                                             
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
 
}

#pragma mark--  获取法币交易记录
-(void)getNewData{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.refreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;

            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
 
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
    
    
    //开始刷新
   if(self.selectedIndex == 0) [self.viewModel.refreshCommand execute:kIsRefreshY];
    
}

#pragma mark--获取所有币种
-(void)getAllcurrencyData{
    
    //订阅信号
    @weakify(self);
    [self.viewModel.allCurrencySignal subscribeNext:^(NSMutableArray * currencySource) {
        @strongify(self);
        
        if(currencySource.count == 0) return;
        self.isLoadData = YES;
        [self.currencySource removeAllObjects];
        [self.statusDownArr removeAllObjects];
        [self.fillCoinStatusArr removeAllObjects];
        
        self.currencySource = currencySource;
        AllCurrencyModels * model = [AllCurrencyModels new];
        model.tradeCode = kLocalizedString(@"所有币种");//添加默认值
        [self.currencySource insertObject:model atIndex:0];
        
        //所有币种
        for(int i=0 ;i<self.currencySource.count;i++){
            downTableModel * model = [downTableModel new];
            AllCurrencyModels * currModel = self.currencySource[i];
            model.selected = NO;
            model.title = currModel.tradeCode;
            if(i==self.currencyDownIndex){
                model.selected = YES;
            }
            [self.currencyDownArr addObject:model];
        }
        

        //充币/提币状态
        NSArray * statusArr1  = @[kLocalizedString(@"所有状态"),kLocalizedString(@"处理中"),kLocalizedString(@"已处理"),kLocalizedString(@"失败")];
            
            for(int i=0 ;i<statusArr1.count;i++){
                downTableModel * model = [downTableModel new];
                model.selected = NO;
                model.title = statusArr1[i];
                if(i==self.fillCoinStatusIndex){
                    model.selected = YES;
                }
                [self.fillCoinStatusArr addObject:model];
            }
            
      //法币交易记录状态
        NSArray *  statusArr2  = @[kLocalizedString(@"所有状态"),kLocalizedString(@"未发货"),kLocalizedString(@"未付款"),kLocalizedString(@"已完成"),kLocalizedString(@"已取消")];
            
            for(int i=0 ;i<statusArr2.count;i++){
                downTableModel * model = [downTableModel new];
                model.selected = NO;
                model.title = statusArr2[i];
                if(i==self.statusDownIndex){
                    model.selected = YES;
                }
                [self.statusDownArr addObject:model];
            }
    }];
}

#pragma mark--获取发布广告数据
-(void)publicAdsData{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.adsRefreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
 
    
}

#pragma mark--获取币币交易委托队列
-(void)getFiatEntrustListData{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.entrustRefreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
    
}


#pragma mark--获取币币历史交易队列
-(void)getFiatEntrustHistoryListData{
    //订阅信号
    @weakify(self);
    [[self.viewModel.entrHistoryRefreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
    
}

#pragma mark--  获取提币记录
-(void)getMentionMoneyRecord{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.takeOutCoinCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
}

#pragma mark--  获取充币记录
-(void)getFillCoinRecord{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.fillCoinCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
}


#pragma mark - 下拉刷新
- (void)dropDownToRefreshData
{
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if(self.selectTopItem == 1){//法币交易
          [self.viewModel.refreshCommand execute:kIsRefreshY];
        }else if (self.selectTopItem == 2){//币币交易
            if(self.entrustItem == 1){
                //委托队列
                [self.viewModel.entrustRefreshCommand execute:kIsRefreshY];
            }else{
                [self.viewModel.entrHistoryRefreshCommand execute:kIsRefreshY];
            }
            
        }else if (self.selectTopItem == 3){//广告发布
            [self.viewModel.adsRefreshCommand execute:kIsRefreshY];
        }else if (self.selectTopItem == 4){//提币充币
            if(self.drawCoinItem == 1){
                //充币
                [self.viewModel.fillCoinCommand execute:kIsRefreshY];
            }else{
                //提币
                [self.viewModel.takeOutCoinCommand execute:kIsRefreshY];
            }
        }
        
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.tableView.mj_header = header;
}

#pragma mark - 上拉加载更多
- (void)pullUpToLoadData
{
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        if(self.selectTopItem == 1){//法币交易
            [self.viewModel.refreshCommand execute:kIsRefreshN];
        }else if (self.selectTopItem == 2){//币币交易
            if(self.entrustItem == 1){
                [self.viewModel.entrustRefreshCommand execute:kIsRefreshN];
            }else{
                [self.viewModel.entrHistoryRefreshCommand execute:kIsRefreshN];
            }
            
        }else if (self.selectTopItem == 3){//广告发布
            [self.viewModel.adsRefreshCommand execute:kIsRefreshN];
        }else if (self.selectTopItem == 4){//积分兑换
            if(self.drawCoinItem == 1){
                //充币
                [self.viewModel.fillCoinCommand execute:kIsRefreshN];
            }else{
                //提币
                [self.viewModel.takeOutCoinCommand execute:kIsRefreshN];
            }
        }
        
    }];
}


-(void)setUpTableViews{
    
    self.title = kLocalizedString(@"交易记录");
    self.view.backgroundColor = kBackGroundColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.headView = [[FiatTransactionRecordHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(92))];
    self.headView.btnDelegate = self;
    @weakify(self);
    self.headView.buyBlock = ^{
        @strongify(self);
        self.viewModel.buysell = @"1";
        self.entrustItem = 1;
        self.drawCoinItem = 1;
        
        //先清空所有数组,刷新列表
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.view layoutIfNeeded];
        
        
        [self.tableView.mj_header beginRefreshing];
        
        
    };
    
    self.headView.sellBlock = ^{
        @strongify(self);
        self.viewModel.buysell = @"2";
        self.entrustItem = 2;
        self.drawCoinItem = 2;
        
        //先清空所有数组,刷新列表
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.view layoutIfNeeded];
        
        [self.tableView.mj_header beginRefreshing];
        
    };
    
    self.tableView.tableHeaderView = self.headView;
    
    
    [self.tableView registerClass:[FiatTransactionRecordCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[FiatPublicAdvRecordCell class] forCellReuseIdentifier:@"adsCell"];
    [self.tableView registerClass:[CoinEntrusHistoryCell class] forCellReuseIdentifier:@"entrusHistoryCell"];
    [self.tableView registerClass:[CoinEntrustCell class] forCellReuseIdentifier:@"entrusCell"];
    [self.tableView registerClass:[ChargeExtractCell class] forCellReuseIdentifier:@"ChargeExtractCell"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

#pragma mark--TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.selectTopItem == 1){//法币交易
        FiatTransactionRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }else if (self.selectTopItem == 2){//币币交易
        if(self.entrustItem == 1){//当前委托
            CoinEntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:@"entrusCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataArray[indexPath.section];
       
            //监听按钮(撤单)
            [[[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                
                [self removrOrderSignalWith:cell.model.Id];
                
            }];
     
            
            return cell;
        }else{//成交记录
            CoinEntrusHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"entrusHistoryCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataArray[indexPath.section];
            return cell;
        }
        
    }else if (self.selectTopItem == 3){//广告记录
        FiatPublicAdvRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"adsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.section];
        
        @weakify(self);
        [[[cell.undoButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self removeAdsOrderWith:cell.model.advertisingOrderId];
        }];
        
        
        return cell;
    }else{//充币 提币
        ChargeExtractCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChargeExtractCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if([self.viewModel.buysell integerValue] == 1){
            FillCoinRecodeListModel * model = self.dataArray[indexPath.section];
            cell.fillModel = model;

        }else{

            TakeCoinRecordModel * model = self.dataArray[indexPath.section];
            cell.takeModel = model;

        }

        return cell;
    }
    
    return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(6))];
    view.backgroundColor = kBackGroundColor;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.selectTopItem == 1){
       return Adapted(120);
    }else if (self.selectTopItem == 2){
        if(self.entrustItem == 1){
            return Adapted(120);
        }else{
            return Adapted(160);
        }
        
    }else if (self.selectTopItem == 3){
        return Adapted(205);
    }else if (self.selectTopItem == 4){ // 提币充币
        
        if([self.viewModel.buysell integerValue] == 1){
            FillCoinRecodeListModel * model = self.dataArray[indexPath.section];
            return model.cellHeight;
        }else{
            TakeCoinRecordListModel * model = self.dataArray[indexPath.section];
            return model.cellHeight;
            
        }
//        return Adapted(145);
    }
    
    return Adapted(120);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adapted(6);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(6))];
    view.backgroundColor = kBackGroundColor;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.selectTopItem == 1){//法币交易记录详情
        FiatTransactionRecordsModel * model = _dataArray[indexPath.section];
        FiatTradingVC * vc = [[FiatTradingVC alloc]init];
        vc.tradeOrderId = model.tradeOrderId;
        vc.tradingUserid = model.tradingUserid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark--撤单
-(void)removrOrderSignalWith:(NSString * )orderId{
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:kLocalizedString(@"确认撤销当前委托？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.viewModel.orderId = orderId;
                                                              @weakify(self);
                                                              [self.viewModel.removrOrderSignal subscribeNext:^(id x) {
                                                                  @strongify(self);
                                                                  [TTWHUD showCustomMsg:kLocalizedString(@"撤销成功")];
                                                                  [self.tableView.mj_header beginRefreshing];
                                                              } completed:^{
                                                                  
                                                              }];
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}


#pragma mark-- TransactionRecordHeadDelegate
- (void)sendHeadFrameValue:(FiatTransactionRecordHeadView *)headV index:(NSInteger)index{
    
    CGRect rect = [headV convertRect:headV.frame toView:nil];
    
    //1  所有币种。 2所有状态
    if(index == 1){
        if(self.currencyDownArr.count==0)  return;
        DownTableView * tab = [[DownTableView alloc]initWithRect:rect dataArray:self.currencyDownArr type:2 maxCell:8 didSelect:1];
        tab.selectDelegate = self;
        [tab show];
    }else if (index == 2){

        if(self.statusDownArr.count==0)  return;
        
        if(self.selectTopItem == 4){//提币充币所有状态
            
            DownTableView * tab= [[DownTableView alloc]initWithRect:rect dataArray:self.fillCoinStatusArr type:1 maxCell:8 didSelect:2];
            tab.selectDelegate = self;
            [tab show];
        }else{//其他所有状态
            
            DownTableView * tab= [[DownTableView alloc]initWithRect:rect dataArray:self.statusDownArr type:1 maxCell:8 didSelect:2];
            tab.selectDelegate = self;
            [tab show];

        }

        

    }
    
    
}

#pragma mark--didSelectItemDelegate
//1  所有币种。 2所有状态
- (void)sendItemValue:(NSInteger )index dataArray:(NSArray *)dataArray disSelect:(NSInteger )didSelect isEmpty:(BOOL)isEmpty{
    downTableModel * model = dataArray[index];
    if(didSelect == 1){
        //所有币种
        if(!isEmpty){
           [self.headView.leftBtn setTitle:model.title forState:UIControlStateNormal];
  
            if(index==0){
                self.viewModel.tradeCode = nil;
                [self.headView.leftBtn setTitleColor:k99999Color forState:UIControlStateNormal];
            }else{
                [self.headView.leftBtn setTitleColor:kTextColor forState:UIControlStateNormal];
                self.viewModel.tradeCode = model.title;
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
                [self.tableView.mj_header beginRefreshing];
            });
            
        }
      
    }else if (didSelect == 2){
        //所有状态
        if(!isEmpty){
            [self.headView.rightBtn setTitle:model.title forState:UIControlStateNormal];
      
            if(index==0){
                self.viewModel.orderStatus = nil;
                [self.headView.rightBtn setTitleColor:k99999Color forState:UIControlStateNormal];
            }else{
                [self.headView.rightBtn setTitleColor:kTextColor forState:UIControlStateNormal];
            }
            
            if(self.selectTopItem == 4){
                if(index!=0){
                    self.viewModel.orderStatus = s_Num(index);
                }
                
            }else{
                if(index ==1){
                    self.viewModel.orderStatus = @"2";
                } else if(index ==2){
                    self.viewModel.orderStatus = @"1";
                }else if (index == 3){
                    self.viewModel.orderStatus = @"3";
                }else if (index == 4){
                    self.viewModel.orderStatus = @"6";
                }
            }
 
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self.tableView.mj_header beginRefreshing];
            });
        }
   
    }
    self.headView.leftBtn.selected = NO;
    self.headView.rightBtn.selected = NO;
    
}

#pragma mark-- TransactionRecordHeadDelegate
//顶部切换4个大模块
- (void)sendSelectItemValue:(NSInteger )index{
    //先清空所有数组,刷新列表
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
    
    if(self.selectTopItem == index)  return;
    
    self.selectTopItem = index;
    
    if(self.statusDownArr.count>0){
        //初始化所有币种和所有状态
        self.viewModel.orderStatus = nil;
        self.viewModel.tradeCode = nil;
        [self.headView.rightBtn setTitle:kLocalizedString(@"所有状态") forState:UIControlStateNormal];
        [self.headView.leftBtn setTitle:kLocalizedString(@"所有币种") forState:UIControlStateNormal];
        //所有状态归零
        for (downTableModel * model in self.statusDownArr) {
            model.selected = NO;
        }
        downTableModel * model = self.statusDownArr[0];
        model.selected = YES;
        
        //所有状态归零
        for (downTableModel * model2 in self.fillCoinStatusArr) {
            model2.selected = NO;
        }
        downTableModel * model2 = self.fillCoinStatusArr[0];
        model2.selected = YES;
    }
    
    [self.headView.leftBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    [self.headView.rightBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    
    [self.tableView.mj_header beginRefreshing];
    
    if(self.selectTopItem == 2){
        
        [self.headView.buyBtn setTitle:kLocalizedString(@"当前委托") forState:UIControlStateNormal];
        [self.headView.sellBtn setTitle:kLocalizedString(@"成交记录") forState:UIControlStateNormal];
        self.headView.rightBtn.hidden = YES;
    
    }else if (self.selectTopItem == 1 || self.selectTopItem == 3){

        self.headView.rightBtn.hidden = NO;
        [self.headView.buyBtn setTitle:kLocalizedString(@"买入") forState:UIControlStateNormal];
        [self.headView.sellBtn setTitle:kLocalizedString(@"卖出") forState:UIControlStateNormal];
    }else if (self.selectTopItem == 4){
        self.headView.rightBtn.hidden = NO;
        [self.headView.buyBtn setTitle:kLocalizedString(@"充币") forState:UIControlStateNormal];
        [self.headView.sellBtn setTitle:kLocalizedString(@"提币") forState:UIControlStateNormal];
    }
 

}

#pragma mark--  懒加载
-(FiatTransactionRecordsVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[FiatTransactionRecordsVM alloc]init];
    }
    return _viewModel;
}

-(NSMutableArray *)currencyDownArr{
    if(!_currencyDownArr){
        _currencyDownArr = [NSMutableArray new];
    }
    return _currencyDownArr;
}

-(NSMutableArray *)statusDownArr{
    if(!_statusDownArr){
        _statusDownArr = [NSMutableArray new];
    }
    return _statusDownArr;
}

-(NSMutableArray *)fillCoinStatusArr{
    if(!_fillCoinStatusArr){
        _fillCoinStatusArr = [NSMutableArray new];
    }
    return _fillCoinStatusArr;
}

@end
