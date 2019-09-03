// MGC
//
// MarketIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 描述

#import "MarketIndexVC.h"
#import "CustomSegmentedView.h"
#import "MarketIndexVM.h"
#import "MarketIndexCell.h"
#import "MGKLineChartVC.h"
#import "CoinDealIndexVM.h"

#define CellID @"cell"
///市场
#define kMarketKey @"AMDD"
//币种
#define kCoinTypeKey @"AUC"
//表头选择器tag
#define kSegmentTag 1200
@interface MarketIndexVC ()
@property (nonatomic, strong) MarketIndexVM *viewModel;
///市场
@property (nonatomic, strong) NSArray *marketArr;
//定时器
@property (nonatomic, assign) BOOL shouldRun;
///交易对数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//保存当前选择的市场
@property (nonatomic, assign) NSInteger selectIndex;
//记录上一个选项  -1为初始化状态 刚进页面
@property (nonatomic, assign) NSInteger lastSelectIndex;
//
@property (nonatomic, strong) CustomSegmentedView * segMentview;
@property (nonatomic, strong) UIView *headerView;
///币币交易VM
@property (nonatomic, strong) CoinDealIndexVM *coinDealIndexVM;
///自选交易对
@property (nonatomic, strong) NSMutableArray *optionalTradePair;
///自选交易对
@property (nonatomic, strong) NSMutableArray *optionalAllAreaTradePair;
///当前列表是否自选列表
@property (nonatomic, assign) BOOL isOptional;

@end

