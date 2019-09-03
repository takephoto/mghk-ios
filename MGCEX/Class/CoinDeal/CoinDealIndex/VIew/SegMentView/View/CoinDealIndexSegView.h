// MGC
//
// CoinDealIndexSegView.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CoinCollectionSegView.h"
#import "CoinDealMarkModel.h"

@class CoinDealIndexSegView;
@protocol CoindidSelectItemDelegate // 代理传值方法

/**
 * 代理传值
 */
- (void)sendItemValue:(NSInteger )section row:(NSInteger )row  isEmpty:(BOOL)isEmpty;


@end


@interface CoinDealIndexSegView : UIView


@property (nonatomic, weak) NSObject<CoindidSelectItemDelegate>*  selectDelegate;

/**
 * 下拉tableView
 *@param rect 父视图参照物
 *@param selectSection 默认选中section
 *@param selectRow 默认选中row
 *@param dataArray 数据源
 *@param max cell最大数量，如果小于这个数，就展示多少，大于这个数，就展示max
 */
-(instancetype)initWithRect:(CGRect)rect maxCell:(NSInteger )max selectSection:(NSInteger )selectSection selectRow:(NSInteger )selectRow dataArray:(NSMutableArray *)array;

- (void)show;

-(void)hidden;

@end
