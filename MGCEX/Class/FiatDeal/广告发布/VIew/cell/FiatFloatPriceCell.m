//
//  FiatFloatPriceCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/20.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "FiatFloatPriceCell.h"
@interface FiatFloatPriceCell()
//文案标签
@property (nonatomic, strong) UILabel * titleLabel;
@end
@implementation FiatFloatPriceCell

-(void)setUpViews
{
    self.backgroundColor = white_color;
    UIButton * logImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:logImageBtn];
    [self.contentView bringSubviewToFront:logImageBtn];
    [logImageBtn mg_setEnlargeEdgeWithTop:Adapted(20) right:Adapted(100) bottom:Adapted(100) left:Adapted(20)];
    [logImageBtn setImage:IMAGE(@"icon_choice_off") forState:UIControlStateNormal];
    [logImageBtn setImage:IMAGE(@"icon_choice_on") forState:UIControlStateSelected];
    [logImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.width.height.mas_equalTo(Adapted(20));
        make.bottom.mas_equalTo(Adapted(-13));
    }];
    [logImageBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.logImageBtn = logImageBtn;
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = H15;
    self.titleLabel.textColor = kTextColor;
    self.titleLabel.text = kLocalizedString(@"按市价浮动比例");
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logImageBtn.mas_right).offset(Adapted(10));
        make.width.mas_equalTo((MAIN_SCREEN_WIDTH-Adapted(30))/3.0);
        make.centerY.mas_equalTo(logImageBtn);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(Adapted(0));
    }];
    self.lineView = lineView;
}
-(void)changeStatus:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.selectBlock(btn.selected);
}
@end
