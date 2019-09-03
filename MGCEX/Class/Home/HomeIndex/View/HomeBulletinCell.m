// MGC
//
// HomeBulletinCell.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HomeBulletinCell.h"

@interface HomeBulletinCell()

@end

@implementation HomeBulletinCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    CGFloat screenWidth = Adapted(265);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(Adapted(16));
        make.centerY.mas_offset(0);
    }];
    imageView.image = IMAGE(@"home_notification");
    
    if(!_upwardSingleMarqueeViewData){
        self.upwardSingleMarqueeViewData = [NSMutableArray new];
    }
    self.upwardSingleMarqueeView.delegate = self;
    self.upwardSingleMarqueeView.touchEnabled = YES;
    self.upwardSingleMarqueeView.timeIntervalPerScroll = 5.0f;
    self.upwardSingleMarqueeView.timeDurationPerScroll = 0.5f;
    self.upwardSingleMarqueeView.backgroundColor = [UIColor clearColor];
    [self.upwardSingleMarqueeView reloadData];
    
    QSButton * moreBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
    moreBtn.style = QSButtonImageStyleRight;
    moreBtn.space = Adapted(4);
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-5));
        make.width.mas_equalTo(Adapted(49));
        make.height.mas_equalTo(Adapted(48));
    }];
    moreBtn.titleLabel.font = H13;
    [moreBtn setImage:IMAGE(@"jiantou-heng") forState:UIControlStateNormal];
    
}

#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return _upwardSingleMarqueeViewData ? _upwardSingleMarqueeViewData.count : 0;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    if (marqueeView == _upwardSingleMarqueeView) {
        
        itemView.backgroundColor = [UIColor clearColor];
        
        UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
        content.font = H13;
        content.tag = 1001;
        content.textColor = kTextColor;
        content.backgroundColor = [UIColor clearColor];
        [itemView addSubview:content];
    }
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    if (marqueeView == _upwardSingleMarqueeView &&self.upwardSingleMarqueeViewData.count>0) {
        UILabel *content = [itemView viewWithTag:1001];
        HomeIndexModel * model = _upwardSingleMarqueeViewData[index];
        content.text = model.title;
        
    }
}


- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {

    if(self.bulletinBlock&&_upwardSingleMarqueeViewData.count>0){
        HomeIndexModel * model = self.upwardSingleMarqueeViewData[index];
        self.bulletinBlock(model);
    }
}

-(UUMarqueeView *)upwardSingleMarqueeView{
    if(!_upwardSingleMarqueeView){
        _upwardSingleMarqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(Adapted(40), 0, Adapted(280), Adapted(48)) direction:UUMarqueeViewDirectionUpward];
        [self.contentView addSubview:_upwardSingleMarqueeView];
    }
    
    return _upwardSingleMarqueeView;
}

#pragma mark-- setData
-(void)setUpwardSingleMarqueeViewData:(NSArray *)upwardSingleMarqueeViewData{
    _upwardSingleMarqueeViewData = upwardSingleMarqueeViewData;

    [_upwardSingleMarqueeView reloadData];
}




@end
