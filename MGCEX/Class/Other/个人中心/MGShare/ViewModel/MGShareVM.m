//
//  MGShareVM.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGShareVM.h"

@implementation MGShareVM

- (id)initWithInvitationCode:(NSString *)invitationCode
{
    if (self = [super init]) {
        _invitationCode = invitationCode ? invitationCode : @"";
    }
    return self;
}

#pragma mark -- Public Method

- (NSString *)navTitleText
{
    return kLocalizedString(@"分享");
}

- (NSString *)linkTitleText
{
   return kLocalizedString(@"复制该链接，分享给好友，并告知用浏览器打开");
}

- (NSString *)linkUrlText
{
    return [NSString stringWithFormat:@"https://download.MEIB.IO/share.html?myInviteCode=%@&inviteFrom=1",self.invitationCode];
}

- (NSString *)copylinkUrlText
{
    return [NSString stringWithFormat:@"https://download.MEIB.IO/share.html?myInviteCode=%@&inviteFrom=1\n%@，%@", _invitationCode,kLocalizedString(@"复制该链接"),kLocalizedString(@"并在浏览器中打开")];
}

- (NSString *)qrCodeUrlText
{
   return [NSString stringWithFormat:@"https://download.MEIB.IO/share.html?myInviteCode=%@&inviteFrom=1",self.invitationCode];
}

- (NSString *)linkButtonTitleText
{
    return kLocalizedString(@"复制");
}

- (NSString *)qrCodeTitleText
{
    return kLocalizedString(@"保存二维码，并把二维码分享给好友");
}


- (NSString *)qrCodeButtonTitleText
{
    return kLocalizedString(@"保存到手机");
}


@end
