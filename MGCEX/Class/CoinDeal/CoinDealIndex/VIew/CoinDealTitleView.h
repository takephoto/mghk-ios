//
//  CoinDealTitleView.h
//  MGCEX
//
//  Created by HFW on 2018/7/11.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"

@interface CoinDealTitleView : BaseView
@property (nonatomic, assign) CGSize intrinsicContentSize;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^clickBlock)(BOOL selected);
@property (nonatomic, assign) BOOL selected;
@end
