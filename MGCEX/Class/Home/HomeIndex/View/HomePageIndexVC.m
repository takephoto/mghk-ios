// MGC
//
// HomePageIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "HomePageIndexVC.h"
#import "HomeBannerView.h"
#import "HomeBulletinCell.h"
#import "HomeNestTableViewCell.h"
#import "HomeOptionalCell.h"
#import "MarketIndexVM.h"
#import "ForcedUpdateView.h"
#import "MandatoryUpDataVC.h"
#import "CoinDealIndexVM.h"
#import "HomeIndexVM.h"
#import "AnnouncementDetailVC.h"

@interface HomePageIndexVC ()
///行情的viewmodel
@property (nonatomic, strong) MarketIndexVM *marketVM;
///市场
@property (nonatomic, strong) NSArray *marketArr;
///涨幅榜数据源
@property (nonatomic, strong) NSMutableArray *upLowDataSource;
///新币榜数据源(newCoinDataSource系统保留)
@property (nonatomic, strong) NSMutableArray *nCoinDataSource;
//定时器
@property (nonatomic, assign) BOOL shouldRun;

@property (nonatomic, strong) HomeBannerView * headView;
@property (nonatomic, assign) NSInteger coinIndex;
///推荐交易对
@property (nonatomic, strong) NSArray *optionalTradePair;
///推荐交易对datasource
@property (nonatomic, strong) NSArray *optionalDataSource;
///币币交易VM
@property (nonatomic, strong) CoinDealIndexVM *coinDealIndexVM;
///我的自选
@property (nonatomic, strong) NSMutableArray *optionalTradePairArr;
@property (nonatomic, strong) HomeIndexVM * homeIndexVM;
@property (nonatomic, strong) NSMutableArray * anMentArray;
@property (nonatomic, assign) BOOL isUpdataAnnment;
@end

@implementation HomePageIndexVC
-(NSMutableArray *)upLowDataSource
{
    if (!_upLowDataSource) {
        _upLowDataSource = [NSMutableArray new];
    }
    return _upLowDataSource;
}
-(NSMutableArray *)nCoinDataSource
{
    if (!_nCoinDataSource) {
        _nCoinDataSource = [NSMutableArray new];
    }
    return _nCoinDataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.shouldRun = YES;
    [self scrollViewDidScroll:self.tableView];
    self.navigationController.navigationBar.translucent = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.tabBarController.tabBar.hidden = NO;
    
    BOOL ChangeLangue = [[NSUserDefaults standardUserDefaults] boolForKey:isChangeLangue];
    if(ChangeLangue){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isChangeLangue];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self pushViewControllerWithName:@"PersonalSettingsIndexVC"];
    }
    
    [self getRealTimeData];
    [self getAnnouncementList];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.shouldRun = NO;
}

#pragma mark -- 获取公告列表
-(void)getAnnouncementList{
    
    self.homeIndexVM.num = @"3";
    self.homeIndexVM.h5 = @"app";
    @weakify(self);
    [self.homeIndexVM.getAnmentSignal subscribeNext:^(NSMutableArray *arr) {
        @strongify(self);
        self.isUpdataAnnment = YES;
        [self.anMentArray removeAllObjects];
        //取前3
        [arr enumerateObjectsUsingBlock:^(HomeIndexModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(self.anMentArray.count<3){
                [self.anMentArray addObject:model];
            }
            if(self.anMentArray.count==3){
                *stop = YES;
            }
        }];
      
        [self.tableView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -- 获取行情列表
-(void)getMarkList{
    
    self.coinIndex = 1;
    @weakify(self);
    //定时器，定时拉取实时数据
    [[RACSignal interval:5.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getRealTimeData];
        });
    }];
    //订阅信号
    [[self.marketVM.refreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSArray *dataArray) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.upLowDataSource removeAllObjects];
            [self.nCoinDataSource removeAllObjects];
            NSMutableArray *marketArr = [NSMutableArray new];
            //            //获取市场名称
            for (NSDictionary *dic in dataArray) {
                [marketArr addObject:dic[@"market"][0]];
            }
            self.marketArr = marketArr;
            
            //主区创新区交易对
            for (NSDictionary *dic in dataArray) {
                NSMutableArray *arrTemp = [NSMutableArray new];
                NSString *market = dic[@"market"][0];
                NSArray *mainArr = dic[@"main"];
                for (NSString *mainType in mainArr) {
                    [self.upLowDataSource addObject:string(market, string(@":", mainType))];
                }
                NSArray *innovateArr = dic[@"innovate"];
                for (NSString *innovateType in innovateArr) {
                    [self.nCoinDataSource addObject:string(market, string(@":", innovateType))];
                }
            }
            if (self.marketVM.coinTypeArr.count < 1) {
                self.marketVM.coinTypeArr = self.upLowDataSource;
            }
            [self getRealTimeData];
        }error:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            @strongify(self);
        }];
        
        [x subscribeCompleted:^{
            [self.tableView.mj_header endRefreshing];
            @strongify(self);
        }];
        
    }];
}

-(void)bindViewModel
{
    
#ifdef DEBUG
    // Debug 模式的代码...
#else
    // Release 模式的代码...
    //检查更新
    [TWAppTool CheckWhetherTheMandatoryUpdate];
#endif
    
    //获取公告列表
    [self getAnnouncementList];
    
    //定时刷新行情列表
    [self getMarkList];
    
}


