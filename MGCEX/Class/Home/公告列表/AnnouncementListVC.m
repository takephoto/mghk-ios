// MGC
//
// AnnouncementListVC.m
// MGCEX
//
// Created by MGC on 2018/7/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AnnouncementListVC.h"
#import "AnnouncementListCell.h"
#import "HomeIndexVM.h"
#import "AnnouncementDetailVC.h"

@interface AnnouncementListVC ()
@property (nonatomic, strong) HomeIndexVM * homeIndexVM;
@property (nonatomic, strong) NSMutableArray * anMentArray;
@end

@implementation AnnouncementListVC

#pragma mark -- 获取公告列表
-(void)getAnnouncementList{
    
    self.homeIndexVM.num = @"";
    self.homeIndexVM.h5 = @"app";
    @weakify(self);
    [self.homeIndexVM.getAnmentSignal subscribeNext:^(NSMutableArray *arr) {
        @strongify(self);
        self.anMentArray = arr;
        [self.tableView reloadData];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"公告");
    self.tableView.backgroundColor = kBackGroundColor;
    [self.tableView registerClass:[AnnouncementListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getAnnouncementList];
    
    @weakify(self);
    [self dropDownToRefreshData:^{
        @strongify(self);
        [self getAnnouncementList];
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.anMentArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncementListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    HomeIndexModel * model = self.anMentArray[indexPath.section];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adapted(6);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(6))];
    headView.backgroundColor = kBackGroundColor;
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeIndexModel * model = self.anMentArray[indexPath.section];
    AnnouncementDetailVC * vc = [[AnnouncementDetailVC alloc]init];
    vc.urlStr = model.url;
    [self.navigationController pushViewController:vc animated:YES];

}


-(HomeIndexVM *)homeIndexVM{
    if(!_homeIndexVM){
        _homeIndexVM = [[HomeIndexVM alloc]init];
    }
    return _homeIndexVM;
}

-(NSMutableArray *)anMentArray{
    if(!_anMentArray){
        _anMentArray = [NSMutableArray new];
    }
    return _anMentArray;
}
@end
