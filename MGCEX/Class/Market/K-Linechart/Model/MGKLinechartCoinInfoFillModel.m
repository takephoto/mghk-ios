//
//  MGKLinechartCoinInfoFillModel.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGKLinechartCoinInfoFillModel.h"

@implementation MGKLinechartCoinInfoFillModel

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                     subTitle:(NSString *)subTitle
                  imageUrlStr:(NSString *)imageUrlStr
                     cellType:(CoinInfoFillCellType)cellType
{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.subTitle = subTitle;
        self.imageUrlStr = imageUrlStr;
        self.cellType = cellType;
    }
    return self;
}

@end
