//
//  MGKLinechartCoinInfoFillModel.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CoinInfoFillCellType) {
    CoinInfoFillImageCellType, // 图片
    CoinInfoFillTitleCellType, // 标题
    CoinInfoFillSubTitleCellType, // 子标题
    CoinInfoFillBigTitleCellType //大标题
};

@interface MGKLinechartCoinInfoFillModel : NSObject

// 左边标题
@property (nonatomic, strong) NSString *title;

// 右边内容
@property (nonatomic, strong) NSString *content;

// 下边子标题内容
@property (nonatomic, strong) NSString *subTitle;

// 图片URL
@property (nonatomic, strong) NSString *imageUrlStr;

// cell样式
@property (nonatomic, assign) CoinInfoFillCellType cellType;


- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                     subTitle:(NSString *)subTitle
                  imageUrlStr:(NSString *)imageUrlStr
                     cellType:(CoinInfoFillCellType)cellType;

@end
