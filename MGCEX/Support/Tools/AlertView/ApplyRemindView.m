// MGC
//
// ApplyRemindView.m
// MGCEX
//
// Created by MGC on 2018/6/3.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ApplyRemindView.h"

@interface ApplyRemindView()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView * toView;
@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation ApplyRemindView

-(instancetype)initWithSupView:(UIView *)toView timeout:(NSInteger)timeout sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock{
    
    self=[super init];
    if (self) {
        
        self.timeout = timeout;
        self.frame = [UIScreen mainScreen].bounds;
        self.toView = toView;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(Adapted(-64));
            make.width.mas_equalTo(Adapted(308));
            make.height.mas_equalTo(Adapted(270));
        }];
        
        UIView * headView = [[UIView alloc]init];
        [self.alertView addSubview:headView];
        headView.backgroundColor = UIColorFromRGB(0xf3efef);
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.alertView);
            make.height.mas_equalTo(Adapted(44));
        }];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kTextColor;
        titleLabel.font = H15;
        titleLabel.text = kLocalizedString(@"申诉提醒");
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
        
        //公司名称
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        msgLabel.textColor = k99999Color;
        msgLabel.text = kLocalizedString(@"交易剩余时间");
        msgLabel.font = H15;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(21));
            make.right.mas_equalTo(Adapted(-12));
            
        }];
        
        
        
        //时间----
        UILabel * timeLabel = [[UILabel alloc]init];
        [self.alertView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        timeLabel.textColor = kRedColor;
        timeLabel.font = H30;
        timeLabel.text = @"";
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(Adapted(26));
            make.right.mas_equalTo(Adapted(-12));
        }];
        
        
        UILabel * bottomLabel = [[UILabel alloc]init];
        [self.alertView addSubview:bottomLabel];
        bottomLabel.textColor = kTextColor;
        bottomLabel.font = H15;
        bottomLabel.text = kLocalizedString(@"需在交易时限结束后才可进行申诉");
        bottomLabel.numberOfLines = 0;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(Adapted(24));
            make.right.mas_equalTo(Adapted(-12));
        }];
        
      
        //下划线
        UIView * line2 = [[UIView alloc]init];
        [self.alertView addSubview:line2];
        line2.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(bottomLabel.mas_bottom).offset(Adapted(21));
            make.height.mas_equalTo(1);
        }];
        
        
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:nextBtn];
        [nextBtn setTitle:kLocalizedString(@"知道了") forState:UIControlStateNormal];
        [nextBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        nextBtn.titleLabel.font = H15;
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line2.mas_bottom).offset(Adapted(13));
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(Adapted(40));
        }];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.sure_block = sureBlock;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeoutClick) userInfo:nil repeats:YES];
       
        [self.timer setFireDate:[NSDate distantPast]];
        
    }
    return self;
}

-(void)timeoutClick{
    
    self.timeout --;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_timeout/60,_timeout%60];
    if(self.timeout == 0){
        [self hidden];
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}

-(void)nextBtnClick{

    
    if(self.sure_block){
        [self hidden];
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
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
