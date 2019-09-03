//
//  MGKlineDealRecordCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "MGKLinechartRecordModel.h"
@interface MGKlineDealRecordCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *dealLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) MGKLinechartRecordModel *model;
/**
 满足某种类型的特殊处理
 */
- (void)changeColor;
@end