-(void)setUpTableViewUI
{
    [super setUpTableViewUI];
    [self configTableView];
    
    [self setUpNavBar];
    @weakify(self);
    //下拉刷新
    [self dropDownToRefreshData:^{
        @strongify(self);
        [self.marketVM.refreshCommand execute:kIsRefreshY];
        //获取公告列表
        [self getAnnouncementList];
    }];
    [self.marketVM.refreshCommand execute:kIsRefreshY];
}
- (void)getRealTimeData{
    @weakify(self);
    if (self.shouldRun) {
        self.marketVM.optinalTradePair = self.optionalTradePair;
        [self.marketVM.quotesSignal subscribeNext:^(id x) {
            @strongify(self);
            self.optionalDataSource = x;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.marketVM.getHomePageRealtimeDataSignal subscribeNext:^(id x) {
                @strongify(self);
                self.dataArray = x;
                [self.tableView reloadData];
            }];
        });
        
        
    }
}
#pragma mark -- 筛选指定交易对
- (NSMutableArray *)filtrateOptionalDataWithTargets:(NSArray *)targetArr dataSource:(NSArray *)dataSource
{
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSString *tradePair in targetArr) {
        NSArray *targetStrArr = [tradePair componentsSeparatedByString:@"/"];
        for (MGMarketIndexRealTimeModel *model in dataSource) {
            if ([model.symbol isEqualToString:targetStrArr.firstObject] && [model.market isEqualToString:targetStrArr.lastObject]) {
                [results addObject:model];
            }
        }
    }
    return results;
}
// 滑动过程中做导航透明处理处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.navigationController.navigationBar changeColor:kNavTintColor WithScrollView:scrollView AndValue:200];
}

//配置tableview
-(void)configTableView{
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(-TW_TopHeight);
    }];
    ///以下三行解决tableView滚动时reload 会跳动问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerClass:[HomeOptionalCell class] forCellReuseIdentifier:@"Optional"];
    
    [self.tableView registerClass:[HomeBulletinCell class] forCellReuseIdentifier:@"Bulletin"];
    
    [self.tableView registerClass:[HomeNestTableViewCell class] forCellReuseIdentifier:@"NestTable"];
}

//配置导航
-(void)setUpNavBar{
    self.navigationItem.title = @"MEIB.IO";
    
//    [self setLeftItemWithIcon:[UIImage imageNamed:@"Me_home"] title:nil titleColor:nil selector:@selector(enterPersonalCenter)];
//
//    [self setRightItemWithIcon:[UIImage imageNamed:@"setting_home"] selector:@selector(entrPersonalSettings)];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.1;
    }
    return Adapted(12);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(12))];
    sectionView.backgroundColor = kBackGroundColor;
    return sectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return Adapted(180);
    }else if (indexPath.section == 0){
        return Adapted(48);
    }else if(indexPath.section == 2){
        return Adapted(52)*10+Adapted(44);
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){//自选涨幅
        HomeOptionalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Optional"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = self.optionalDataSource;
        return cell;
    }else if (indexPath.section == 0){//公告
        HomeBulletinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Bulletin"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.isUpdataAnnment == YES && self.anMentArray.count>0){
            self.isUpdataAnnment = NO;
           cell.upwardSingleMarqueeViewData = self.anMentArray;
        }
        
        //更多
        @weakify(self);
        [[[cell.moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self pushViewControllerWithName:@"AnnouncementListVC"];
        }];
        
        //点击公告详情
        cell.bulletinBlock = ^(HomeIndexModel *model) {
            @strongify(self);
            AnnouncementDetailVC * vc = [[AnnouncementDetailVC alloc]init];
            vc.urlStr = model.url;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }else{//涨幅／新币
        HomeNestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NestTable"];
        cell.dataSource = self.dataArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        ///涨幅榜按钮
        [[[cell.riseFallBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            self.coinIndex = 1;
            self.marketVM.coinTypeArr = self.upLowDataSource;
            [self getRealTimeData];
        }];
        ///新币榜按钮
        [[[cell.dollarsBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
            @strongify(self);
            self.coinIndex = 2;
            self.marketVM.coinTypeArr = self.nCoinDataSource;
            [self getRealTimeData];
        }];
        return cell;
    }
}

#pragma buttonClick

///进入个人中心
-(void)enterPersonalCenter{
    
    @weakify(self);
    [TWAppTool permissionsValidationHandleFinish:^{
        @strongify(self);
        [self pushViewControllerWithName:@"PersonalCenterIndexVC"];
    }];
    
}

//进入设置
-(void)entrPersonalSettings{
    [self pushViewControllerWithName:@"PersonalSettingsIndexVC"];
    
}
- (NSMutableArray *)optionalDataSource
{
    if (!_optionalDataSource) {
        _optionalDataSource = [NSMutableArray new];
    }
    return _optionalDataSource;
}
- (NSArray *)optionalTradePair
{
    if (!_optionalTradePair) {
        //        _optionalTradePair = @[@"MGXT:BYC",@"BYC:USDT",@"BTC:USDT"];
        _optionalTradePair = @[@"KBC:MGXT",@"USDT:KBC",@"USDT:BTC"];
    }
    return _optionalTradePair;
}
-(MarketIndexVM *)marketVM
{
    if (!_marketVM) {
        _marketVM = [MarketIndexVM new];
    }
    return _marketVM;
}

-(HomeBannerView *)headView{
    if(!_headView){
        _headView = [[HomeBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, Adapted(180))];
    }
    return _headView;
}
-(CoinDealIndexVM *)coinDealIndexVM{
    if(!_coinDealIndexVM){
        _coinDealIndexVM = [[CoinDealIndexVM alloc]init];
    }
    return _coinDealIndexVM;
}

-(HomeIndexVM *)homeIndexVM{
    if(!_homeIndexVM){
        _homeIndexVM = [[HomeIndexVM alloc]init];
    }
    return _homeIndexVM;
}

-(NSMutableArray *)anMentArray{
    if(!_anMentArray){
        _anMentArray = [NSMutableArray new];
    }
    return _anMentArray;
}
@end
