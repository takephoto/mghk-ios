//
//  BuyFialDealTableViewCell.m
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BuyFialDealTableViewCell.h"
#import "PlaceOrderItemModel.h"

@interface BuyFialDealTableViewCell ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIView *line;
@end
@implementation BuyFialDealTableViewCell

- (void)setUpViews{
    
    self.backgroundColor = white_color;
    
    ///textField
    UITextField *textField = [[UITextField alloc] init];
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(UIEdgeInsetsMake(Adapted(7), Adapted(15), Adapted(7), Adapted(15)));
    }];
    textField.textColor = kTextColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = H18;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [textField.rac_textSignal subscribeNext:^(id x) {
        if(self.enterBlock) self.enterBlock(x);
    }];
    textField.endEditBlock = ^(NSString *text) {
        if(self.endEditBlock) self.endEditBlock(text);
    };
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField = textField;
    
    //left
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adapted(70), Adapted(22))];
    [self.contentView addSubview:leftLab];
    leftLab.font = H14;
    leftLab.textColor = k99999Color;
    textField.leftView = leftLab;
    self.leftLab = leftLab;
    
    //right
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adapted(70), Adapted(22))];
    [self.contentView addSubview:rightLab];
    rightLab.font = H14;
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.textColor = k99999Color;
    textField.rightView = rightLab;
    self.rightLab = rightLab;
    
    //分割线
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.left.mas_offset(Adapted(15));
        make.right.mas_offset(Adapted(-15));
        make.height.mas_offset(1);
    }];
    line.backgroundColor = kLineColor;
    self.line = line;
}

- (void)setModel:(PlaceOrderItemModel *)model{
    
    self.leftLab.text = model.title;
    self.rightLab.text = model.unit;
    self.textField.enabled = model.enable;
    self.textField.textColor = model.enable ? kTextColor : k99999Color;
    
    [[RACObserve(model, content) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        self.textField.text = model.content;
    }];
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    self.line.backgroundColor = separatorColor;
}

@end
