//
//  MGKLineChartVC.m
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGKLineChartVC.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "UIDevice+TFDevice.h"
#import "CustomSegmentedView.h"
#import "MGDepthChartCell.h"
#import "MGKLineChartHeader.h"
#import "MGKlineDealRecordCell.h"
#import "MGLineChartFooterView.h"
#import "MGKLineChartVM.h"
#import "TTWActionSheetView.h"
#import "CoinDealIndexVM.h"
#import "MarketIndexVM.h"
#import "MGKLinechartCoinInfoModel.h"
#import "MGKLinechartCoinInfoFillModel.h"
#import "MGCoinIntroductionImageCell.h"
#import "MGCoinIntroductionTitleCell.h"
#import "MGCoinIntroductionSubTitleCell.h"
#import "NSString+QSExtension.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)


#define kDetpCellID @"dep"
#define kDealRecordCellID @"record"
#define kDealRecordHeaderID @"recordHeader"
#define kMGCoinIntroductionImageCellID @"kMGCoinIntroductionImageCellID"
#define KMGCoinIntroductionTitleCellID @"KMGCoinIntroductionTitleCellID"
#define KMGCoinIntroductionSubTitleCellID @"KMGCoinIntroductionSubTitleCellID"

typedef NS_ENUM(NSUInteger, SegmentType) {
    SegmentRecordType= 0, // 成交记录
    SegmentIntroductionType
};

@interface MGKLineChartVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL shouldLandscape;
///是否显示成交记录
@property (nonatomic, assign) SegmentType segmentType;

//*****************自定义***************//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGKLineChartHeader *headerView;
@property (nonatomic, strong) MGLineChartFooterView *footerView;
@property (nonatomic, strong) CustomSegmentedView * segMentview;
@property (nonatomic, strong) Y_StockChartView *stockChartView;
@property (nonatomic, strong) CoinDealIndexVM *coinDealIndexVM;
///行情的viewmodel
@property (nonatomic, strong) MarketIndexVM *marketVM;

@property (nonatomic, strong) NSArray *recordArr;
// 币种信息数组
@property (nonatomic, strong) NSMutableArray *coinInfoArray;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, assign) BOOL shouldRun;
@property (nonatomic, assign) BOOL hasLoadCoinInfo;

@end

@implementation MGKLineChartVC

#pragma mark -- life circle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置导航栏背景
   
     [self setNavBarStyle:NavigationBarStyleModena backBtn:YES];
//    [self setNavBarWithTextColor:white_color barTintColor:kKLineBGColor tintColor:white_color statusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [UIImage imageWithColor:[kKLineBGColor colorWithAlphaComponent:1]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : white_color}];
    self.view.backgroundColor = kKLineBGColor;
    self.shouldRun = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//     [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.shouldRun = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    
     [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

#pragma mark -- 绑定
-(void)bindViewModel
{
    @weakify(self);
    self.coinDealIndexVM.transPares = @[string(string(self.market, @":"), self.symbols)];
    self.marketVM.optinalTradePair = @[string(string(self.market, @":"), self.symbols)];
    //获取行情
    [self getQuotes];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //获取我的自选交易对
        [self getMyCurrentChoice];
    });
    //获取成交记录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.headerView.viewModel.getDealRecordSignal subscribeNext:^(id x) {
            @strongify(self);
            self.recordArr = x;
            [self.tableView reloadData];
        }];
    });
    [[RACSignal interval:5.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        if (self.shouldRun) {
            [self getQuotes];
        }
    }];
}

- (void)getCoinInfo
{
    if (!self.hasLoadCoinInfo) {
        // 获得币种信息
        @weakify(self);
        [self.headerView.viewModel.getCoinInfoSignal subscribeNext:^(MGKLinechartCoinInfoModel *model) {
            @strongify(self);
            [self configDataWithModel:model];
            [self.tableView reloadData];
        }];
    }
}

