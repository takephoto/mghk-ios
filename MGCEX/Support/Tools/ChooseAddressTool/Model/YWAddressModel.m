//
//  YWAddressModel.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWAddressModel.h"

@implementation YWAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}


///***加密*/
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.code forKey:@"code"];
//    [aCoder encodeObject:self.sheng forKey:@"sheng"];
//    [aCoder encodeObject:self.di forKey:@"di"];
//    [aCoder encodeObject:self.xian forKey:@"xian"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.level forKey:@"level"];
//    [aCoder encodeBool:self.isSelected forKey:@"isSelected"];
//
//    
//}
//
//
///**解密*/
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if (self != nil) {
//        self.code = [aDecoder decodeObjectForKey:@"code"];
//        self.sheng = [aDecoder decodeObjectForKey:@"sheng"];
//        self.di = [aDecoder decodeObjectForKey:@"di"];
//        self.xian = [aDecoder decodeObjectForKey:@"xian"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.level = [aDecoder decodeObjectForKey:@"level"];
//        self.isSelected = [aDecoder decodeObjectForKey:@"isSelected"];
//
//        
//    }
//    return self;
//}  

@end
