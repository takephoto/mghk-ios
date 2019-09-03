// MGC
//
// DownTableView.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
#import "downTableModel.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class DownTableView;
@protocol didSelectItemDelegate // 代理传值方法

/**
 * 代理传值
 *@param index 选中第几行
 *@param dataArray 数据
 *@param didSelect 通过哪个按钮选择的
 */
- (void)sendItemValue:(NSInteger )index dataArray:(NSArray *)dataArray disSelect:(NSInteger )didSelect isEmpty:(BOOL)isEmpty;


@end

@interface DownTableView : BaseView

@property (nonatomic, weak) NSObject<didSelectItemDelegate>*  selectDelegate;

/**
 * 下拉tableView
 *@param rect 父视图参照物
 *@param dataArray 数据模型
 *@param type 0 带图片 1 不带。默认带图片
 *@param didSelect 暂定标识符
 *@param max cell最大数量，如果小于这个数，就展示多少，大于这个数，就展示max
 */
-(instancetype)initWithRect:(CGRect)rect dataArray:(NSArray <downTableModel * >*)dataArray type:(NSInteger )type maxCell:(NSInteger )max didSelect:(NSInteger )didSelect;

- (void)show;

-(void)hidden;
@end
