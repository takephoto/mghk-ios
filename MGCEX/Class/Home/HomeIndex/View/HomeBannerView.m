// MGC
//
// HomeBannerView.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HomeBannerView.h"


@interface HomeBannerView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * urlArray;
@end

@implementation HomeBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    [self addSubview:self.cycleScrollView];
    //self.cycleScrollView.localizationImageNamesGroup = @[@"APP_banner_a",@"APP_banner_b",@"APP_banner_c",@"APP_banner_d"];
    self.cycleScrollView.localizationImageNamesGroup = @[@"app-e",@"app-a",@"app-b",@"app-c",@"app-d",@"app-e",@"app-f"];
//    NSString *ipstr = @"http://www.MEIB.IO";
//    self.cycleScrollView.imageURLStringsGroup = @[string(ipstr, @"/home/img/APP_banner_a.png"),string(ipstr, @"/home/img/APP_banner_b.png"),string(ipstr, @"/home/img/APP_banner_c.png"),string(ipstr, @"/home/img/APP_banner_d.png")];
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if(self.picBlock){
        self.picBlock(_urlArray[index],index);
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

-(void)setPicArr:(NSMutableArray *)picArr{
    
    _picArr = picArr;
    _cycleScrollView.imageURLStringsGroup = self.dataArray;
    
}


#pragma 懒加载
-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)urlArray{
    
    if(!_urlArray){
        _urlArray = [NSMutableArray new];
    }
    return _urlArray;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height) delegate:self placeholderImage:nil];
        
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.currentPageDotColor = white_color;
        _cycleScrollView.pageDotColor = kAssistColor;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _cycleScrollView;
}
@end
