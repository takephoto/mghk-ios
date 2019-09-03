// MGC
//
// FiatDealIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatDealIndexVC.h"
#import "FiatDealHeadView.h"
#import "SubFiatDealHeadView.h"
#import "DownTableView.h"
#import "FiatDealBuyOrSellModel.h"
#import "BuySellFiatDealView.h"
#import "FiatDealIndexVM.h"
#import "FiatTransactionRecordsVM.h"
#import "BuyFiatDealTableViewCell.h"
#import "SellFiatDealTableViewCell.h"
#import "BuySellFiatDealView.h"
#import "FiatTradingVC.h"
#import "MGComplainRecordVC.h"
#import "CoinDealTitleView.h"

#import "PlaceOrderVC.h"


@interface FiatDealIndexVC ()<UITableViewDelegate,UITableViewDataSource,FiatDealHeadViewDelegate,didSelectItemDelegate,SubFiatDealHeadViewDelegate,didSelectItemDelegate,BuyFiatDealDelegate,SellFiatDealDelegate>

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong)  BuySellFiatDealView * payView;
@property (strong ,nonatomic) UITableView *fiatDealTable;
@property (nonatomic, assign) NSInteger cellType;
@property (nonatomic, strong) FiatDealHeadView * headView;
@property (nonatomic, strong) SubFiatDealHeadView * subHeadView;
@property (nonatomic, strong) CoinDealTitleView *titleView;
@property (nonatomic, strong) FiatDealIndexVM * viewModel;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) FiatTransactionRecordsVM * allCurrencyVM;
@property (nonatomic, strong) NSMutableArray * currencySource;//所有币种数据
@property (nonatomic, strong) NSMutableArray * currencyDownArr;//所有币种下拉列表数据
@property (nonatomic, strong) NSMutableArray * otherDownArr;//所有卖家，付款方式，交易额度数组
@property (nonatomic, assign) NSInteger currencyDownIndex;//所有币种默认选择
@property (nonatomic, assign) NSInteger sellDownIndex;//所有卖家
@property (nonatomic, assign) NSInteger payDownIndex;//所有付款方式
@property (nonatomic, assign) NSInteger tradingDownIndex;//所有交易额度
@property (nonatomic, assign) BOOL shouldRun;//离开页面停止刷新
@end

@implementation FiatDealIndexVC
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.shouldRun = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableViews];
    [self setUpNavs];
    [self pullUpToLoadData];
    [self dropDownToRefreshData];
    [self configDefaultData];
    @weakify(self);
    //定时器，定时拉取实时数据
    [[RACSignal interval:5.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.shouldRun) {
                [self getInternationalMarketPrice];
            }
        });
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setNavBarStyle:NavigationBarStyleWhite backBtn:NO];
    self.navigationItem.titleView = self.titleView;
    [self.titleView setText:@"KBC/CNY"];
    self.shouldRun = YES;
    if(kUserIsLogin){
        self.viewModel.showCurrentUsers = @"0";
    }else{
        self.viewModel.showCurrentUsers = nil;
    }
    
    //刷新
//    [self.fiatDealTable.mj_header beginRefreshing];  
    [self getAllcurrencyData];
}

//设置默认数据
-(void)configDefaultData{
    self.viewModel.buysell = @"2";
    self.cellType = 2;
    self.currencyDownIndex = 0;//所有币种默认选择
    self.sellDownIndex = 0;
    self.tradingDownIndex = 0;
    self.payDownIndex = 0;
    self.viewModel.merchartType = nil;
    self.viewModel.payVal = nil;
    self.viewModel.orderStatus = nil;
    self.viewModel.frozenStatus = nil;

}

//获取该币种国际行情价
-(void)getInternationalMarketPrice{
    
    @weakify(self);
    [self.viewModel.markPriceSignal subscribeNext:^(id x) {
  
        @strongify(self);
        self.headView.rightLabel.text = [NSString stringWithFormat:@"￥ %@",[[x stringValue] keepDecimal:2]];
    }];
    
}

