// MGC
//
// BaseCollectionViewController.m
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}

-(void)setUpViews{
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [self.view addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 100, 0));
    }];
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator =  NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - 下拉刷新
- (void)dropDownToRefreshData:(void(^)(void))RefreshingBlock;
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(RefreshingBlock){
            RefreshingBlock();
        }
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.collectionView.mj_header = header;
}

#pragma mark - 上拉加载更多
- (void)pullUpToLoadData:(void(^)(void))RefreshingBlock;
{
    MJRefreshBackFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(RefreshingBlock){
            RefreshingBlock();
        }
    }];
    self.collectionView.mj_footer = footer;
}

#pragma mark -- set get
-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(void)setHasMoreData:(BOOL)hasMoreData{
    _hasMoreData = hasMoreData;
    if(self.collectionView.mj_footer){
        if(hasMoreData){
            [self.collectionView.mj_footer endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
}
@end
