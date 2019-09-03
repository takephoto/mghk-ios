// MGC
//
// DownTableViewCell.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "downTableModel.h"

@interface DownTableViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger cellStyle;
@property (nonatomic, strong) downTableModel * model;

@end
