// MGC
//
// FillCoinRecodeListModel.m
// MGCEX
//
// Created by MGC on 2018/6/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FillCoinRecodeListModel.h"

@interface FillCoinRecodeListModel ()
/// 高度
@property (nonatomic, readwrite) CGFloat cellHeight;
@end

@implementation FillCoinRecodeListModel
-(void)setStatus:(NSString *)status{
    _status = status;
    
    if([_status integerValue] == 1){
        
        self.statusString = kLocalizedString(@"处理中") ;
        
    }else if ([_status integerValue] == 2){
        
        self.statusString = kLocalizedString(@"已处理") ;
        
    }else if ([_status integerValue] == 3){
        
        self.statusString = kLocalizedString(@"失败") ;
        
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"hashStr" :@"hash"};
}


- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        // 计算高度
        // 单号高度
        CGFloat orderNoHeight = ceil([self.orderNo boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH/3.0*2.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:H15} context:nil].size.height);
        // 日期高度
        CGFloat dateHeight = ceil([self.time boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH/3.0*2.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:H15} context:nil].size.height);
        //        A18 + XH15 + XH15 + A21 + H11 + A8 + H13 + A12 + A18
        return orderNoHeight + dateHeight + Adapted(18) + Adapted(21) + Adapted(11) + Adapted(8) + Adapted(13) + Adapted(12) + Adapted(20*2);
    }
    return _cellHeight;
}
@end
