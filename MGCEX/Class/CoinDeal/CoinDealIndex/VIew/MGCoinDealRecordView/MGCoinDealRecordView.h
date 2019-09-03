//
//  MGCoinDealRecordView.h
//  TestDemo
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKlineDealRecordCell.h"

@class MGCoinDealTradeHeader;
@interface MGCoinDealRecordView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) MGCoinDealTradeHeader *header;
@property (nonatomic, strong) NSMutableDictionary * mutabDic;
@property (nonatomic, assign) BOOL isDisable;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *numberBgLab;
@property (nonatomic, assign) NSInteger priceLimit;
@end
