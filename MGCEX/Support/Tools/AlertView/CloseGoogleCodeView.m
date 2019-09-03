// MGC
//
// CloseGoogleCodeView.m
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CloseGoogleCodeView.h"
@interface CloseGoogleCodeView()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField * enterText;
@property (nonatomic, strong) UITextField * enterText2;
@property (nonatomic, strong) UIView * toView;
@end

@implementation CloseGoogleCodeView

-(instancetype)initWithSupView:(UIView *)toView Title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sure2Block)sureBlock cancelBtnClick:(cancelBlock)cancelBlock
{
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
            make.width.mas_equalTo(Adapted(300));
            make.height.mas_equalTo(Adapted(277));
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
        titleLabel.textColor = kBackAssistColor;
        titleLabel.font = H15;
        titleLabel.text = title;
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
        
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        msgLabel.textColor = kBackAssistColor;
        msgLabel.text = message;
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(38));
            make.width.mas_equalTo(Adapted(80));
            
        }];
        
        UITextField * enterText = [[UITextField alloc]init];
        [self.alertView addSubview:enterText];
        enterText.secureTextEntry = YES;
        enterText.placeholder = placeholder;
        enterText.tintColor = kAssistColor;
        enterText.textColor = kBackAssistColor;
        enterText.font = H15;
        self.enterText = enterText;
        [enterText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(msgLabel.mas_right).offset(Adapted(10));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-15));
            make.centerY.mas_equalTo(msgLabel);
            make.height.mas_equalTo(Adapted(40));
        }];
        enterText.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            if(text.length>5&&self.enterText2.text.length>0){
                self.nextBtn.enabled = YES;
            }else{
                self.nextBtn.enabled = NO;
            }
            
        };
        
        UIView  *lineView = [[UIView alloc]init];
        [self.alertView addSubview:lineView];
        lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.top.mas_equalTo(enterText.mas_bottom).offset(Adapted(5));
            make.height.mas_equalTo(1);
        }];
        
        
        UILabel * msgLabel2 = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel2];
        msgLabel2.textColor = kBackAssistColor;
        msgLabel2.text = kLocalizedString(@"谷歌验证码");
        [msgLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(lineView.mas_bottom).offset(Adapted(37));
            make.width.mas_equalTo(Adapted(100));
            
        }];
        
        UITextField * enterText2 = [[UITextField alloc]init];
        [self.alertView addSubview:enterText2];
        enterText2.placeholder = kLocalizedString(@"谷歌验证码");
        enterText2.tintColor = kAssistColor;
        enterText2.textColor = kBackAssistColor;
        enterText2.font = H15;
        self.enterText2 = enterText2;
        self.enterText2.keyboardType = UIKeyboardTypeNumberPad;
        [enterText2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(msgLabel2.mas_right).offset(Adapted(10));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-15));
            make.centerY.mas_equalTo(msgLabel2);
            make.height.mas_equalTo(Adapted(40));
        }];
        enterText2.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            if(text.length>5&&self.enterText.text.length>0){
                self.nextBtn.enabled = YES;
            }else{
                self.nextBtn.enabled = NO;
            }
            
        };
        
        UIView  *lineView2 = [[UIView alloc]init];
        [self.alertView addSubview:lineView2];
        lineView2.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.top.mas_equalTo(enterText2.mas_bottom).offset(Adapted(5));
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.top.mas_equalTo(lineView2.mas_bottom).offset(Adapted(30));
            make.width.mas_equalTo(Adapted(180));
            make.height.mas_equalTo(Adapted(36));
        }];
        nextBtn.layer.cornerRadius = Adapted(36)/2.0;
        nextBtn.clipsToBounds = YES;
        [nextBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
        [nextBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        nextBtn.enabled = NO;
        self.nextBtn = nextBtn;
        [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
        [nextBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(sureBlock){
                sureBlock(enterText.text,enterText2.text);
            }
            [self hidden];
            
        }];
        
        
        
        
    }
    
    return self;
    
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
