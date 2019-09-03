// MGC
//
// BaseTableViewGroup.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseViewController.h"

@interface BaseTableViewGroup : TWBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;//cell相关data
@property (nonatomic, assign) BOOL hasMoreData;//改变上拉加载更多数据状态

//下拉刷新
- (void)dropDownToRefreshData:(void(^)(void))RefreshingBlock;

//上拉加载更多
- (void)pullUpToLoadData:(void(^)(void))RefreshingBlock;

@end
