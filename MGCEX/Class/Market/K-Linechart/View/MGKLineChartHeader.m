//
//  MGKLineChartHeader.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGKLineChartHeader.h"
#import "Masonry.h"

#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "UIDevice+TFDevice.h"
#import "CustomSegmentedView.h"
#import "TopDisplayView.h"
#import "Y_KLineModel.h"


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth,kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define TopSpace 110
#define ViweHeight 400



@interface MGKLineChartHeader()<Y_StockChartViewDataSource>
//*****************插件***************//


@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;

@property (nonatomic, assign) UIInterfaceOrientationMask mask;

@property (nonatomic, assign) NSInteger currentIndex;
///一分钟/一小时/一天.....的k线图
@property (nonatomic, copy) NSString *type;

@end
@implementation MGKLineChartHeader


- (void)updateDataWithArray:(NSArray *)dataArr
{
    if (dataArr.count < 8) {
        self.stockChartView.kLineView.hidden = YES;
    }else{
        self.stockChartView.kLineView.hidden = NO;
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:dataArr];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:self.type];
        [self.stockChartView reloadData];
}
    
}
-(void)setupSubviews
{
    self.currentIndex = -1;
    self.mask = UIInterfaceOrientationMaskPortrait;
    self.displayView.backgroundColor = kKLineBGColor;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
   
}


#pragma mark -- getter
- (MGKLineChartVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MGKLineChartVM new];
        _viewModel.market = self.market;
        _viewModel.symbols = self.symbols;
    }
    return _viewModel;
}
- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}
#pragma mark -- 头部展示视图
- (UIView *)displayView
{
    if (!_displayView) {
        _displayView = [[TopDisplayView alloc]init];
        [self addSubview:_displayView];
        [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(TopSpace);
            make.width.equalTo(self);
            make.top.mas_equalTo(0);
        }];
    }
    return _displayView;
}
//1、5、15、30、60、D、2D
#pragma mark -- k线图精度
-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";
        }
            break;
        case 2:
        {
            type = @"1min";
            self.viewModel.resolution = @"1";
        }
            break;
        case 3:
        {
            type = @"5min";
            self.viewModel.resolution = @"5";
        }
            break;
        case 4:
        {
            type = @"30min";
            self.viewModel.resolution = @"30";
        }
            break;
        case 5:
        {
            type = @"1hour";
            self.viewModel.resolution = @"60";
        }
            break;
        case 6:
        {
            type = @"1day";
            self.viewModel.resolution = @"3600";
        }
            break;
        case 7:
        {
            type = @"1week";
            self.viewModel.resolution = @"25200";
        }
            break;
            
        default:
            type = @"1min";
            break;
    }
    self.currentIndex = index;
    self.type = type;
    //判断是否有缓存
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        self.stockChartView.kLineView.hidden = NO;
        return [self.modelsDict objectForKey:type].models;
    }
    return nil;
}
#pragma mark -- 加载k线图数据
- (void)reloadData
{
    @weakify(self);
    //获取k线图
    [self.viewModel.kLineDataSignal subscribeNext:^(id x) {
        [self updateDataWithArray:x];
    }];
}
#pragma mark -- k线图
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"指标") type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"分时") type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"1分") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"5分") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"30分") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"60分") type:Y_StockChartcenterViewTypeKline]
                                       
                                       ];
        
        /**
        [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"日线") type:Y_StockChartcenterViewTypeKline],
        [Y_StockChartViewItemModel itemModelWithTitle:kLocalizedString(@"周线") type:Y_StockChartcenterViewTypeKline],
        **/
        
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self addSubview:_stockChartView];
        [self remakeStockViewContraint];
        KWeakSelf;
        //竖线移动回调
        _stockChartView.kLineView.chartLineMoveBlock = ^(Y_KLineModel *model){
        };
    }
    return _stockChartView;
}
- (void)remakeStockViewContraint
{
    [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.top.mas_equalTo(self.displayView.mas_bottom);
            make.left.right.mas_equalTo(0);
             make.bottom.mas_equalTo(0);
        } else {
            make.top.mas_equalTo(self.displayView.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.equalTo(self);
            make.bottom.mas_equalTo(0);
        }
    }];
}
#pragma mark -- 选择器

















@end
