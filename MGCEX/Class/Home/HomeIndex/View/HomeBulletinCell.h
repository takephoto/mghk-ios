// MGC
//
// HomeBulletinCell.h
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "UUMarqueeView.h"
#import "HomeIndexModel.h"

typedef void (^BulletinBlock)(HomeIndexModel * model);

/**
 @brief 首页公告cell
 */
@interface HomeBulletinCell : BaseTableViewCell<UUMarqueeViewDelegate>
/// 查看详情 rac事件vc绑定
@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) UUMarqueeView *upwardSingleMarqueeView;

@property (nonatomic, strong) NSArray *upwardSingleMarqueeViewData;
@property (nonatomic, copy) BulletinBlock  bulletinBlock;
@end