- (void)configDataWithModel:(MGKLinechartCoinInfoModel *)model
{
    if (model == nil) {
        return;
    }
    [self.coinInfoArray removeAllObjects];
    if (model.shortName.length > 0) {//币种名称
        NSString *title = model.shortName;
        if(!kStringIsEmpty(model.tradeCode)) title = [title stringByAppendingFormat:@"(%@)",model.tradeCode];
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:title content:nil subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillBigTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.logoUrl.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"货币图标:") content:@""  subTitle:@"" imageUrlStr:model.logoUrl cellType:CoinInfoFillImageCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.area > 0) {
        NSString *content = (model.area == 1) ? kLocalizedString(@"主区") : kLocalizedString(@"创新区");
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"币种所在区域:") content:content  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
//    if (model.tradeCode.length > 0) {
//        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"项目简称:") content:model.tradeCode  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
//        [self.coinInfoArray addObject:fillModel];
//    }
    if (model.orientation.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"项目定位:") content:model.orientation  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.benTime.length > 0) {
        NSString *bentime = [NSString mg_handleTime:model.benTime];
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"众筹起始时间:") content:bentime  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.endTime.length > 0) {
        NSString *endTime = [NSString mg_handleTime:model.endTime];
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"众筹结束时间:") content:endTime  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.numbers.length > 0) {
        NSInteger numbers = [model.numbers integerValue];
        NSString *content = @"";
        if ([[NSBundle getPreferredLanguage] rangeOfString:@"en"].location != NSNotFound) {
            if(numbers >= 1000){
                content = [NSString stringWithFormat:@"%ld.%ld thousand",numbers/1000,numbers%1000];
            }else{
                content = [NSString stringWithFormat:@"%ld",numbers];
            }
        }else{
            if(numbers >= 10000){
                content = [NSString stringWithFormat:@"%ld.%ld %@",numbers/10000,numbers%10000,kLocalizedString(@"万")];
            }else{
                content = [NSString stringWithFormat:@"%ld",numbers];
            }
        }
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"成功众筹数量:") content:content  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.avgPrice.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"众筹均价:") content:[NSString stringWithFormat:@"￥%@",model.avgPrice]  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.introduction.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"项目介绍:") content:@""  subTitle:model.introduction imageUrlStr:@"" cellType:CoinInfoFillSubTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.website.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"网站:") content:model.website  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.whitePaper.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"项目白皮书:") content:@""  subTitle:model.whitePaper imageUrlStr:@"" cellType:CoinInfoFillSubTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.community.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"社交媒体以及社区:") content:model.community  subTitle:@"" imageUrlStr:@"" cellType:CoinInfoFillTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    if (model.situation.length > 0) {
        MGKLinechartCoinInfoFillModel *fillModel = [[MGKLinechartCoinInfoFillModel alloc]initWithTitle:kLocalizedString(@"融资状况:") content:@""  subTitle:model.situation imageUrlStr:@"" cellType:CoinInfoFillSubTitleCellType];
        [self.coinInfoArray addObject:fillModel];
    }
    
}
#pragma mark -- 获取行情
- (void)getQuotes {
    @weakify(self);
    [self.marketVM.quotesSignal subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.displayView.model = self.model;
    }];
}
- (void)setupSubviews{
    self.segmentType = SegmentRecordType;//默认成交记录
    [super setupSubviews];
    self.title = string(string(kNotNull(self.symbols), @"/"), kNotNull(self.market));
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.headerView.market = self.market;
    self.headerView.symbols = self.symbols;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-60.0));
    }];
    [self.view addSubview:self.footerView];

    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];

    [self addRightBarButtonWithFirstImage:IMAGE(@"kLine_open") action:@selector(doubleTap)];
    
    //全屏返回按钮
    QSButton *btn = [[UIButton alloc]init];
    [btn setTitle:kLocalizedString(@"返回") forState:UIControlStateNormal];
    [btn setTitleColor:k99999Color forState:UIControlStateNormal];
    btn.titleLabel.font = H17;
    btn.hidden = YES;
    [self.headerView.stockChartView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(20));
        make.width.height.mas_equalTo(Adapted(40));
        make.left.mas_equalTo(Adapted(20));
    }];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self doubleTap];
    }];
    self.fullScreenBtn = btn;
}
#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentType == SegmentRecordType){
        NSInteger num = self.recordArr.count>30?30:self.recordArr.count+1;
        num = num<1?1:num;
        return num;
    }else {
        return self.coinInfoArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adapted(46);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentType == SegmentRecordType) { // 成交记录
        
        if (indexPath.row == 0) {
            MGKlineDealRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kDealRecordCellID];
            [cell changeColor];
            cell.priceLab.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"价格"),kNotNull(self.market)];
            return cell;
        }
        MGKlineDealRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kDealRecordHeaderID];
        if (self.recordArr.count > indexPath.row - 1) {
            cell.model = self.recordArr[indexPath.row - 1];
        }
        
        return cell;
    } else { // 币种信息
        MGKLinechartCoinInfoFillModel *model = self.coinInfoArray[indexPath.row];
        switch (model.cellType) {
            case CoinInfoFillBigTitleCellType:{
                MGCoinIntroductionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGCoinIntroductionTitleCellID];
                if (cell == nil) {
                    cell = [[MGCoinIntroductionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMGCoinIntroductionTitleCellID];
                }
                [cell configWithModel:model];
                return cell;
            }
                break;
            case CoinInfoFillImageCellType:{
                MGCoinIntroductionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMGCoinIntroductionImageCellID];
                if (cell == nil) {
                    cell = [[MGCoinIntroductionImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMGCoinIntroductionImageCellID];
                }
                 [cell configWithModel:model];
                return cell;
            }
                break;
            case CoinInfoFillTitleCellType:{
                MGCoinIntroductionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGCoinIntroductionTitleCellID];
                if (cell == nil) {
                    cell = [[MGCoinIntroductionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMGCoinIntroductionTitleCellID];
                }
                [cell configWithModel:model];
                return cell;
            }
                break;
            case CoinInfoFillSubTitleCellType:{
                MGCoinIntroductionSubTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGCoinIntroductionSubTitleCellID];
                if (cell == nil) {
                    cell = [[MGCoinIntroductionSubTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KMGCoinIntroductionSubTitleCellID];
                }
                [cell configWithModel:model];
                return cell;
            }
                break;
        }
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_segMentview) {
        NSArray * segArr = @[kLocalizedString(@"最近成交"),kLocalizedString(@"币种资料")];//@[@"深度图",@"交易记录"];
        _segMentview = [[CustomSegmentedView alloc]initWithSegmentArr:segArr frame:CGRectMake(0, 0, self.view.frame.size.width, Adapted(46))];
        _segMentview.slidView.backgroundColor = white_color;
        _segMentview.backView.backgroundColor = kKLineBGColor;
        _segMentview.selectTextColor = white_color;
        _segMentview.textColor = UIColorFromRGB(0x89A0D6);
        [_segMentview changeToIndex:0];
        self.segmentType = SegmentRecordType;
        @weakify(self);
        _segMentview.segmentCallBlock = ^(NSInteger index,UILabel * label) {
            @strongify(self);
            self.segmentType = index;
            if (self.segmentType == SegmentIntroductionType) {
                [self getCoinInfo];
                self.hasLoadCoinInfo = YES;
            }
            [self.tableView reloadData];
            /*
            switch (index) {
                case SegmentRecordType:{
//                    self.segMentview.segLabel1.backgroundColor = kBackAssistColor;
//                    self.segMentview.segLabel2.backgroundColor = kBackGroundColor;
                
                }
                    break;
                case SegmentIntroductionType:{
                    
//                    self.segMentview.segLabel1.backgroundColor = kBackGroundColor;
//                    self.segMentview.segLabel2.backgroundColor = kBackAssistColor;
                }
                    
                default:
                    break;
            }
             */
            //开始刷新
        };
    }
    return _segMentview;
}
#pragma mark -- 双击全屏
- (void)doubleTap
{
    
    if (self.tt++%2==0) {
        self.fullScreenBtn.hidden = NO;
        self.stockChartView = self.headerView.stockChartView;
        [self.navigationController setNavigationBarHidden:YES];
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //允许转成横屏
        appDelegate.allowRotation = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        [self.stockChartView removeFromSuperview];
        [self.view addSubview:self.stockChartView];
        //MA线右移
        [self.stockChartView.kLineView.kLineMAView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@80);
        }];
        
        [self.stockChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_X) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 0));
            } else {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }
        }];
        
        //调用转屏代码
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        self.fullScreenBtn.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO];
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
        [self.stockChartView removeFromSuperview];
        [self.headerView addSubview:self.headerView.stockChartView];
        //切换到竖屏
        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
        [self.headerView remakeStockViewContraint];
        [self.stockChartView.kLineView.kLineMAView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
        }];
    }
    
}

