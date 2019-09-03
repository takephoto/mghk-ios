// MGC
//
// IDCardProgressView.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "IDCardProgressView.h"

@implementation IDCardProgressView


-(id)initWithImage:(NSString *)imageName step:(NSInteger )step style:(NSInteger)style frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        if(style == 1){
            UIImageView * imageV = [[UIImageView alloc]init];
            [self addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(Adapted(24));
                make.left.mas_equalTo(Adapted(36));
                make.right.mas_equalTo(Adapted(-36));
                make.height.mas_equalTo(Adapted(10));
            }];
            imageV.image =  IMAGE(imageName);
            NSArray * titles = @[kLocalizedString(@"身份信息"),kLocalizedString(@"身份正面"),kLocalizedString(@"身份反面"),kLocalizedString(@"手持证件")];
            for(int i=0;i<titles.count;i++){
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*(MAIN_SCREEN_WIDTH/4.0), Adapted(47), MAIN_SCREEN_WIDTH/4.0, Adapted(20))];
                if(i < step){
                    label.textColor = kTextColor;
                }else{
                    label.textColor = kAssistTextColor;
                }
                
                label.textAlignment = NSTextAlignmentCenter;
                label.font = H13;
                label.text = titles[i];
                [self addSubview:label];
                
            }
        }else{
            UIImageView * imageV = [[UIImageView alloc]init];
            [self addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(Adapted(24));
                make.left.mas_equalTo(Adapted(60));
                make.right.mas_equalTo(Adapted(-60));
                make.height.mas_equalTo(Adapted(10));
            }];
            imageV.image = IMAGE(imageName);
            NSArray * titles = @[kLocalizedString(@"护照信息"),kLocalizedString(@"护照信息页"),kLocalizedString(@"手持护照信息页")];
            for(int i=0;i<titles.count;i++){
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*(MAIN_SCREEN_WIDTH/3.0), Adapted(47), MAIN_SCREEN_WIDTH/3.0, Adapted(20))];
                if(i < step){
                    label.textColor = kTextColor;
                }else{
                    label.textColor = kAssistTextColor;
                }
                
                label.textAlignment = NSTextAlignmentCenter;
                label.font = H13;
                label.text = titles[i];
                [self addSubview:label];
                
            }
        }
        
        
        
    }
    return self;
}


@end
