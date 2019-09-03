// MGC
//
// TTWNetworkManager.m
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TTWNetworkManager.h"
#import "NSObject+TTWHUD.h"
#import "TTWNetworkHandler.h"
#import "TTWHUD.h"
#import "YYModel.h"
#import "MGResponseModel.h"

@interface TTWNetworkManager()
{
    MBProgressHUD *HUD;
}
@end
@implementation TTWNetworkManager

//展示错误提示
+(void)showLoadFialMsg:(NSString *)msg{
    
    [self showErrorText:kLocalizedString(msg) maskView:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissLoading];
    });
}

//////////////////测试///////////////////

+(void)requestTestInfoWithSuccess:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError
{
    
    NSError *error;
    // 获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    // 根据文件路径读取数据
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:filePath];
    // 格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingAllowFragments error:&error];
    MGResponseModel *reponseModel = [MGResponseModel yy_modelWithDictionary:jsonObject];
    
    if (reponseModel == nil) {
        [self showLoadFialMsg:@"Json数据有误"];
        if (reqError) reqError(nil);
    } else {
        if (reponseModel.code == NetStatusSuccess) {
            [self showLoadFialMsg:@"成功"];
            if (success) success(reponseModel.data);
        } else {
            [self showLoadFialMsg:@"失败"];
            if (failure) failure(reponseModel.data);
        }
    }
    
}

+ (void)uploadWithUrl:(NSString *)url uploadParam:(TTWUploadParam *)uploadParam params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(TTWResponseError)failure{
    
    __weak typeof(self)weakSelf = self;
    [TTWNetworkHandler uploadWithUrl:url UploadParam:uploadParam parameters:params progress:^(NSProgress * _Nonnull uploadProgress,int64_t bytesWritten, int64_t totalBytesWritten) {
        //显示进度
        [weakSelf showProgress:[[NSNumber numberWithLongLong:bytesWritten] floatValue]/totalBytesWritten maskView:YES];
        
    } success:^(id response) {
        if(success)  success(response);
        
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"上传成功") toView:nil];
    } fail:^(NSError *error) {
        if (failure)  failure(error);
        [TTWHUD showCustomIcon:@"HUD_error" title:kLocalizedString(@"上传失败") toView:nil];
    }];
    
    
}

/**
 *  文件下载
 */
+ (void)downFileWithUrl:(NSString *)url params:(NSDictionary *)params filePath:(NSString *)filePath success:(TTWResponseSuccess)success failure:(TTWResponseError)failure{
    
    __weak typeof(self)weakSelf = self;
    [TTWNetworkHandler downloadWithUrl:url saveToPath:filePath progress:^(NSProgress * _Nonnull downLoadProgress,int64_t bytesRead, int64_t totalBytesRead) {
        //显示进度
        NSLog(@"%lld,%lld,%f",bytesRead,totalBytesRead,[[NSNumber numberWithLongLong:bytesRead] floatValue]/totalBytesRead);
        [weakSelf showProgress:[[NSNumber numberWithLongLong:bytesRead] floatValue]/totalBytesRead maskView:NO];
        
    } success:^(id response) {
        if(success)  success(response);
    } failure:^(NSError *error) {
        if (failure)  failure(error);
    }];
    
}


#pragma mark-- 发送手机/邮箱验证码
+(void)phoneVerificationCodeWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark-- 注册手机或邮箱
+(void)RegisterPhoneOrMailWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response){
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark-- 登录
+(void)userLoginAccountWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark-- 重置／忘记密码
+(void)resetPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark --  身份证/护照最终提交认证
+ (void)theIdentityAuthenticationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark --  手机号和邮箱认证
+ (void)phoneMailAuthenticationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  获取用户信息
+ (void)getUserInfomationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  二次验证
+ (void)secondaryValidationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [self showLoadingWithMaskView:YES];
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  用户登录校验
+ (void)logOntoCheckWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  设置里的更改密码
+ (void)changeLoginPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  获取谷歌Key
+ (void)getGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  谷歌Key验证
+ (void)verifyGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  开启关闭谷歌验证
+ (void)openCloseverifyGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  验证登录密码是否正确
+ (void)verifyLoginPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  谷歌二次验证
+ (void)GoogleSecondverifyLoginWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  设置资金密码
+ (void)SettingMoneyPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  单张图片以参数形式上传
+ (void)uploadPicturesImageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //转base64
        UIImage * image = [params objectForKey:@"imageFile"];
        NSString * imageStr = [TWAppTool imageToString:image];
        [params setValue:imageStr forKey:@"imageFile"];
        [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
            if (MGStatus(response) == NetStatusSuccess) {
                if (success) success(response);
                [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"上传成功") toView:nil];
            } else {
                if (failure) failure(response);
                [TTWHUD showCustomIcon:@"HUD_error" title:kLocalizedString(@"上传失败") toView:nil];
            }
            
        } fail:^(NSError *error) {
            if (reqError)  reqError(error);
            [self showLoadFialMsg:kLocalizedString(@"网络有误")];
            
        }];
   
        
    });
    
}
+ (void)uploadPicturesWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *imageStrArr = [NSMutableArray new];
        
        NSArray *imageArr = params[@"imageArr"];
        for (UIImage *image in imageArr) {
            //转base64
            NSString * imageStr = [TWAppTool imageToString:image];
            [imageStrArr addObject:imageStr];
        }
        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
        [dicTemp setValue:[imageStrArr yy_modelToJSONString] forKey:@"imageFiles"];
        
        [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:dicTemp isShowHUD:YES success:^(id response) {
            if (MGStatus(response) == NetStatusSuccess) {
                if (success) success(response);
                [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"上传成功") toView:nil];
            } else {
                if (failure) failure(response);
                [TTWHUD showCustomIcon:@"HUD_error" title:kLocalizedString(@"上传失败") toView:nil];
            }
            
        } fail:^(NSError *error) {
            if (reqError)  reqError(error);
            [self showLoadFialMsg:kLocalizedString(@"网络有误")];
            
        }];
        
        
    });
}
#pragma mark --  绑定银行卡，支付宝，微信
+ (void)bindingBankCardZfbWxWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
    
}