#pragma mark -- 跳转到币币交易首页
- (void)toCoinDealWithType:(BOOL)isBuy
{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *dealType = isBuy?@"YES":@"NO";
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dealType,kIsbuy,self.market,@"market",self.symbols,@"symbols", nil];
        NSNotification *notification =[NSNotification notificationWithName:changeDealTypeNoti object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
}
#pragma mark-- 添加自选
-(void)collectTradePair{
    if (kStringIsEmpty(self.symbols)||kStringIsEmpty(self.market)) {
        return;
    }
    @weakify(self);
    self.coinDealIndexVM.transPare = [NSString stringWithFormat:@"%@:%@",self.symbols,self.market];
    [self.coinDealIndexVM.addMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        @strongify(self);
        _footerView.collectBtn.selected = YES;
    } completed:^{
        
    }];
    
}
#pragma mark-- 取消自选
-(void)cancelMyCurrentChoice{
    if (kStringIsEmpty(self.symbols)||kStringIsEmpty(self.market)) {
        return;
    }
    self.coinDealIndexVM.transPare = [NSString stringWithFormat:@"%@:%@",self.symbols,self.market];
    @weakify(self);
    [self.coinDealIndexVM.cancelMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        @strongify(self);
        _footerView.collectBtn.selected = NO;
    } completed:^{
        
    }];
}
#pragma mark-- 获取我的自选交易对
-(void)getMyCurrentChoice{
    
    if(!kUserIsLogin)  return;
    
    @weakify(self);
    [self.coinDealIndexVM.getMyChoiceSignal subscribeNext:^(NSArray *arr) {
        @strongify(self);
        NSMutableArray *tradePair = [NSMutableArray new];
        for (OptionalModel * model in arr) {
            [tradePair addObject:[NSString stringWithFormat:@"%@:%@",model.market,model.symbol]];
            if (([model.symbol isEqualToString:self.symbols] && [model.market isEqualToString:self.market])) {
                self.footerView.collectBtn.selected = YES;
                break;
            }
        }

    } completed:^{
        
    }];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kKLineBGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MGDepthChartCell class] forCellReuseIdentifier:kDetpCellID];
        [_tableView registerClass:[MGKlineDealRecordCell class] forCellReuseIdentifier:kDealRecordCellID];
        [_tableView registerClass:[MGKlineDealRecordCell class] forCellReuseIdentifier:kDealRecordHeaderID];
