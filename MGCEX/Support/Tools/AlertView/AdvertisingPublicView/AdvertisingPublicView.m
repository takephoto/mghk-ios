// MGC
//
// AdvertisingPublicView.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AdvertisingPublicView.h"

@interface AdvertisingPublicView()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong) UIView * toView;
@property (nonatomic, assign) float alertWidth;
@end

@implementation AdvertisingPublicView

-(instancetype)initWithSupView:(UIView *)toView model:(AdvertisingPublicViewModel*)model sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock
{
    self=[super init];
    if (self) {
        self.sure_block = sureBlock;
        self.cancel_block = cancelBlock;
        self.frame = [UIScreen mainScreen].bounds;
        self.toView = toView;
        self.alertWidth = Adapted(310);
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(Adapted(-64));
            make.width.mas_equalTo(self.alertWidth);
            make.height.mas_equalTo(self.alertWidth);
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
        titleLabel.text = kLocalizedString(@"发布成功");
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(40));
            make.right.mas_equalTo(Adapted(-40));
            make.centerY.mas_equalTo(headView);
        }];

        
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        msgLabel.textColor = k99999Color;
        msgLabel.font = H13;
        NSString * str = kLocalizedString(@"平台已冻结您的");
        msgLabel.text = [NSString stringWithFormat:@"%@ %@%@",str,model.frozen,model.symbols];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(20));
            make.right.mas_equalTo(Adapted(-15));
            if (model.isBuy) {
                make.height.mas_equalTo(0);
                msgLabel.hidden = YES;
            }
        }];
        
        
        //公司名称
        UILabel * nameLabel = [[UILabel alloc]init];
        [self.alertView addSubview:nameLabel];
        nameLabel.textColor = kTextColor;
        nameLabel.text =  model.accountName;
        nameLabel.font = H15;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(Adapted(16));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-50));
            
        }];
        
        
        //VIP
        float titleWidth;
        
        if(([UIView getLabelWidthByHeight:20 Title:nameLabel.text font:H15]+Adapted(12)+Adapted(5))>(_alertWidth-Adapted(100))){
            titleWidth = _alertWidth - Adapted(100);
        }else{
            titleWidth = [UIView getLabelWidthByHeight:20 Title:nameLabel.text font:H15]+Adapted(12)+Adapted(5);
        }
        
        UIImageView * vipImageV = [[UIImageView alloc]init];
        [self.alertView addSubview:vipImageV];
        vipImageV.image = IMAGE(@"sjrz");
        [vipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(titleWidth);
            make.centerY.mas_equalTo(nameLabel);
            make.width.mas_equalTo(Adapted(16));
            make.height.mas_equalTo(Adapted(12));
        }];
        
   
        NSArray * leftNames = @[kLocalizedString(@"单价:"),kLocalizedString(@"数量:"),kLocalizedString(@"限价:"),kLocalizedString(@"支付:")];
        NSArray * leftValues = @[model.singlePrice,model.number,model.limitPrice,model.payWay];
        for(int i=0; i<4 ;i++){
            UILabel * leftLabel = [[UILabel alloc]init];
            [self.alertView addSubview:leftLabel];
            leftLabel.textColor = kTextColor;
            leftLabel.font = H15;
            leftLabel.text = leftNames[i];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapted(12));
                make.top.mas_equalTo(nameLabel.mas_bottom).offset(Adapted(16)+i*Adapted(30));
                make.width.mas_equalTo(Adapted(60));
            }];
            
            UILabel * rightLabel =[[UILabel alloc]init];
            [self.alertView addSubview:rightLabel];
            rightLabel.text = leftValues[i];
            rightLabel.font = H15;
            rightLabel.textColor = kTextColor;
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(leftLabel.mas_right);
                make.centerY.mas_equalTo(leftLabel);
                make.right.mas_equalTo(Adapted(-12));
            }];
            
         
        }
        
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:leftBtn];
        leftBtn.clipsToBounds = YES;
        leftBtn.layer.cornerRadius = Adapted(18);
        leftBtn.layer.borderColor = kRedColor.CGColor;
        leftBtn.layer.borderWidth = 1;
        [leftBtn setTitle:kLocalizedString(@"前往首页") forState:UIControlStateNormal];
        leftBtn.titleLabel.font = H15;
        [leftBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(16));
            make.bottom.mas_equalTo(Adapted(-16));
            make.width.mas_equalTo(Adapted(124));
            make.height.mas_equalTo(Adapted(36));
        }];
        
        @weakify(self);
        [leftBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(self.cancel_block){
                self.cancel_block();
            }
            [self hidden];
        }];
        
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:rightBtn];
        rightBtn.clipsToBounds = YES;
        rightBtn.layer.cornerRadius = Adapted(18);
        rightBtn.layer.borderColor = kRedColor.CGColor;
        rightBtn.layer.borderWidth = 1;
        [rightBtn setTitle:kLocalizedString(@"继续发布") forState:UIControlStateNormal];
        rightBtn.titleLabel.font = H15;
        [rightBtn setTitleColor:white_color forState:UIControlStateNormal];
        [rightBtn setBackgroundColor:kRedColor forState:UIControlStateNormal];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(Adapted(-16));
            make.bottom.mas_equalTo(Adapted(-16));
            make.width.mas_equalTo(Adapted(124));
            make.height.mas_equalTo(Adapted(36));
        }];

        [rightBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(self.sure_block){
                self.sure_block(nil);
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