#pragma mark --  获取绑定银行卡，支付宝，微信
+ (void)getBindingBankCardZfbWxWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  获取法币交易列表
+ (void)getFiatTransactionListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  获取所有币种
+ (void)getAllcurrencyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{

    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark --  获取法币交易首页数据
+ (void)getFiatDealHomepageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

//#pragma mark --  获取自己发布的广告列表数据
//+ (void)getMyFiatDealHomepageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(TTWResponseError)failure{
//    [self showLoadingWithMaskView:YES];
//    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params success:^(id response) {
//        if(success)  success(response);
//        
//    } fail:^(NSError *error) {
//        if (failure)  failure(error);
//        [self showLoadFialMsg:@"网络有误"];
//    }];
//}

#pragma mark-- 发布广告
+(void)publicAdvertismentWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 申诉
+(void)commitComplainWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 查看申诉信息
+(void)checkComplainWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 获取支付方式
+(void)getPayWayWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 获取币种列表
+(void)getCoinNumberWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark-- 法币交易下单
+ (void)gotoBuyOrSellOrderWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
    
}


#pragma mark-- 获取法币交易记录详情/
+ (void)getFiatCodeDetaiWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark-- 标记为已付款/已收款
+ (void)markedPaymentReceivedWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {

        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
    
}


#pragma mark-- 取消交易
+ (void)cancelTradingWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}



#pragma mark-- 获取法币/币币账户信息
+ (void)getFiatInfoWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 资金划转
+(void)transferWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark --  获取盘面行情/买卖五档/获取币种可用数量
+ (void)getQuotationsWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
    }];
}


#pragma mark-- 获取法币交易记录委托列表
+ (void)getFiatEntrustListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark-- 广告发布撤销
+ (void)removeAdsOrdertWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 充币
+ (void)rechargeWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 提币
+ (void)withdrawWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}
#pragma mark-- 根据该用户的币种获取币币的详情信息(提币)
+ (void)getCoinFundsInfoWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}




#pragma mark-- 获取交易队列
+(void)getcurrencylListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark-- 获取国际行情价
+(void)getInternationalMarketPriceWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
       
        
    }];
}

#pragma mark--  是否强制更新
+(void)mandatoryUpdateManagerWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark--  充币/提币列表
+(void)fillingCurrencyCurrencyWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark--  币币委托撤单
+(void)cancelCoinWeituoWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark--  币币交易下单买/卖
+(void)coinDealBuySellOrderWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}


#pragma mark--  获取币币交易委托列表
+(void)getCoinDealweituoOrderWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{

    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark--  获取我的自选列表
+(void)getCoinDealMyChoiceListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
        
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark--  添加/取消自选列表
+(void)addOrCancelMyChoiceListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            [self showLoadFialMsg:MGMsg(response)];
            if (failure) failure(response);
        }
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
        
    }];
}

#pragma mark--  获取最小交易量
+(void)getMinVolumeWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
           
            if (failure) failure(response);
        }
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
       
        
    }];
}


#pragma mark--  获取最小变动单位
+(void)getMinWaveWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError{
    
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
       
            if (failure) failure(response);
        }
    } fail:^(NSError *error) {
        if (reqError)  reqError(error);
        
        
    }];
}

#pragma mark--  获取币种获取详情信息
+(void)getCoinInfoWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError
{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id  _Nullable response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            
            if (failure) failure(response);
        }
    } fail:^(NSError * _Nullable error) {
         if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
    }];
}

#pragma mark--  获取公告列表
+(void)getAnnouncementListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError
{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:NO success:^(id  _Nullable response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
        }
    } fail:^(NSError * _Nullable error) {
        if (reqError)  reqError(error);
        
    }];
}

#pragma mark--  资金转移
+(void)commitCoinMoveWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError
{
    [TTWNetworkHandler requestWithUrl:url requestMethod:RequestByPost params:params isShowHUD:YES success:^(id  _Nullable response) {
        if (MGStatus(response) == NetStatusSuccess) {
            if (success) success(response);
        } else {
            if (failure) failure(response);
            [self showLoadFialMsg:kLocalizedString(MGMsg(response))];
        }
    } fail:^(NSError * _Nullable error) {
        if (reqError)  reqError(error);
        [self showLoadFialMsg:kLocalizedString(@"网络有误")];
    }];
}

@end
