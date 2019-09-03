//
//  MGTraderVerificationCellVM.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseViewModel.h"

@interface MGTraderVerificationCellVM : BaseViewModel

// 背景图
@property (nonatomic, strong) UIImage *bgImage;

// 图标
@property (nonatomic, strong) UIImage *iconImage;

// 标题
@property (nonatomic, strong) NSString *titleText;

// 子标题1
@property (nonatomic, strong) NSString *subTitle1Text;

// 子标题2
@property (nonatomic, strong) NSString *subTitle2Text;



- (id)initWithBgImage:(UIImage *)bgImage
            iconImage:(UIImage *)iconImage
            titleText:(NSString *)titleText
        subTitle1Text:(NSString *)subTitle1Text
        subTitle2Text:(NSString *)subTitle2Txet;

@end
