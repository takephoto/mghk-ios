// MGC
//
// HandIdentityExampleCell.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HandIdentityExampleCell.h"
@interface HandIdentityExampleCell()

@end
@implementation HandIdentityExampleCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(5), 200, Adapted(20))];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.text = kLocalizedString(@"拍摄示例");
    titleLabel.font = H15;
    
    NSArray * titles = @[kLocalizedString(@"正确"),kLocalizedString(@"模糊、缺失、遮挡")];
    
    NSArray * pics = @[@"zq_scsfz",@"cw_scsfz"];
    
    
    for(int i=0;i<pics.count;i++){
        QSButton * btn = [QSButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*MAIN_SCREEN_WIDTH/pics.count, Adapted(40), MAIN_SCREEN_WIDTH/pics.count, Adapted(161));
        [self.contentView addSubview:btn];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:IMAGE(pics[i]) forState:UIControlStateNormal];
        btn.style = QSButtonImageStyleTop;
        btn.space = Adapted(3);
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = H12;
        btn.tag = 100+i;
        if(i==0){
            [btn setTitleColor:kGreenColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:kRedColor forState:UIControlStateNormal];
        }
    }
    
}

-(void)setPics:(NSArray *)pics{
    _pics = pics;
    for(int i=0;i<pics.count;i++){
        QSButton * btn = [self viewWithTag:100+i];
        [btn setImage:IMAGE(pics[i]) forState:UIControlStateNormal];
    }
    
}
@end
