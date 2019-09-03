//
//  MGCoinDealRecordView.m
//  TestDemo
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 Joblee. All rights reserved.
//

#import "MGCoinDealRecordView.h"
#import "MGCoinDealRecordViewCell.h"
#import "MGCoinDealRecordViewCell.h"
#import "MGCoinDealTradeHeader.h"

#define kSellCellID @"sellCellID"
#define kBuyCellID @"buyCellID"

@interface MGCoinDealRecordView()
@property (nonatomic, strong) NSMutableArray * buyArr;
@property (nonatomic, strong) NSMutableArray * sellArr;

@end

@implementation MGCoinDealRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    
    }
    return self;
}
- (void)setupViews{
    self.tableview.backgroundColor = kBackAssistColor;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.sellArr.count;
    }else{
        return self.buyArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        MGCoinDealRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSellCellID];
        cell.model = self.sellArr[indexPath.row];

        return cell;
    }else{
        MGCoinDealRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBuyCellID];
        cell.model = self.buyArr[indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MGCoinDealRecordViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.isDisable == NO){
        [[NSNotificationCenter defaultCenter]postNotificationName:CoinDealprice object:[cell.priceLab.text removeFloatAllZero]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if(section == 1) return self.header;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 1) return Adapted(55);
    return CGFLOAT_MIN;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview .delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.estimatedRowHeight = 50.0;
        _tableview.backgroundColor = red_color;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        [_tableview registerClass:[MGCoinDealRecordViewCell class] forCellReuseIdentifier:kSellCellID];
        [_tableview registerClass:[MGCoinDealRecordViewCell class] forCellReuseIdentifier:kBuyCellID];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableHeaderView = self.headerView;
        [self addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _tableview;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(24))];
        
        UILabel *priceLab = [[UILabel alloc]init];
        [_headerView addSubview:priceLab];
        priceLab.textColor = kAssistColor;
        priceLab.text = kLocalizedString(@"价格（BTC）");
        priceLab.font = H11;
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(8));
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.headerView);
        }];
        self.priceLab = priceLab;
        
        UILabel *numberBgLab = [[UILabel alloc]init];
        [_headerView addSubview:numberBgLab];
        numberBgLab.textColor = kAssistColor;
        numberBgLab.textAlignment = NSTextAlignmentRight;
        numberBgLab.text = kLocalizedString(kLocalizedString(@"数量"));
        numberBgLab.font = H11;
        [numberBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.right.mas_equalTo(Adapted(-8));
            make.centerY.mas_equalTo(self.headerView);
        }];
        self.numberBgLab = numberBgLab;
    }
    return _headerView;
}


-(void)setMutabDic:(NSMutableDictionary *)mutabDic{
    _mutabDic = mutabDic;
    
    self.buyArr = [_mutabDic[@"buyArr"] mutableCopy];
    self.sellArr = [_mutabDic[@"sellArr"] mutableCopy];
    
    NSInteger buyArrCount = self.buyArr.count;
    NSInteger sellArrCount = self.sellArr.count;
    
    if(self.buyArr.count<5){
        for(int i=0 ;i<5-buyArrCount;i++){

            UnsettledGearModel * buyModel = [[UnsettledGearModel alloc]init];
            buyModel.buySell = 1;
            buyModel.price = @"0";
            buyModel.value = @"0";
            [self.buyArr addObject:buyModel];
        }
    }


    if(self.sellArr.count<5){
        for(int i=0 ;i<5-sellArrCount;i++){

            UnsettledGearModel * sellModel = [[UnsettledGearModel alloc]init];
            sellModel.buySell = 2;
            sellModel.price = @"0";
            sellModel.value = @"0";
//数据少于5条时，有数据的cell需要靠近中间
            [self.sellArr insertObject:sellModel atIndex:0];

        }
    }
    
    [self.tableview reloadData];
}

-(NSMutableArray *)buyArr{
    if(!_buyArr){
        _buyArr = [NSMutableArray new];
    
    }
    
    
    
    return _buyArr;
}

-(NSMutableArray *)sellArr{
    if(!_sellArr){
        _sellArr = [NSMutableArray new];
        
    }
    
    return _sellArr;
}

-(void)setPriceLimit:(NSInteger)priceLimit{
    _priceLimit = priceLimit;
    
    for (UnsettledGearModel * buyModel in self.buyArr) {
        buyModel.limitNumber = priceLimit;
    }
    
    for (UnsettledGearModel * sellModel in self.sellArr) {
        sellModel.limitNumber = priceLimit;
    }
    
    [self.tableview reloadData];
}

- (MGCoinDealTradeHeader *)header{
    
    if (!_header) {
        _header = [MGCoinDealTradeHeader new];
    }
    return _header;
}

@end