//获取所有币种
-(void)getAllcurrencyData{
    
    //订阅信号
    @weakify(self);
 
    [self.allCurrencyVM.allCurrencySignal subscribeNext:^(NSMutableArray * currencySource) {
        @strongify(self);
      
        if(currencySource.count == 0) return;
        
        [self.currencyDownArr removeAllObjects];
        self.currencySource = currencySource;
        
        //如果是第一次刷新
        if(self.isFirst == NO){
            self.isFirst = YES;
            for (int i=0;i<self.currencySource.count;i++) {
                //改变默认选择中值
                AllCurrencyModels * model = self.currencySource[i];
                if([model.tradeCode isEqualToString:@"KBC"]){
                    self.currencyDownIndex = i;
                }
            }
        }
 
        //给下拉列表赋值
        for(int i=0 ;i<self.currencySource.count;i++){
            downTableModel * model = [downTableModel new];
            AllCurrencyModels * currModel = self.currencySource[i];
            model.selected = NO;
            model.title = [NSString stringWithFormat:@"%@/CNY",currModel.tradeCode];
            model.tradeCode = currModel.tradeCode;
            model.image = currModel.logoUrl;
            if(i==self.currencyDownIndex){//如果当前币种有BTC
                model.selected = YES;
                [self.headView.leftBtn setTitle:model.title forState:UIControlStateNormal];
                self.viewModel.tradeCode = model.tradeCode;
            }
            
            [self.currencyDownArr addObject:model];
        }
        
        //如果没有BTC 默认第0个选中
        if(self.currencyDownIndex == 0){
            downTableModel * model = self.currencyDownArr[0];
            model.selected = YES;
            [self.headView.leftBtn setTitle:model.title forState:UIControlStateNormal];
            self.viewModel.tradeCode = model.tradeCode;
            
        }
        
        //获取国际行情价
        [self getInternationalMarketPrice];
        //根据币种刷新列表
        [self getNewData];
      
    }completed:^{
        [self.fiatDealTable.mj_header endRefreshing];
    }];
}

-(void)getNewData{
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.refreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            
            if (self.viewModel.hasMoreData) {
                [self.fiatDealTable.mj_footer endRefreshing];
            } else {
                [self.fiatDealTable.mj_footer endRefreshingWithNoMoreData];
            }
            [self.fiatDealTable.mj_header endRefreshing];
            
            [self.fiatDealTable reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.fiatDealTable.mj_footer endRefreshing];
            } else {
                [self.fiatDealTable.mj_footer endRefreshingWithNoMoreData];
            }
            [self.fiatDealTable.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.fiatDealTable.mj_footer endRefreshing];
            } else {
                [self.fiatDealTable.mj_footer endRefreshingWithNoMoreData];
            }
            [self.fiatDealTable.mj_header endRefreshing];
        }];
        
        
    }];
    
    
    //开始刷新
    [self.viewModel.refreshCommand execute:kIsRefreshY];
    
    
}


#pragma mark - 下拉刷新
- (void)dropDownToRefreshData
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAllcurrencyData];
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.fiatDealTable.mj_header = header;
}

#pragma mark - 上拉加载更多
- (void)pullUpToLoadData
{

    self.fiatDealTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel.refreshCommand execute:kIsRefreshN];
    }];

}


-(void)setUpTableViews{
    
    self.view.backgroundColor = kBackGroundColor;
    self.fiatDealTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.fiatDealTable.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.fiatDealTable];
    [self.fiatDealTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.fiatDealTable.delegate = self;
    self.fiatDealTable.dataSource = self;
    self.fiatDealTable.tableFooterView = [UIView new];
    self.fiatDealTable.showsVerticalScrollIndicator = NO;
    self.fiatDealTable.showsHorizontalScrollIndicator = NO;
    self.fiatDealTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.fiatDealTable.estimatedRowHeight = 0;
    self.fiatDealTable.estimatedSectionHeaderHeight = 0;
    self.fiatDealTable.estimatedSectionFooterHeight = 0;
 
    [self.fiatDealTable registerClass:[BuyFiatDealTableViewCell class] forCellReuseIdentifier:@"buyCell"];
    [self.fiatDealTable registerClass:[SellFiatDealTableViewCell class] forCellReuseIdentifier:@"sellCell"];
    self.headView = [[FiatDealHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, KFiatDealSectionHeight)];
    self.headView.btnDelegate = self;
    self.fiatDealTable.tableHeaderView = self.headView;
   
}

