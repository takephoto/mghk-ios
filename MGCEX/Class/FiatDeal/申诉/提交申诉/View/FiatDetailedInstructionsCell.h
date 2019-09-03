// MGC
//
// FiatDetailedInstructionsCell.h
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "TWTextView.h"
@interface FiatDetailedInstructionsCell : BaseTableViewCell
@property (nonatomic, strong) TWTextView *textView;
///是否查看申诉记录
@property (nonatomic, assign) BOOL isRecord;

- (void)needTextViewBorder:(BOOL) isNeed;
@end
