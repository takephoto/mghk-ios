// MGC
//
// FiatDetailedInstructionsCell.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatDetailedInstructionsCell.h"
#import "TWTextView.h"


@implementation FiatDetailedInstructionsCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.text = kLocalizedString(@"其他证据说明");
    titleLabel.textColor = kTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.top.mas_equalTo(Adapted(15));
    }];
    
    TWTextView * textView = [[TWTextView alloc]initWithFrame:CGRectZero];
    textView.placeholder = kLocalizedString(@"请编辑有利证据说明");
    
    textView.placeholderColor = UIColorFromRGB(0xdddddd);
    textView.limitLength = 1000;
    textView.font = H15;
    [self.contentView addSubview:textView];
    textView.textColor = kTextColor;
    self.textView = textView;
   
}

- (void)needTextViewBorder:(BOOL) isNeed
{
    if (isNeed) {
       self.textView.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
       self.textView.layer.borderWidth = 0.5;
        self.textView.x = 10;
        self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0);
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(Adapted(40), Adapted(15), Adapted(15), Adapted(15)));
        }];
    } else{
        self.textView.layer.borderColor = [UIColor clearColor].CGColor;
        self.textView.layer.borderWidth = 0;
        self.textView.x = 0;
        self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(Adapted(40), Adapted(11), Adapted(15), Adapted(15)));
        }];

    }
}

@end