-(void)setUpNavs{

    [self addRightBarButtonItemWithTitle:kLocalizedString(@"发布广告") action:@selector(rightItemClick)];
}

#pragma mark--TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.cellType == 2){
        BuyFiatDealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.row];
        cell.buyDelegate = self;
        return cell;
    }else{
        SellFiatDealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sellCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.row];
        cell.sellDelegate = self;
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return Adapted(136);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adapted(54);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    self.subHeadView.btnDelegate = self;
    return self.subHeadView;

}

//section==0,所有币种
#pragma FiatDealHeadViewDelegate
- (void)sendFrameValue:(FiatDealHeadView *)headV{
    CGRect rect = [headV convertRect:headV.leftBtn.frame toView:nil];
    
    if(self.currencyDownArr.count==0)  return;
    
    DownTableView * tab = [[DownTableView alloc]initWithRect:rect dataArray:self.currencyDownArr type:0 maxCell:8 didSelect:1];
    tab.selectDelegate = self;
    [tab show];
   
}

#pragma mark--SubFiatDealHeadViewDelegate
//section==1    tag==2 3 4
- (void)sendSubFrameValue:(SubFiatDealHeadView *)headV withBtnTag:(NSInteger)tag{

    CGRect rect = [headV.leftBtn convertRect:headV.leftBtn.frame toView:nil];
    CGRect rect2 = rect;
    rect2.size.height -= Adapted(3);
    rect = rect2;
   
    NSArray * arr1 = @[kLocalizedString(@"所有卖家"),kLocalizedString(@"商家"),kLocalizedString(@"个人")];
    NSArray * arr2 = @[kLocalizedString(@"所有支付方式"),kLocalizedString(@"银行卡"),kLocalizedString(kLocalizedString(@"支付宝")),kLocalizedString(@"微信")];
    NSArray * arr3 = @[kLocalizedString(@"所有交易额度"),kLocalizedString(@"1万以下"),kLocalizedString(@"1万～50万"),kLocalizedString(@"50万以上")];
    
    [self.otherDownArr removeAllObjects];
    NSArray * arr;
    NSInteger  selectIndes = 0;
    if(tag == 2){
        //所有卖家
        arr = arr1;
        selectIndes = self.sellDownIndex;
    }else if(tag == 3){
        //所有支付方式
        arr = arr2;
        selectIndes = self.payDownIndex;
    }else if (tag == 4){
        //所有交易额度
        arr = arr3;
        selectIndes = self.tradingDownIndex;
    }
    
    
    for(int i=0 ;i<arr.count;i++){
        downTableModel * model = [downTableModel new];
        model.selected = NO;
        model.title = arr[i];
        model.currency = self.viewModel.tradeCode;
        if(i == selectIndes){
            model.selected = YES;
        }
        [self.otherDownArr addObject:model];
    }
    
    DownTableView * tab = [[DownTableView alloc]initWithRect:rect dataArray:self.otherDownArr type:2 maxCell:4 didSelect:tag];
    tab.selectDelegate = self;
    [tab show];
}