@implementation MarketIndexVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isExtendLayout = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.shouldRun = YES;
    if (self.shouldChangeToSelfSelected || (kUserIsLogin && self.selectIndex == 0)) {
        if (self.marketArr.count > 0) {
            [self.segMentview changeToIndex:0];
            self.shouldChangeToSelfSelected = NO;
        }else{
             [self.viewModel.refreshCommand execute:kIsRefreshY];
        }
    } else if(self.lastSelectIndex != -1 && self.selectIndex == 0) {//在未登录情况下 回到上一个选中
        [self.segMentview changeToIndex:self.lastSelectIndex];
    }
    //每次进入页面刷新
    [self getMyCurrentChoice];
    [self.viewModel.refreshCommand execute:kIsRefreshY];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.shouldRun = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isExtendLayout = NO;
    //初始化 自选 还是其他的
    self.selectIndex = kUserIsLogin ? 0 : 1;
    self.shouldChangeToSelfSelected = self.selectIndex == 0 ? YES : NO;
    self.lastSelectIndex = -1;
    [self selectMarketWithIndex:self.selectIndex];
}
- (void)setUpTableViewUI
{
    [super setUpTableViewUI];
//    self.title = kLocalizedString(@"行情");
    [self.tableView registerClass:[MarketIndexCell class] forCellReuseIdentifier:CellID];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorColor = kLineColor;
    
    @weakify(self);
    //下拉刷新
    [self dropDownToRefreshData:^{
        @strongify(self);
        [self getMyCurrentChoice];
        [self.viewModel.refreshCommand execute:kIsRefreshY];
    }];
    [self getMyCurrentChoice];
    [self.viewModel.refreshCommand execute:kIsRefreshY];
//    [self.tableView.mj_header beginRefreshing];
}
#pragma mark -- 拉取实时行情
- (void)getRealTimeData{
    @weakify(self);
    if (self.shouldRun) {
        [self.viewModel.getRealtimeDataSignal subscribeNext:^(id x) {
            @strongify(self);
            self.dataArray = x;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } error:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
}
#pragma mark -- 获取自选实时行情
- (void)getOptionalRealTimeData{
    @weakify(self);
    if (self.shouldRun) {
        [self.viewModel.getOptionalRealtimeDataSignal subscribeNext:^(id x) {
            @strongify(self);
            self.dataArray = x;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } error:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
}
#pragma mark -- 点击市场
- (void)selectMarketWithIndex:(NSInteger)index
{
    //自选的交易对数据源不一样
    if (self.isOptional) {
        if (kUserIsLogin) {
            self.viewModel.optionalCoinTypeArr = self.optionalAllAreaTradePair;
        }else{
            //跳转到登录页面
        }
        
    }else{
        //普通市场交易对
        if (self.marketArr.count >index && self.dataSource.count > index) {
            self.viewModel.Symbols = self.marketArr[index];
            [self.viewModel.coinTypeArr removeAllObjects];
            NSDictionary *firstDic = self.dataSource[index];
            if (firstDic) {
                NSDictionary *mainDic = firstDic[@"main"];
                if (mainDic) {
                    [self.viewModel.coinTypeArr addObject:mainDic];
                }
                NSDictionary *innovateDic = firstDic[@"innovate"];
                if (innovateDic) {
                    [self.viewModel.coinTypeArr addObject:innovateDic];
                }
            }
        }
    }
    
}
-(void)bindViewModel{
    @weakify(self);
#warning 上线检查
    //定时器，定时拉取实时数据
    [[RACSignal interval:5.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        if (self.isOptional) {//自选
            [self getOptionalRealTimeData];
        }else{//普通
            [self getRealTimeData];
        }
    }];
    //订阅信号
    [[self.viewModel.refreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSArray *dataArray) {
            
            @strongify(self);
            [self.viewModel.coinTypeArr removeAllObjects];
            NSMutableArray *marketArr = [NSMutableArray new];
            //          获取市场名称
            self.dataSource = dataArray;
            for (NSDictionary *dic in dataArray) {
                [marketArr addObject:dic[@"market"][0]];
            }
            if (marketArr.count > 0) {
                [marketArr insertObject:kLocalizedString(@"自选") atIndex:0];
                self.marketArr = marketArr;
                self.tableView.tableHeaderView = self.headerView;
//          默认选择第一个市场
                [self selectMarketWithIndex:self.selectIndex];
                //tips：是否需要切换到自选列表
                if (self.shouldChangeToSelfSelected) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.segMentview changeToIndex:0];
                        self.shouldChangeToSelfSelected = NO;
                    });
                }
                if (!self.isOptional) {
                    [self getRealTimeData];
                }
            }else{
                self.marketArr = marketArr;
                self.dataArray = [marketArr mutableCopy];
                [self.tableView reloadData];
            }   
        }error:^(NSError *error) {
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        } completed:^{
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
        
    }];
    
}
#pragma mark-- 获取我的自选交易对
-(void)getMyCurrentChoice{
    
    if(!kUserIsLogin)  return;
    @weakify(self);
    [self.coinDealIndexVM.getMyChoiceSignal subscribeNext:^(NSArray *arr) {
        @strongify(self);
        [self.optionalTradePair removeAllObjects];
        //主区
        NSMutableArray *mainAreaArr = [NSMutableArray new];
        //创新区
        NSMutableArray *innovateArr = [NSMutableArray new];
        //全部
        NSMutableArray *allAreaArr = [NSMutableArray new];
        for (OptionalModel * model in arr) {
            NSString *pair = [NSString stringWithFormat:@"%@:%@",model.market,model.symbol];
            if (model.area == 1) {
                [mainAreaArr addObject:pair];
            }else{
                [innovateArr addObject:pair];
            }
            [allAreaArr addObject:pair];
        }
        self.optionalAllAreaTradePair = allAreaArr;
        self.viewModel.optionalCoinTypeArr = self.optionalAllAreaTradePair;
        [self.optionalTradePair addObject:mainAreaArr];
        [self.optionalTradePair addObject:innovateArr];
        self.viewModel.optionalCoinTypeAreaArr = self.optionalTradePair;
        
        if (self.isOptional) {
            [self getOptionalRealTimeData];
        }
    } completed:^{
        
    }];
}

