// MGC
//
// CustomSegmentedView.h
// MGCPay
//
// Created by MGC on 2018/3/20.
// Copyright © 2018年 Joblee. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>

typedef void (^SegmentBlock)(NSInteger index ,UILabel * label);

@interface CustomSegmentedView : UIView
@property (nonatomic, copy) SegmentBlock segmentCallBlock;

@property (nonatomic, strong) UIColor * segmentColor;

@property (nonatomic, strong) UILabel * segLabel1;

@property (nonatomic, strong) UILabel * segLabel2;

@property (nonatomic, strong) UILabel * segLabel3;

@property (nonatomic, strong) UILabel * segLabel4;

@property (nonatomic, strong) UIView * slidView;

@property (nonatomic, strong) UIView * backView;

-(instancetype)initWithSegmentArr:(NSArray *)array frame:(CGRect)frame;
-(void)updateWithSegmentArr:(NSArray *)array frame:(CGRect)frame;
///手动切换到选中的item
-(void)changeToIndex:(NSInteger)index;
@property (nonatomic, strong) UIColor *selectTextColor;
@end