#pragma mark--didSelectItemDelegate
- (void)sendItemValue:(NSInteger )index dataArray:(NSArray *)dataArray disSelect:(NSInteger )didSelect isEmpty:(BOOL)isEmpty{
    downTableModel * model = dataArray[index];
    if(didSelect == 1){//所有币种
        
        if(!isEmpty){
            [self.titleView setText:model.title];
            [self.headView.leftBtn setTitle:model.title forState:UIControlStateNormal];
            self.viewModel.tradeCode = model.tradeCode;
            self.currencyDownIndex = index;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.fiatDealTable.mj_header beginRefreshing];
            });
        }
        self.headView.leftBtn.selected = NO;
        self.titleView.selected = NO;
        
    }else if (didSelect == 2){//所有卖家，商人，个人
        if(!isEmpty){
           [self.subHeadView.leftBtn setTitle:model.title forState:UIControlStateNormal];
            self.viewModel.tradeCode = model.tradeCode;
            self.sellDownIndex = index;
            
            if(self.sellDownIndex == 0){
                [self.subHeadView.leftBtn setTitleColor:k99999Color forState:UIControlStateNormal];
                self.viewModel.merchartType = nil;
            }else{
                self.viewModel.merchartType = s_Integer(index);
                [self.subHeadView.leftBtn setTitleColor:kTextColor forState:UIControlStateNormal];
            }
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.fiatDealTable.mj_header beginRefreshing];
            });
        }
        self.subHeadView.leftBtn.selected = NO;
    }else if (didSelect == 3){//支付方式
        if(!isEmpty){
            [self.subHeadView.middleBtn setTitle:model.title forState:UIControlStateNormal];
            self.viewModel.tradeCode = model.tradeCode;
            self.payDownIndex = index;
            
            if(self.payDownIndex == 0){
                [self.subHeadView.middleBtn setTitleColor:k99999Color forState:UIControlStateNormal];
                self.viewModel.payVal = nil;
            }else{
                [self.subHeadView.middleBtn setTitleColor:kTextColor forState:UIControlStateNormal];
                if(index == 1){
                   self.viewModel.payVal = @"1";
                }else if(index == 2){
                    self.viewModel.payVal = @"2";
                }else if (index == 3){
                    self.viewModel.payVal = @"4";
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.fiatDealTable.mj_header beginRefreshing];
            });
        }
        self.subHeadView.middleBtn.selected = NO;
    }else if (didSelect == 4){//所有交易额度
        if(!isEmpty){
            [self.subHeadView.rightBtn setTitle:model.title forState:UIControlStateNormal];
            self.viewModel.tradeCode = model.tradeCode;
            self.tradingDownIndex = index;
            
            if(self.tradingDownIndex == 0){
                self.viewModel.amountMin = nil;
                self.viewModel.amountMax = nil;
            }else if(self.tradingDownIndex == 1){
                self.viewModel.amountMin = @"10000";
                self.viewModel.amountMax = nil;
            }else if (self.tradingDownIndex == 2){
                self.viewModel.amountMin = @"10000";
                self.viewModel.amountMax = @"500000";
            }else if (self.tradingDownIndex == 3){
                self.viewModel.amountMin = nil;
                self.viewModel.amountMax = @"500000";
            }
            [self.subHeadView.rightBtn setTitleColor:self.tradingDownIndex == 0?k99999Color:kTextColor forState:UIControlStateNormal];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.fiatDealTable.mj_header beginRefreshing];
            });
        }
        self.subHeadView.rightBtn.selected = NO;
    }
    
}

#pragma mark-- FiatDealIndexCellDelegate
//买或卖切换
- (void)selectSegmentWithIndex:(NSInteger )index {

    self.cellType = index;
    self.viewModel.buysell = s_Integer(index);
    
    [self.fiatDealTable.mj_header beginRefreshing];

}

//跳交易记录
- (void)transactionRecords{
    
    @weakify(self);
    [TWAppTool permissionsValidationHandleFinish:^{
        @strongify(self);
        [self pushViewControllerWithName:@"FiatTransactionRecordsIndecVC"];
    }];
    
}


#pragma mark-- SubFiatDeallDelegate
//买入下单
- (void)BuyFiatDealWithBuy:(FiatDealBuyOrSellModel * )model{
    
//    BOOL isOK = [TWAppTool permissionsValidationHandleFinish:nil];
//    if(isOK == NO) return;
    
//是否实名
    
    PlaceOrderVC *vc = [[PlaceOrderVC alloc] init];
    vc.model = model;
    vc.isBuy = YES;
    [self.navigationController pushViewController:vc animated:YES];
    /*
    @weakify(self);
    self.payView = [[BuySellFiatDealView alloc]initWithSupView:self.view model:model sureBtnTitle:kLocalizedString(@"下单") sureBtnClick:^(NSString * tradeAmount,NSString * tradeQuantity,NSString * tradeCode) {
        @strongify(self);
        
        [self orderClickRequest:@"1" tradeAmount:tradeAmount tradeQuantity:tradeQuantity tradeCode:tradeCode advertisingOrderId:model.advertisingOrderId adUserId:model.adUserId];
        
        
    } cancelBtnClick:^{
        
    }];
    [self.payView show];
     */
}

