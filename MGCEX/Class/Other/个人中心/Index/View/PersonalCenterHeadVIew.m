// MGC
//
// PersonalCenterHeadVIew.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "PersonalCenterHeadVIew.h"
#import "PersonalAccountCell.h"

@interface PersonalCenterHeadVIew()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@end

@implementation PersonalCenterHeadVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackGroundColor;
        [self setUpHeadViews];
        [self setUpSliderViews];
    }
    return self;
}
//个人头像设置
-(void)setUpHeadViews{
    UIImageView * headImageV = [[UIImageView alloc]init];
    [self addSubview:headImageV];
    headImageV.image = IMAGE(@"personUserIcon");
    headImageV.layer.cornerRadius = Adapted(31);
    headImageV.clipsToBounds = YES;
    [headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(Adapted(22) + kStatusBarHeight);
        make.width.height.mas_equalTo(Adapted(62));
    }];

    UILabel * userName = [[UILabel alloc]init];
    [self addSubview:userName];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.numberOfLines = 1;
    userName.text = @"";
    userName.font = H15;
    userName.textColor = kTextColor;
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageV.mas_bottom).offset(Adapted(13));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(300));

     
    }];
    self.userName = userName;
}


//设置账户金额滑块
-(void)setUpSliderViews{
    UIView * backSliderView = [[UIView alloc]init];
    [self addSubview:backSliderView];
    backSliderView.backgroundColor = white_color;
    [backSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(Adapted(125));
    }];

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.minimumInteritemSpacing = Adapted(10);
    self.flowLayout.minimumLineSpacing = Adapted(10);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [backSliderView addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(Adapted(10), Adapted(10), Adapted(10), Adapted(10)));

    }];
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator =  NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = white_color;
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.collectionView registerClass:[PersonalAccountCell class] forCellWithReuseIdentifier:@"cell"];

}

#pragma mark -UICollectionViewDataSource

//collectionView每个段有多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
//返回cell.cell复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //复用
    PersonalAccountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.accountLabel.text = string(kLocalizedString(@"C2C/B2C账户"), @"(BTC)");
        cell.amountLabel.text = [NSString stringWithFormat:@"%@",kNotNumber([self.FiatbtcCount keepDecimal:8]) ];
        cell.rmbLabel.text = [NSString stringWithFormat:@"≈%@ CNY",kNotNumber([self.FiatcnySum keepDecimal:2])];
        
    }else{
        cell.accountLabel.text = string(kLocalizedString(@"币币账户"), @"(BTC)");
        cell.amountLabel.text = [NSString stringWithFormat:@"%@",kNotNumber([self.CoinbtcCount keepDecimal:8])];
        cell.rmbLabel.text = [NSString stringWithFormat:@"≈%@ CNY",kNotNumber([self.CoincnySum keepDecimal:2])];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((kScreenW - Adapted(10) * 3) / 2.0, Adapted(105));
}

//选中了一个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.itemBlock){
        self.itemBlock(indexPath.row);
    }
}
@end
