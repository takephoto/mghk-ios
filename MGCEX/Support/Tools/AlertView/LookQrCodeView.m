// MGC
//
// LookQrCodeView.m
// MGCEX
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "LookQrCodeView.h"
#import "UIImageView+UIActivityIndicator.h"

@interface LookQrCodeView()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView * toView;
@property (nonatomic, strong) UIImageView * codeImageV;
@end

@implementation LookQrCodeView

-(instancetype)initWithSupView:(UIView *)toView imageUrl:(NSString *)imageUrl sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock{
    
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
            make.width.mas_equalTo(Adapted(260));
            make.height.mas_equalTo(Adapted(310));
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
        titleLabel.text = kLocalizedString(@"扫码付款");
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
        
        UIImageView * codeImageV = [[UIImageView alloc]init];
        [self.alertView addSubview:codeImageV];
        //codeImageV.backgroundColor = k99999Color;
        [codeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.centerY.mas_equalTo(self.alertView);
            make.width.height.mas_equalTo(Adapted(160));
        }];
        self.codeImageV = codeImageV;
        [codeImageV bch_setImageWithURL:[NSURL URLWithString:imageUrl] showActivityIndicatorView:YES];

        UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:saveBtn];
        [saveBtn setTitle:kLocalizedString(@"保存到手机相册") forState:UIControlStateNormal];
        [saveBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        saveBtn.clipsToBounds = YES;
        saveBtn.layer.cornerRadius = Adapted(18);
        saveBtn.layer.borderColor = k99999Color.CGColor;
        saveBtn.layer.borderWidth = 1;
        saveBtn.titleLabel.font = H15;
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(codeImageV.mas_bottom).offset(Adapted(20));
            make.width.mas_equalTo(Adapted(160));
            make.height.mas_equalTo(Adapted(36));
            make.centerX.mas_equalTo(self.alertView);
        }];
        [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.sure_block = sureBlock;
    
        
    }
    return self;
}

//保存相片
-(void)saveBtnClick{
    
    if(!self.codeImageV.image)  return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageWriteToSavedPhotosAlbum(self.codeImageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
        
        
    });
  
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        [TTWHUD showCustomMsg:kLocalizedString(@"保存成功")];
        if(self.sure_block){
            [self hidden];
        }
    }
    
    else {
        [TTWHUD showCustomMsg:kLocalizedString(@"保存出错")];
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