#pragma mark-- 添加自选
-(void)collectTradePair:(MarketIndexCell *)cell{
    if (kStringIsEmpty(cell.marketIndexRealTimeModel.symbol)||kStringIsEmpty(cell.marketIndexRealTimeModel.market)) {
        return;
    }
    @weakify(self);
    self.coinDealIndexVM.transPare = [NSString stringWithFormat:@"%@:%@",cell.marketIndexRealTimeModel.symbol,cell.marketIndexRealTimeModel.market];
    [self.coinDealIndexVM.addMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        [self.tableView.mj_header beginRefreshing];
    } completed:^{
        
    }];
}
#pragma mark-- 取消自选
-(void)cancelMyCurrentChoice:(MarketIndexCell *)cell{
    if (kStringIsEmpty(cell.marketIndexRealTimeModel.symbol)||kStringIsEmpty(cell.marketIndexRealTimeModel.market)) {
        return;
    }
    self.coinDealIndexVM.transPare = [NSString stringWithFormat:@"%@:%@",cell.marketIndexRealTimeModel.symbol,cell.marketIndexRealTimeModel.market];
    @weakify(self);
    [self.coinDealIndexVM.cancelMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        [self.tableView.mj_header beginRefreshing];
    } completed:^{
        
    }];
}
/**
 添加表头
 */
- (CustomSegmentedView *)segMentview
{
    if (!_segMentview) {
        _segMentview = [[CustomSegmentedView alloc]initWithSegmentArr:self.marketArr frame:CGRectMake(0, kStatusBarHeight, self.view.frame.size.width, Adapted(46))];
        _segMentview.slidView.backgroundColor = kMainColor;
        _segMentview.backView.backgroundColor = kBackAssistColor;
        _segMentview.textColor = UIColorFromRGB(0x707070);
        _segMentview.selectTextColor = kMainColor;
        _segMentview.tag = kSegmentTag;
        [_segMentview changeToIndex: self.selectIndex];
        _segMentview.segmentCallBlock = ^(NSInteger index,UILabel * label) {
            
            if(self.selectIndex == index) return;
            self.lastSelectIndex = self.selectIndex;
            self.selectIndex = index;
            [self selectMarketWithIndex:index];
            if (self.isOptional && self.optionalAllAreaTradePair.count<1) {
                NSMutableArray *arrayTemp = [NSMutableArray new];
                [arrayTemp addObject:[NSArray new]];
                [arrayTemp addObject:[NSArray new]];
                self.dataArray = arrayTemp;
                [self.tableView reloadData];
                //验证是否需要登录
                [TWAppTool permissionsValidationHandleFinish:^{
                }];
            }else{
                [self.tableView.mj_header beginRefreshing];
            }
        };
    }
    
    return _segMentview;
}
#pragma mark -- tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adapted(42.0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketIndexCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSArray *arr = self.dataArray[indexPath.section];
    cell.marketIndexRealTimeModel = arr[indexPath.row];
    cell.selectBlock = ^(BOOL selected){
        selected?[self cancelMyCurrentChoice:cell]:[self collectTradePair:cell];
    };
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, MAIN_SCREEN_WIDTH, 0, 0);
    }
    else
    {
        cell.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Adapted(52);
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kBackGroundColor;
    
    UILabel *secTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adapted(6), MAIN_SCREEN_WIDTH, Adapted(36))];
    secTitleLabel.text = section == 0?kLocalizedString(@"   主区"):kLocalizedString(@"   创新区");
    secTitleLabel.textColor = kMainColor;
    secTitleLabel.backgroundColor = kBackGroundColor;
    [bgView addSubview:secTitleLabel];
    
    return bgView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.dataArray[indexPath.section];
    MGMarketIndexRealTimeModel *model = arr[indexPath.row];
    MGKLineChartVC *vc = [[MGKLineChartVC alloc]init];
    vc.symbols = model.symbol;
    vc.market = model.market;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- getter
-(BOOL)isOptional
{
    if (self.selectIndex == 0) {
        return YES;
    }
    return NO;
}
-(MarketIndexVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MarketIndexVM new];
    }
    return _viewModel;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(CoinDealIndexVM *)coinDealIndexVM{
    if(!_coinDealIndexVM){
        _coinDealIndexVM = [[CoinDealIndexVM alloc]init];
    }
    return _coinDealIndexVM;
}
-(NSMutableArray *)optionalTradePair
{
    if (!_optionalTradePair) {
        _optionalTradePair = [NSMutableArray new];
    }
    return _optionalTradePair;
}

- (UIView *)headerView{
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = white_color;
        _headerView.width = kScreenW;
        _headerView.height = Adapted(46) + kStatusBarHeight;
        [_headerView addSubview:self.segMentview];
    }
    return _headerView;
}




@end
