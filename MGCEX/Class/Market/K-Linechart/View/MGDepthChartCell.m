//
//  MGDepthChartCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGDepthChartCell.h"
#import "DepthChartModel.h"
#import "YYModel.h"
#import "TWDeepnessChart.h"
#import "Masonry.h"
@implementation MGDepthChartCell

-(void)setUpViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _depthChartView = [TWDeepnessChart new];
    _depthChartView.backgroundColor = kBackAssistColor;
    self.backgroundColor = kBackAssistColor;
    [self.contentView addSubview:_depthChartView];
    [_depthChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(200));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_depthChartView layoutIfNeeded];
    
    NSMutableArray * dataArray = [NSMutableArray new];
    [dataArray addObjectsFromArray:self.buyAray];
    [dataArray addObjectsFromArray:self.sellArray];
    
    _depthChartView.leftMargin = 15;
    _depthChartView.rightMargin = 15;
    _depthChartView.bottomPriceColor = [UIColor redColor];
    _depthChartView.volumeColor = [UIColor whiteColor];
    _depthChartView.buyLineColor = kGreenColor;
    _depthChartView.sellLineColor = kRedColor;
    _depthChartView.fillBuyColor = UIColorFromRGB(0xff31423b);
    _depthChartView.fillSellColor =  UIColorFromRGB(0xff413437);
    _depthChartView.timesCount = dataArray.count;
    _depthChartView.dataArray = dataArray.mutableCopy;
    _depthChartView.buyArray = _buyAray.mutableCopy;
    //卖要反序排列
    _depthChartView.sellArray = _sellArray.mutableCopy;
    [_depthChartView stockFill];
    
    for (DepthChartModel * model in self.sellArray) {
        NSLog(@"%f,%f,%f",model.totalNumber,model.number,model.price);
    }
}
-(id)mg_jsonObjWithPathForResourceAndType:(NSString *)resource type:(NSString *)type{
    
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        
        return nil;
    }
    NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error){
        
        
    }
    return jsonObj;
}

#pragma mark - LazyLoad
- (NSMutableArray *)buyAray{
    
    if (!_buyAray) {
        
        _buyAray = [NSMutableArray new];
        
        NSDictionary *dic =[self mg_jsonObjWithPathForResourceAndType:@"data" type:@"json"];
        
        NSArray * bidsArr = dic[@"bids"];
        
        //计算成交量
        double totalNumber = 0.0;
        for(NSArray * subArr in bidsArr){
            totalNumber += [subArr[1] doubleValue];
            
            [self.buyTotalNumber addObject:[NSNumber numberWithFloat:totalNumber]];
        }
        
        
        //反序计算价格
        bidsArr=(NSMutableArray *)[[bidsArr reverseObjectEnumerator] allObjects];
        for (NSArray * subArr in bidsArr) {
            DepthChartModel * model = [DepthChartModel new];
            model.price = [subArr[0] doubleValue];
            model.number = [subArr[1] doubleValue];
            
            [_buyAray addObject:model];
        }
        
        
        
        //整合(成交量反序)
        self.buyTotalNumber=(NSMutableArray *)[[self.buyTotalNumber reverseObjectEnumerator] allObjects];
        for (int i=0;i<_buyTotalNumber.count;i++) {
            
            DepthChartModel * model = _buyAray[i];
            model.totalNumber = [_buyTotalNumber[i] doubleValue];
        }
        
    }
    return _buyAray;
}

-(NSMutableArray *)sellArray{
    if(!_sellArray){
        _sellArray = [NSMutableArray new];
        
        NSDictionary *dic =[self mg_jsonObjWithPathForResourceAndType:@"data" type:@"json"];
        
        NSArray * asksArr = dic[@"asks"];
        
        double totalValue = 0.0;
        for (NSArray * subArr in asksArr) {
            DepthChartModel * model = [DepthChartModel new];
            model.price = [subArr[0] doubleValue];
            model.number = [subArr[1] doubleValue];
            
            totalValue += [subArr[1] doubleValue];
            model.totalNumber = totalValue;
            [_sellArray addObject:model];
        }
        
    }
    return _sellArray;
}

-(NSMutableArray *)buyTotalNumber{
    if(!_buyTotalNumber){
        _buyTotalNumber = [NSMutableArray new];
    }
    return _buyTotalNumber;
}

-(NSMutableArray *)sellTotalNumber{
    if(!_sellTotalNumber){
        _sellTotalNumber = [NSMutableArray new];
    }
    return _sellTotalNumber;
}
@end
