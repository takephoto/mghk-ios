//
//  MGFiatExampleView.m
//  MGCEX
//
//  Created by Joblee on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGFiatExampleView.h"
@interface MGFiatExampleView()

@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField * enterText;
@property (nonatomic, strong) UITextField * enterText2;
@property (nonatomic, strong) UIView * toView;
@end


@implementation MGFiatExampleView

-(instancetype)initWithSupView:(UIView *)toView
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
            make.width.mas_equalTo(Adapted(250));
            make.height.mas_equalTo(Adapted(268));
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
        titleLabel.text = kLocalizedString(@"付款码示例");
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
            make.width.height.mas_equalTo(Adapted(47));
            make.centerY.mas_equalTo(headView);
        }];
        @weakify(self);
        [cancelBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
        
            [self hidden];
        }];
        
        UIImageView * codeImageV = [[UIImageView alloc]init];
        [self.alertView addSubview:codeImageV];
        codeImageV.image = IMAGE(@"QRCcode");
        codeImageV.backgroundColor = k99999Color;
        [codeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.centerY.mas_equalTo(self.alertView).offset(Adapted(22));
            make.width.height.mas_equalTo(Adapted(162));
        }];
        
        UILabel * codeLabel = [[UILabel alloc]init];
        [codeImageV addSubview:codeLabel];
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(codeImageV);
            make.width.height.mas_equalTo(Adapted(80));
        }];
        codeLabel.text = kLocalizedString(@"付款码示例");
        codeLabel.numberOfLines = 0;
        codeLabel.textColor = kTextColor;
        codeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        codeLabel.font = H13;
        codeLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        
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
