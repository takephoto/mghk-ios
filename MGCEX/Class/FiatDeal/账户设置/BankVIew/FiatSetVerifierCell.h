// MGC
//
// FiatSetVerifierCell.h
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "RegisterIndexVM.h"
typedef void(^verifier)(NSString *string);

@interface FiatSetVerifierCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * titleLabel1;
@property (nonatomic, strong) UILabel * titleLabel2;
@property (nonatomic, strong) UITextField * password;
@property (nonatomic, strong) UITextField * verifierCode;
@property (nonatomic,strong) UIButton * codeButton;
@property (nonatomic, copy) verifier verifierBlock;
@property (nonatomic, strong) UIButton *mailBtn;
@property (nonatomic, strong) RegisterIndexVM * viewModel;
@end
