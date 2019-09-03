// MGC
//
// BaseTableViewController.m
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UIScrollViewDelegate>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableViewUI];
}
#pragma mark- setUpUI
-(void)setUpTableViewUI{
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    //分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kLineColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str = @"testCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

#pragma mark - 下拉刷新
- (void)dropDownToRefreshData:(void(^)(void))RefreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(RefreshingBlock){
            //这里做请求数据操作
            RefreshingBlock();
        }
    }];
    
    // 设置自动切换透明度
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置header
    self.tableView.mj_header = header;
}

#pragma mark - 上拉加载更多
- (void)pullUpToLoadData:(void(^)(void))RefreshingBlock
{
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(RefreshingBlock){
            //这里做请求数据操作
            RefreshingBlock();
        }
    }];
    self.tableView.mj_footer = footer;
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
    if(self.tableView.mj_footer){
        if(hasMoreData){
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
}


@end
