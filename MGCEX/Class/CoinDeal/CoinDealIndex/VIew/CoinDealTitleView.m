//
//  CoinDealTitleView.m
//  MGCEX
//
//  Created by HFW on 2018/7/11.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "CoinDealTitleView.h"
@interface CoinDealTitleView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *logoImgV;
@end
@implementation CoinDealTitleView

- (CGSize)intrinsicContentSize{
    
    return self.frame.size;
}

- (void)setupSubviews{
    
    //title
    UILabel *lab = [[UILabel alloc] init];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.centerY.mas_offset(0);
        make.height.mas_greaterThanOrEqualTo(Adapted(22));
    }];
    lab.font = H16;
    lab.textColor = kTextColor;
    self.titleLab = lab;
    
    ///up
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lab.mas_right).offset(0);
        make.centerY.right.mas_offset(0);
        make.width.height.mas_offset(Adapted(22));
    }];
    imageView.image = IMAGE(@"coinDeal_down");
    self.logoImgV = imageView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tapGes];
    [tapGes addTarget:self action:@selector(clickEvent:)];
}

- (void)clickEvent:(UIGestureRecognizer *)ges{
    
    self.selected = !self.selected;
    if (self.clickBlock) {
        self.clickBlock(self.selected);
    }
}

- (void)setSelected:(BOOL)selected{
    
    _selected = selected;
    self.logoImgV.image = selected ? IMAGE(@"coinDeal_up") : IMAGE(@"coinDeal_down");
}

- (void)setText:(NSString *)text{
    
    _text = text;
    self.titleLab.text = text;
    [self layoutIfNeeded];
//    [self.superview updateConstraintsIfNeeded];
}

@end
