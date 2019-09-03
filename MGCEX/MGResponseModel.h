//
//  MGResponseModel.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/28.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGResponseModel : NSObject

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) id data;

@property (nonatomic, assign) NSInteger code;

@end
