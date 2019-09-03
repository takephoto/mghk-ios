//
//  PlaceOrderItemModel.h
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceOrderItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL enable;
@end
