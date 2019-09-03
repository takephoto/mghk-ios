//
//  FWUserDefault.h
//  tongneiwangBusiness
//
//  Created by HFW on 2016/12/16.
//  Copyright © 2016年  MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TWUserDefault : NSObject


/////////网络获取的用户信息 ///////
//异步对UserModel异步序列化
+(void)UserDefaultSaveUserModel:(UserModel *)model;

//同步对UserModel反序列化
+(UserModel *)UserDefaultObjectForUserModel;

//异步对UserModel反序列化
+(void)asy_userDefaultObjectForUserModelCompletion:(void(^)(UserModel * model))completion;

//删除数据
+(void)DeleSaveUserModel;
@end
