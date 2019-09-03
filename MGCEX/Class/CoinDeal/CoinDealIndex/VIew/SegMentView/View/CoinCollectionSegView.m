// MGC
//
// CoinCollectionSegView.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinCollectionSegView.h"
#import "CoinDowdCollectionCell.h"

@interface CoinCollectionSegView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation CoinCollectionSegView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kLineColor;
        [self setUpSliderViews];
    }
    return self;
}


-(void)setUpSliderViews{

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumInteritemSpacing = Adapted(16);
    self.flowLayout.minimumLineSpacing = Adapted(16);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [self addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
        
    }];
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator =  NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = white_color;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    [self.collectionView registerClass:[CoinDowdCollectionCell class] forCellWithReuseIdentifier:@"cell"];

    
}

#pragma mark -UICollectionViewDataSource

//collectionView每个段有多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回cell.cell复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //复用
    CoinDowdCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Adapted(70), Adapted(50));
}

//选中了一个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    for (CoinDealMarkModel * model in self.dataArray) {
        model.isSelect = NO;
    }
    CoinDealMarkModel * model = self.dataArray[indexPath.row];
    model.isSelect = YES;
    [self.collectionView reloadData];
    
    if(self.itemBlock){
        self.itemBlock(indexPath.row);
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
@end
