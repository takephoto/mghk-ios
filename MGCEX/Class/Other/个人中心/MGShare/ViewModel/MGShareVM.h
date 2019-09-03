//
//  MGShareVM.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseViewModel.h"

@interface MGShareVM : BaseViewModel

// 导航标题
@property (nonatomic, strong) NSString *navTitleText;

// 链接标题
@property (nonatomic, strong) NSString *linkTitleText;

// 链接URL
@property (nonatomic, strong) NSString *linkUrlText;

// 复制链接URL
@property (nonatomic, strong) NSString *copylinkUrlText;

// 链接按钮标题
@property (nonatomic, strong) NSString *linkButtonTitleText;

// 二维码标题
@property (nonatomic, strong) NSString *qrCodeTitleText;

// 扫描二维码URL
@property (nonatomic, strong) NSString *qrCodeUrlText;

// 二维码按钮标题
@property (nonatomic, strong) NSString *qrCodeButtonTitleText;

// 我的邀请码
@property (nonatomic, strong) NSString *invitationCode;


/**
 初始化

 @param invitationCode 我的邀请码
 @return self
 */
- (id)initWithInvitationCode:(NSString *)invitationCode;

@end
