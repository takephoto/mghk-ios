// MGC
//
// HomeOptionalCell.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "HomeOptionalCell.h"
#import "HomeOptionalView.h"
#import "MarketIndexVC.h"

@interface HomeOptionalCell()
@property (nonatomic, strong) UILabel * optionalLabel;
@property (nonatomic, strong) QSButton * moreBtn;
@end

@implementation HomeOptionalCell

#pragma mark -- lifecycles
-(void)setUpViews{
    
    self.backgroundColor = white_color;
    ///tips：已登录显示自选涨幅，可以查看更多；未登录显示推荐涨幅，无更多
    //标题
    UILabel * optionalLabel = [[UILabel alloc]init];
    [self.contentView addSubview:optionalLabel];
    
    optionalLabel.textColor = kTextColor;
    optionalLabel.font = H14;
    [optionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.top.mas_equalTo(Adapted(13));
        make.right.mas_equalTo(Adapted(-80));
    }];
    self.optionalLabel = optionalLabel;
    //更多
    QSButton * moreBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:moreBtn];
    [moreBtn setTitle:kLocalizedString(@"更多") forState:UIControlStateNormal];
    [moreBtn setTitleColor:kLineColor forState:UIControlStateNormal];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(0));
        make.centerY.mas_equalTo(optionalLabel);
        make.width.mas_equalTo(Adapted(80));
        make.height.mas_equalTo(Adapted(40));
    }];
    moreBtn.titleLabel.font = H15;
    [moreBtn setImage:IMAGE(@"jiantou-heng") forState:UIControlStateNormal];
    moreBtn.style = QSButtonImageStyleRight;
    moreBtn.space = Adapted(5);
//    moreBtn.hidden = kUserIsLogin?NO:YES;
    moreBtn.hidden = YES;
    //更多自选涨幅跳转到行情的自选列表
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        [TWAppTool currentViewController].tabBarController.selectedIndex = 1;
        MarketIndexVC *vc = [TWAppTool currentViewController];
        vc.shouldChangeToSelfSelected = YES;
    }];
    self.moreBtn = moreBtn;
    CGFloat space = Adapted(12);
    CGFloat width = (MAIN_SCREEN_WIDTH-space*4)/3.0;
    for(int i=0;i<3;i++){
        HomeOptionalView * cellView = [[HomeOptionalView alloc]initWithFrame:CGRectMake(space+i*(space+ width),Adapted(44), width, Adapted(117))];
        cellView.hidden = YES;
        [self addSubview:cellView];
        cellView.tag = 20+i;
    }
}

#pragma mark -- overrides

/**
 @brief 数据源订阅绑定
 */
-(void)bindModel
{
    @weakify(self);
    [RACObserve(self, dataArray)subscribeNext:^(NSArray *arr) {
        @strongify(self);
        for (int i = 0; i < 3; i++) {
            HomeOptionalView * cellView = [self viewWithTag:20+i];
            cellView.hidden = YES;
        }
        int i = 0;
        for (id data in arr) {
            HomeOptionalView * cellView = [self viewWithTag:20+(i++)];
            cellView.hidden = NO;
            [cellView update:data];
        }
        self.optionalLabel.text = kLocalizedString(@"推荐涨幅");//kUserIsLogin ? kLocalizedString(@"自选涨幅") : kLocalizedString(@"推荐涨幅");
        self.moreBtn.hidden = YES;//kUserIsLogin ? NO : YES;
    }];
}

@end
