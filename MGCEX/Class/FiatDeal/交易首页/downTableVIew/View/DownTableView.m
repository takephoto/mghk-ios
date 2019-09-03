// MGC
//
// DownTableView.m
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "DownTableView.h"
#import "DownTableViewCell.h"

@interface DownTableView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGRect toRect;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float tabHeight;
@property (nonatomic, assign) NSInteger didSelect;
@end

@implementation DownTableView


-(instancetype)initWithRect:(CGRect)rect dataArray:(NSArray <downTableModel * >*)dataArray type:(NSInteger )type maxCell:(NSInteger )max didSelect:(NSInteger )didSelect{

    self = [super init];
    if(self){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        
        UIView * bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8f];
        [self addSubview:bottomView];
        [bottomView setFrame:CGRectMake(0, rect.origin.y+ rect.size.height, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - rect.origin.y -rect.size.height )];
        
        self.toRect = rect;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        self.type = type;
        self.max = max;
        self.didSelect = didSelect;
        _cellHeight = Adapted(44);
        [self setUpViews];
     
    }
    
    return self;
}

-(void)setUpViews{

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.tabHeight = _dataArray.count * _cellHeight;
    
    if(_max && _dataArray.count>_max){
        self.tabHeight = _max * _cellHeight;
    }
    
    UITableView * tableView = [[UITableView alloc]init];
    [self addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_toRect.origin.y+_toRect.size.height);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(self.tabHeight);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = _cellHeight;
    self.tableView.backgroundColor = kNavTintColor;
    //分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kLineColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,Adapted(15), 0, Adapted(15));
   
    [self.tableView registerClass:[DownTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DownTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    downTableModel * model = _dataArray[indexPath.row];
    cell.cellStyle = self.type;
    cell.model = model;
    
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
   
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (downTableModel * obj in _dataArray) {
        obj.selected = NO;
    }
    
    downTableModel * model = _dataArray[indexPath.row];
    model.selected = YES;
    
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    [self.tableView reloadData];
    
   
    if([self.selectDelegate respondsToSelector:@selector(sendItemValue:dataArray:disSelect:isEmpty:)]){
        [self.selectDelegate sendItemValue:indexPath.row dataArray:self.dataArray disSelect:self.didSelect isEmpty:NO];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidden];
    });
    
}


-(void)show
{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y + self.toRect.size.height, MAIN_SCREEN_WIDTH, 0)];
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.alpha = 1;
        [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y+ self.toRect.size.height, MAIN_SCREEN_WIDTH, self.tabHeight)];
    }];
    
}

-(void)hidden{

    [UIView animateWithDuration:.2 animations:^{
        [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y+ self.toRect.size.height, MAIN_SCREEN_WIDTH, 0)];
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
 
        [self removeFromSuperview];
        
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
 
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else {
        return YES;
    }
}

-(void)tapSelf{
    
    if([self.selectDelegate respondsToSelector:@selector(sendItemValue:dataArray:disSelect:isEmpty:)]){
        [self.selectDelegate sendItemValue:0 dataArray:nil disSelect:self.didSelect isEmpty:YES];
    }
    
    [self hidden];
}

//-(void)setDataArray:(NSMutableArray *)dataArray{
//    _dataArray = dataArray;
//    [self.tableView reloadData];
//}
@end
