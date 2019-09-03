// MGC
//
// CancelDealView.m
// MGCEX
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CancelDealView.h"
@interface CancelDealView()

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView * toView;

@end


@implementation CancelDealView
-(instancetype)initWithSupView:(UIView *)toView sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock{
    
    self=[super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.toView = toView;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(Adapted(-64));
            make.width.mas_equalTo(Adapted(302));
            make.height.mas_equalTo(Adapted(235));
        }];
        
        UIView * headView = [[UIView alloc]init];
        [self.alertView addSubview:headView];
        headView.backgroundColor = white_color;
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.alertView);
            make.height.mas_equalTo(Adapted(44));
        }];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kTextColor;
        titleLabel.font = H15;
        titleLabel.text = kLocalizedString(@"取消交易");
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(40));
            make.right.mas_equalTo(Adapted(-40));
            make.centerY.mas_equalTo(headView);
        }];
        
        UIButton * cancelBtn = [UIButton buttonWithType:0];
        [headView addSubview:cancelBtn];
        [cancelBtn setImage:IMAGE(@"guanbi") forState:UIControlStateNormal];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView);
            make.width.height.mas_equalTo(Adapted(40));
            make.centerY.mas_equalTo(headView);
        }];
        @weakify(self);
        [cancelBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(cancelBlock){
                cancelBlock();
            }
            [self hidden];
        }];
        
        UILabel * label1 = [[UILabel alloc]init];
        [self.alertView addSubview:label1];
        label1.numberOfLines = 0;
        label1.textColor = kRedColor;
        label1.font = H15;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = kLocalizedString(@"如果您已付款给卖家,请务必不能取消交易");
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(19));
            make.left.mas_equalTo(Adapted(8));
            make.right.mas_equalTo(Adapted(-8));
        }];
        
        UILabel * label2 = [[UILabel alloc]init];
        [self.alertView addSubview:label2];
        label2.numberOfLines = 0;
        label2.textColor = kTextColor;
        label2.font = H15;
        label2.text = kLocalizedString(@"取消交易说明:");
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label1.mas_bottom).offset(Adapted(12));
            make.left.mas_equalTo(Adapted(8));
            make.right.mas_equalTo(Adapted(-8));
        }];
        
        UILabel * label3 = [[UILabel alloc]init];
        [self.alertView addSubview:label3];
        label3.numberOfLines = 0;
        label3.textColor = kTextColor;
        label3.font = H15;
        label3.text = kLocalizedString(@"所有用户当天（24小时内）累计取消 3 笔交易，当天的买入功能将会被关闭");
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label2.mas_bottom).offset(Adapted(5));
            make.left.mas_equalTo(Adapted(8));
            make.right.mas_equalTo(Adapted(-8));
        }];
        
        
        //下划线
        UIView * line2 = [[UIView alloc]init];
        [self.alertView addSubview:line2];
        line2.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(Adapted(-44));
            make.height.mas_equalTo(1);
        }];
        
        //确认取消
        UIButton * confirmCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:confirmCancelBtn];
        [confirmCancelBtn setTitle:kLocalizedString(@"确认取消") forState:UIControlStateNormal];
        [confirmCancelBtn setTitleColor:kAssistTextColor forState:UIControlStateNormal];
        [confirmCancelBtn setBackgroundColor:UIColorFromRGB(0xe7e7e7) forState:UIControlStateHighlighted];
        confirmCancelBtn.titleLabel.font = H15;
        [confirmCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line2.mas_bottom);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(Adapted(302)/2.0);
        }];
        [confirmCancelBtn addTarget:self action:@selector(confirmCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.sure_block = sureBlock;
        self.cancel_block= cancelBlock;
        
        //我在想想
        UIButton * considerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:considerBtn];
        [considerBtn setTitle:kLocalizedString(@"我再想想") forState:UIControlStateNormal];
        [considerBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        [considerBtn setBackgroundColor:UIColorFromRGB(0xe7e7e7) forState:UIControlStateHighlighted];
        considerBtn.titleLabel.font = H15;
        [considerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line2.mas_bottom);
            make.right.mas_equalTo(self.alertView.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(Adapted(302)/2.0);
        }];
        [considerBtn addTarget:self action:@selector(considerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

//确认取消
-(void)confirmCancelBtnClick{
    if(self.sure_block){
        self.sure_block();
        [self hidden];
    }
}

//再想想
-(void)considerBtnClick{
    if(self.cancel_block){
        self.cancel_block();
        [self hidden];
    }
}


-(void)show
{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    
    [self.toView addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alertView.alpha = 1;
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)hidden{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}
@end
