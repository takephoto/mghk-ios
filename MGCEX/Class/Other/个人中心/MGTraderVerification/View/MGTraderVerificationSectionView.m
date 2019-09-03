//
//  MGTraderVerificationSectionView.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationSectionView.h"
#import "MGTraderVerificationVM.h"

@interface MGTraderVerificationSectionView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MGTraderVerificationSectionView


#pragma mark -- Super Method

- (void)setupSubviews{
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}


#pragma mark -- Public Method

- (void)configWithViewModel:(MGTraderVerificationVM *)viewModel
{
    self.titleLabel.text = viewModel.sectionTitleText;
    if(viewModel.applyStatus == MGMerchantsApplySuccess){
        self.titleLabel.textColor = kGreenColor;
    }else if (viewModel.applyStatus == MGMerchantsApplying){
        self.titleLabel.textColor = kTextColor;
    } else if (viewModel.applyStatus == MGMerchantsApplyFailed){
        self.titleLabel.textColor = kRedColor;
    }
}


#pragma mark -- Private Method

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        [_titleLabel = [UILabel alloc] init];
        _titleLabel.textColor = kRedColor;
        _titleLabel.font = H13;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end