//卖出下单
- (void)SellFiatDealWithBuy:(FiatDealBuyOrSellModel * )model{
    
//    BOOL isOK = [TWAppTool permissionsValidationHandleFinish:nil];
//    if(isOK == NO) return;
    
    PlaceOrderVC *vc = [[PlaceOrderVC alloc] init];
    vc.model = model;
    vc.isBuy = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    @weakify(self);
    self.payView = [[BuySellFiatDealView alloc]initWithSupView:self.view model:model sureBtnTitle:@"下单" sureBtnClick:^(NSString * tradeAmount,NSString * tradeQuantity,NSString * tradeCode) {
        @strongify(self);
        [self orderClickRequest:@"2" tradeAmount:tradeAmount tradeQuantity:tradeQuantity tradeCode:tradeCode advertisingOrderId:model.advertisingOrderId adUserId:model.adUserId];
        
        
    } cancelBtnClick:^{
        
    }];
    [self.payView show];
     */
}

- (void)orderClickRequest:(NSString *)buySell tradeAmount:(NSString *)tradeAmount tradeQuantity:(NSString *)tradeQuantity tradeCode:(NSString *)tradeCode advertisingOrderId:(NSString *)advertisingOrderId adUserId:(NSString *)adUserId{
    
    self.viewModel.orderBuysell = buySell;
    self.viewModel.orderTradeAmount = tradeAmount;
    self.viewModel.orderTradeQuantity = tradeQuantity;
    self.viewModel.orderTradeCode = tradeCode;
    self.viewModel.orderAdvertisingOrderId = advertisingOrderId;
    self.viewModel.adUserId = adUserId;
    self.viewModel.payBuySell = buySell;
    //订阅信号
    @weakify(self);
    [self.viewModel.orderSignal subscribeNext:^(NSString * orderId) {
        @strongify(self);
        [TTWHUD showCustomMsg:kLocalizedString(@"操作成功")];

        [self.payView hidden];
        
        FiatTradingVC * vc = [[FiatTradingVC alloc]init];
        vc.tradeOrderId = orderId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}

#pragma mark-- buttonClick
-(void)rightItemClick{

    @weakify(self);
    [TWAppTool permissionsValidationHandleFinish:^{
        @strongify(self);
        [self pushViewControllerWithName:@"FiatadvertisingPublishVC"];
    }];
    
}

#pragma mark--懒加载
-(SubFiatDealHeadView *)subHeadView{
    if(!_subHeadView){
        _subHeadView = [[SubFiatDealHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, KFiatDealSectionHeight)];
    }
    return _subHeadView;
}

-(FiatDealIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [FiatDealIndexVM new];
    }
    return _viewModel;
}

-(FiatTransactionRecordsVM *)allCurrencyVM{
    if(!_allCurrencyVM){
        _allCurrencyVM = [FiatTransactionRecordsVM new];
    }
    return _allCurrencyVM;
}

-(NSMutableArray *)currencyDownArr{
    if(!_currencyDownArr){
        _currencyDownArr = [NSMutableArray new];
    }
    return _currencyDownArr;
}

-(NSMutableArray *)otherDownArr{
    if(!_otherDownArr){
        _otherDownArr = [NSMutableArray new];
    }
    return _otherDownArr;
}

- (CoinDealTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [[CoinDealTitleView alloc] init];
        @weakify(_titleView);
        _titleView.clickBlock = ^(BOOL selected) {
          
            @strongify(_titleView);
            if(self.currencyDownArr.count==0)  return;
            
            CGRect rect = [self.navigationController.navigationBar convertRect:_titleView.frame toView:nil];
            
            DownTableView * tab = [[DownTableView alloc]initWithRect:rect dataArray:self.currencyDownArr type:0 maxCell:8 didSelect:1];
            tab.selectDelegate = self;
            [tab show];
        };
    }
    return _titleView;
}


@end
