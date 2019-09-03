// MGC
//
// TWSerializeModel.m
// IOSFrameWork
//
// Created by MGC on 2018/4/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWSerializeModel.h"

@implementation TWSerializeModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [TWAppTool getPropertiesAndValueFromModel:self completion:^(NSString *key, id value) {
        
        [aCoder encodeObject:value forKey:key];
    }];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        [TWAppTool getPropertiesAndValueFromModel:self completion:^(NSString *key, id value) {
            
            id tValue = [aDecoder decodeObjectForKey:key];
            if (tValue) {
                
                [self setValue:tValue forKey:key];
            }
        }];
    }
    return self;
}



@end
