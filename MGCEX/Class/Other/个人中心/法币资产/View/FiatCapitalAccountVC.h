// MGC
//
// FiatCapitalAccountVC.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewController.h"
#import "BaseTableViewGroup.h"
#import "FiatCapitalAccountHeadView.h"
#import "FiatAccountSectionHeadView.h"

@interface FiatCapitalAccountVC : BaseTableViewController
@property (nonatomic, strong) FiatCapitalAccountHeadView * headView;
@property (nonatomic, strong) FiatAccountSectionHeadView * sectionOneView;
@end
