// MGC
//
// PersonalCenterCell.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "PersonalCenterCell.h"
#import "EnterTextView.h"

@implementation PersonalCenterCell

-(void)setUpViews{
    
    self.backgroundColor = kBackAssistColor;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self.contentView);
        //make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.titleLabel = titleLabel;
    
    UIImageView * arrowImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:arrowImageV];
    arrowImageV.image = IMAGE(@"jiantou-heng");
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(8));
        make.height.mas_equalTo(Adapted(13));
    }];
    self.arrowImageV = arrowImageV;
   
    
    UILabel * subLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLabel];
    subLabel.textColor = kTextColor;
    subLabel.font = H15;
    subLabel.textAlignment = NSTextAlignmentRight;
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImageV.mas_left).offset(Adapted(-8));
        make.centerY.mas_equalTo(self.contentView);
        //make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0+20);
    }];
    self.subLabel = subLabel;
    self.subLabel.hidden = YES;
    
    UISwitch * cellSwitch = [[UISwitch alloc]init];
    [self.contentView addSubview:cellSwitch];
    [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.cellSwitch = cellSwitch;
    cellSwitch.on = NO;
    cellSwitch.onTintColor = kRedColor;
    [cellSwitch setEnabled:NO];
    //[cellSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.cellSwitch.hidden = YES;
}

-(void)setIsEnable:(BOOL)isEnable{

    if(isEnable == YES){//有箭头 字体白色
        self.subLabel.textColor = kTextColor;
        self.arrowImageV.hidden = NO;
        
    }else{ //无箭头 字体偏暗
        self.subLabel.textColor = kAssistColor;
        self.arrowImageV.hidden = YES;
    }
}

-(void)setPersonCellType:(PersonalCellType)personCellType{
    switch (personCellType) {
        case 0:{
            self.subLabel.textColor = kTextColor;
            self.subLabel.hidden = NO;
            self.arrowImageV.hidden = NO;
            self.cellSwitch.hidden = YES;
            [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageV.mas_left).offset(Adapted(-8));
                make.centerY.mas_equalTo(self.contentView);
                //make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
            }];
        }
            break;
        case 1:{
            self.subLabel.textColor = kAssistColor;
            self.subLabel.hidden = NO;
            self.arrowImageV.hidden = YES;
            self.cellSwitch.hidden = YES;
            [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(Adapted(-16));
                make.centerY.mas_equalTo(self.contentView);
                //make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
            }];
        }
            break;
        case 2:{
            self.subLabel.hidden = YES;
            self.arrowImageV.hidden = YES;
            self.cellSwitch.hidden = NO;
        }
            break;
        
            
        default:
            break;
    }
}



-(void)switchAction:(UISwitch *)cellswitch{
    BOOL isButtonOn = [cellswitch isOn];
    
    if (isButtonOn) {
        NSLog(@"开");
    }else {
        NSLog(@"关");
    }
    
    if(self.switchBlock){
        self.switchBlock(cellswitch);
    };
    
}




@end