//        self.tableView.tableFooterView = self.footerView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark -- 表头，展示k线图
- (MGKLineChartHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[MGKLineChartHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(470.0))];
        _headerView.market = self.market;
        _headerView.symbols = self.symbols;
        
    }
    return _headerView;
}
- (MGLineChartFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[MGLineChartFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(60))];
        _footerView.collectBtn.selected = self.model.isOptional;
        @weakify(self);
        //卖出
        [[_footerView.sellBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            //跳转到币币交易
            [self toCoinDealWithType:NO];
        }];
        //买入
        [[_footerView.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            [self toCoinDealWithType:YES];
        }];
        //自选
        [[_footerView.collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            @strongify(self);
            if (btn.selected) {
                [self cancelMyCurrentChoice];
            }else{
                [self collectTradePair];
            }
            
        }];
    }
    return _footerView;
}

#pragma mark -- getter
-(CoinDealIndexVM *)coinDealIndexVM
{
    if (!_coinDealIndexVM) {
        _coinDealIndexVM = [CoinDealIndexVM new];
    }
    return _coinDealIndexVM;
}
-(MarketIndexVM *)marketVM
{
    if (!_marketVM) {
        _marketVM = [MarketIndexVM new];
    }
    return _marketVM;
}

- (NSMutableArray *)coinInfoArray
{
    if (!_coinInfoArray) {
        _coinInfoArray = [NSMutableArray array];
    }
    return _coinInfoArray;
}




@end
