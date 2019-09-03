// MGC
//
// MGSystemMaintenanceView.m
// MGCEX
//
// Created by MGC on 2018/7/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "MGSystemMaintenanceView.h"
#import "AppDelegate.h"

@interface MGSystemMaintenanceView()

@property (nonatomic, strong) UIImageView * sysImageV;
@end

@implementation MGSystemMaintenanceView

singletonImplementation(MGSystemMaintenanceView);

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        
        UIImageView * sysImageV = [[UIImageView alloc]init];
        [self addSubview:sysImageV];
        sysImageV.image = IMAGE(@"p_whz");
        [sysImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(Adapted(162));
            make.height.mas_equalTo(Adapted(180));
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(Adapted(110));
        }];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        titleLabel.text = kLocalizedString(@"抱歉，系统正在维护中...");
        titleLabel.textColor = k99999Color;
        titleLabel.numberOfLines = 0;
        titleLabel.font = H15;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(sysImageV.mas_bottom).offset(Adapted(26));
        }];
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:nextBtn];
        [nextBtn setTitle:kLocalizedString(@"我知道了") forState:UIControlStateNormal];
        [nextBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        nextBtn.titleLabel.font = H15;
        nextBtn.backgroundColor = kRedColor;
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(54));
            make.width.mas_equalTo(Adapted(112));
            make.height.mas_equalTo(Adapted(36));
        }];
        @weakify(self);
        [nextBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            
            UIWindow *window = app.window;
            
            [UIView animateWithDuration:0.5f animations:^{
                
                window.alpha = 0;
                
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
                
            } completion:^(BOOL finished) {
                
                exit(0);
                
            }];
        
        }];
        
    }
    return self;
}




-(void)show
{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    
}

-(void)hidden{

    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [[MGSystemMaintenanceView sharedMGSystemMaintenanceView] removeFromSuperview];
        }
    }];
}

@end
