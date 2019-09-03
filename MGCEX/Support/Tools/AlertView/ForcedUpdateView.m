// MGC
//
// ForcedUpdateView.m
// MGCEX
//
// Created by MGC on 2018/6/13.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ForcedUpdateView.h"
@interface ForcedUpdateView()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView * toView;
@end

@implementation ForcedUpdateView

-(instancetype)initWithMessage:(NSString *)message isUpDate:(NSString *)isUpDate sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock{
    
    self=[super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        self.toView = [UIApplication sharedApplication].keyWindow;

        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(Adapted(300));
            make.height.mas_equalTo(Adapted(200));
        }];

        UIView * headView = [[UIView alloc]init];
        [self.alertView addSubview:headView];
        headView.backgroundColor = UIColorFromRGB(0xf3efef);
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.alertView);
            make.height.mas_equalTo(Adapted(44));
        }];
        
        UIButton * cancelBtn = [UIButton buttonWithType:0];
        [headView addSubview:cancelBtn];
        [cancelBtn setImage:IMAGE(@"guanbi") forState:UIControlStateNormal];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView);
            make.width.height.mas_equalTo(Adapted(40));
            make.centerY.mas_equalTo(headView);
        }];
        cancelBtn.hidden = YES;
        @weakify(self);
        [cancelBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(cancelBlock){
                cancelBlock();
            }
            [self hidden];
        }];
        
        if([isUpDate integerValue] == 1){
            cancelBtn.hidden = YES;
        }else{
            cancelBtn.hidden = NO;
        }
        

        UILabel * titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kBackAssistColor;
        titleLabel.font = H15;
        titleLabel.text = kLocalizedString(@"检查更新");
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(40));
            make.right.mas_equalTo(Adapted(-40));
            make.centerY.mas_equalTo(headView);
        }];
        
        UILabel * msgTitle = [[UILabel alloc]init];
        [self.alertView addSubview:msgTitle];
        msgTitle.textColor = kBackAssistColor;
        msgTitle.text = message;
        msgTitle.numberOfLines = 0;
        msgTitle.font = H15;
        msgTitle.text = kLocalizedString(@"更新内容:");
        [msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            
        }];
 
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        msgLabel.textColor = kBackAssistColor;
        msgLabel.text = message;
        msgLabel.numberOfLines = 0;
        msgLabel.font = H15;
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(msgTitle.mas_bottom).offset(Adapted(5));
            make.right.mas_equalTo(Adapted(-15));
            
        }];
        
        float height = [UIView getLabelHeightByWidth:Adapted(270) Title:msgLabel.text font:H15];
        
        
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height+Adapted(150));
        }];
        
        UIView  *lineView = [[UIView alloc]init];
        [self.alertView addSubview:lineView];
        lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.alertView);
            make.right.mas_equalTo(self.alertView);
            make.bottom.mas_equalTo(self.alertView.mas_bottom).offset(Adapted(-44));
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.alertView);
            make.top.mas_equalTo(lineView.mas_bottom);
     
        }];
        [nextBtn setTitle:kLocalizedString(@"立即更新") forState:UIControlStateNormal];
        [nextBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        nextBtn.titleLabel.font = H15;
        self.nextBtn = nextBtn;

        self.sure_block = sureBlock;
        [nextBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(sureBlock){
                self.sure_block();
                //不是强制更新，隐藏弹框
                if([isUpDate integerValue] == 0){
                    [self hidden];
                }
            }
     
        }];
        
        
        
        
    }
    
    return self;
    
}


- (void)show{
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
