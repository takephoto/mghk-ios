// MGC
//
// HomeNestTableViewCell.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HomeNestTableViewCell.h"
#import "ContentTableViewCell.h"
#import "MGKLineChartVC.h"


@interface HomeNestTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * contentTab;
@end
@implementation HomeNestTableViewCell

-(void)bindModel
{
    @weakify(self);
    [RACObserve(self, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        [self.contentTab reloadData];
    }];
}

-(void)setUpViews{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(44))];
    headView.backgroundColor = white_color;
    
    UIButton * riseFallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:riseFallBtn];
    riseFallBtn.titleLabel.font = H15;
    [riseFallBtn setTitle:kLocalizedString(@"涨幅榜") forState:UIControlStateNormal];
    [riseFallBtn setTitleColor:kLineColor forState:UIControlStateNormal];
    [riseFallBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    [riseFallBtn setBackgroundColor:white_color forState:UIControlStateNormal];
    [riseFallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(headView);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0);
    }];
    self.riseFallBtn = riseFallBtn;
    [riseFallBtn addTarget:self action:@selector(riseFallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * dollarsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:dollarsBtn];
    [dollarsBtn setTitle:kLocalizedString(@"新币榜") forState:UIControlStateNormal];
    dollarsBtn.titleLabel.font = H15;
    [dollarsBtn setTitleColor:kLineColor forState:UIControlStateNormal];
    [dollarsBtn setTitleColor:kTextColor forState:UIControlStateSelected];
    [dollarsBtn setBackgroundColor:white_color forState:UIControlStateNormal];
    [dollarsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(headView);
        make.left.mas_equalTo(riseFallBtn.mas_right).offset(Adapted(15));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/4.0);
    }];
    [dollarsBtn addTarget:self action:@selector(dollarsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.dollarsBtn = dollarsBtn;
    
    riseFallBtn.selected = YES;
    dollarsBtn.selected = NO;
    
    //分割线
    UIView *line = [UIView new];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];
    line.backgroundColor = kSLineClolor;
    

    UITableView * contentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(52)*10+headView.height)];
    [self addSubview:contentTab];
    contentTab.delegate = self;
    contentTab.dataSource = self;
    contentTab.scrollEnabled = NO;
    contentTab.backgroundColor = kBackGroundColor;
    contentTab.showsHorizontalScrollIndicator = NO;
    contentTab.showsVerticalScrollIndicator = NO;
    contentTab.tableHeaderView = headView;
    contentTab.tableFooterView = [UIView new];
    //分割线
    contentTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    contentTab.separatorColor = kSLineClolor;
    contentTab.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    
    [contentTab registerClass:[ContentTableViewCell class] forCellReuseIdentifier:@"contentCell"];
    self.contentTab = contentTab;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count > 10?10:self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, MAIN_SCREEN_WIDTH, 0, 0);
    }
    else
    {
        cell.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
    }
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(52);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count>indexPath.row) {
        MGMarketIndexRealTimeModel *model = self.dataSource[indexPath.row];
        MGKLineChartVC *vc = [[MGKLineChartVC alloc]init];
        vc.symbols = model.symbol;
        vc.market = model.market;
        vc.model = model;
        [[TWAppTool currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentTableViewCell *tCell = (ContentTableViewCell *)cell;
    tCell.tagLab.text = s_Integer(indexPath.row + 1);
    if(indexPath.row < 4){
        
        tCell.tagLab.backgroundColor = green_color;
        tCell.tagLab.alpha = 1 - (0.2 * (indexPath.row + 1));
    } else {
        tCell.tagLab.backgroundColor = UIColorFromRGB(0xD1D1D1);
    }
}

#pragma mark-- BtnClick
-(void)riseFallBtnClick:(UIButton *)btn{
    if(btn.selected ==YES)  return;
    btn.selected = !btn.selected;
    self.dollarsBtn.selected = btn.selected ? NO:YES;
}

-(void)dollarsBtnClick:(UIButton *)btn{
    if(btn.selected == YES) return;
    btn.selected = !btn.selected;
    self.riseFallBtn.selected = btn.selected ? NO:YES;
}
@end
