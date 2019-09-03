// MGC
//
// CoinDealIndexSegView.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealIndexSegView.h"
#import "CoinDowdTableViewCell.h"
#import "CoinCollectionSegView.h"


@interface CoinDealIndexSegView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect toRect;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float tabHeight;
@property (nonatomic, assign) float CollectionHeight;
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, assign) NSInteger selectSection;
@property (nonatomic, strong) CoinCollectionSegView * headView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end
@implementation CoinDealIndexSegView

-(instancetype)initWithRect:(CGRect)rect maxCell:(NSInteger )max selectSection:(NSInteger )selectSection selectRow:(NSInteger )selectRow dataArray:(NSMutableArray *)array{
    
    self = [super init];
    if(self){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        
        UIView * bottomView = [[UIView alloc]init];
        bottomView.tag = 101;
        bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8f];
        [self addSubview:bottomView];
        [bottomView setFrame:CGRectMake(0, rect.origin.y+ rect.size.height, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - rect.origin.y -rect.size.height )];

        
        self.toRect = rect;
        self.max = max;
        self.selectRow = selectRow;
        self.selectSection = selectSection;
        self.dataArray = array;
        _cellHeight = Adapted(44);
        _CollectionHeight = Adapted(50);
        
        [self configData];
        [self setUpHeadView];
        [self setUpViews];
        
        
    }
    
    return self;
}

//配置基本数据
-(void)configData{
    
    //消除选中状态
    for (CoinDealMarkModel * model in self.dataArray) {
        model.isSelect = NO;
        
        for (CoinDealPrivateModel * primodel in model.privateArray) {
            primodel.selected = NO;
        }
    }

    //设置选中状态
    CoinDealMarkModel * model = self.dataArray[self.selectSection];
    model.isSelect = YES;
    
    CoinDealPrivateModel * primodel = model.privateArray.count > self.selectRow ?model.privateArray[self.selectRow] : nil;
    primodel.selected = YES;
}

-(void)setUpHeadView{
    
    self.headView = [[CoinCollectionSegView alloc]initWithFrame:CGRectMake(0, self.toRect.origin.y+ self.toRect.size.height, MAIN_SCREEN_WIDTH, _CollectionHeight)];
    self.headView.dataArray = self.dataArray;
    [self addSubview:self.headView];
    
    @weakify(self);
    self.headView.itemBlock = ^(NSInteger index) {
        @strongify(self);
        self.selectSection = index;
        
        CoinDealMarkModel * model = self.dataArray[self.selectSection];
        
        if(_max && model.privateArray.count>_max){
            self.tabHeight = _max * _cellHeight;
        }else{
            self.tabHeight = model.privateArray.count * _cellHeight;
        }
        
        [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y+ self.toRect.size.height+self.CollectionHeight, MAIN_SCREEN_WIDTH, self.tabHeight)];
        
        [self.tableView reloadData];
    };
}



-(void)setUpViews{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CoinDealMarkModel * model = self.dataArray[self.selectSection];

    if(_max && model.privateArray.count>_max){
        self.tabHeight = _max * _cellHeight;
    }else{
        self.tabHeight = model.privateArray.count * _cellHeight;
    }
    
    UITableView * tableView = [[UITableView alloc]init];
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tag =100;
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
    self.tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    
    [self.tableView registerClass:[CoinDowdTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    CoinDealMarkModel * model = self.dataArray[_selectSection];
    return model.privateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CoinDowdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CoinDealMarkModel * model = self.dataArray[_selectSection];
    CoinDealPrivateModel * primodel = model.privateArray[indexPath.row];
    cell.model = primodel;

    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width*2);
        
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectRow = indexPath.row;
    
    CoinDealMarkModel * model = self.dataArray[_selectSection];
    
    NSArray * arr = model.privateArray;
    //消除选中
    for (CoinDealPrivateModel * primodel in arr) {
        primodel.selected = NO;
    }
    //设置选中
    CoinDealPrivateModel * primodel = arr[indexPath.row];
    primodel.selected = YES;
    
    //[_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    [self.tableView reloadData];
    
    
    if([self.selectDelegate respondsToSelector:@selector(sendItemValue:row:isEmpty:)]){
        [self.selectDelegate sendItemValue:self.selectSection row:self.selectRow isEmpty:NO];
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
    
    [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y + self.toRect.size.height + _CollectionHeight - 1, MAIN_SCREEN_WIDTH, 0)];
    
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.alpha = 1;
        [self.tableView setFrame:CGRectMake(0, self.toRect.origin.y+ self.toRect.size.height+self.CollectionHeight, MAIN_SCREEN_WIDTH, self.tabHeight)];
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
   
    if(touch.view.tag == 100||touch.view.tag == 101){
        return YES;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [gestureRecognizer.view class] == [CoinDealIndexSegView class]) {
        return NO;
    }else {
        return YES;
    }
}

-(void)tapSelf{
    
    if([self.selectDelegate respondsToSelector:@selector(sendItemValue:row:isEmpty:)]){
        [self.selectDelegate sendItemValue:self.selectSection row:self.selectRow isEmpty:YES];
    }
    
    [self hidden];
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
