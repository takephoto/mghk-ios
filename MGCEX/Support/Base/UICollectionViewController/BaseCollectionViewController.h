// MGC
//
// BaseCollectionViewController.h
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseViewController.h"

@interface BaseCollectionViewController : TWBaseViewController
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;//cell相关data
@property (nonatomic, assign) BOOL hasMoreData;//改变上拉加载更多数据状态

//下拉刷新
- (void)dropDownToRefreshData:(void(^)(void))RefreshingBlock;

//上拉加载更多
- (void)pullUpToLoadData:(void(^)(void))RefreshingBlock;
@end
