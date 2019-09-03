// MGC
//
// BaseTableViewCell.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kBackGroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpViews];
        [self bindModel];
        
    }
    return self;
}
-(void)bindModel{}
-(void)setUpViews{
    
}
@end
