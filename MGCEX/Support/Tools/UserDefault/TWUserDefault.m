//
//  FWUserDefault.m
//  tongneiwangBusiness
//
//  Created by HFW on 2016/12/16.
//  Copyright © 2016年  MGCion. All rights reserved.
//

#import "TWUserDefault.h"

#import "UserModel.h"

@implementation TWUserDefault

//对UserModel异步序列化
+(void)UserDefaultSaveUserModel:(UserModel *)model{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UserModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
     
        
    });

}

//对UserModel反序列化
+(UserModel *)UserDefaultObjectForUserModel{
   id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserModel"];
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    return model;
}

//异步对UserModel反序列化
+(void)asy_userDefaultObjectForUserModelCompletion:(void(^)(UserModel * model))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserModel"];
        UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        

            if(completion){
                completion(model);
            }
     
      
    });
}

//删除数据
+(void)DeleSaveUserModel{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserModel"];
}



@end
