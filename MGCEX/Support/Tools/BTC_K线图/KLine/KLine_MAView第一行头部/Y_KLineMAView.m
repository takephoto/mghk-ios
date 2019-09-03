//
//  Y_KLineMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
@interface Y_KLineMAView ()

@property (strong, nonatomic) UILabel *MA7Label;

@property (strong, nonatomic) UILabel *MA30Label;

@property (strong, nonatomic) UILabel *dateDescLabel;

@property (strong, nonatomic) UILabel *openDescLabel;

@property (strong, nonatomic) UILabel *closeDescLabel;

@property (strong, nonatomic) UILabel *highDescLabel;

@property (strong, nonatomic) UILabel *lowDescLabel;

@property (strong, nonatomic) UILabel *openLabel;

@property (strong, nonatomic) UILabel *closeLabel;

@property (strong, nonatomic) UILabel *highLabel;

@property (strong, nonatomic) UILabel *lowLabel;

@end

@implementation Y_KLineMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _MA7Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];
        
//        _dateDescLabel = [self private_createLabel];
        _openDescLabel = [self private_createLabel];
        _openDescLabel.text = kLocalizedString(@" 开:");
       
        _closeDescLabel = [self private_createLabel];
        _closeDescLabel.text = kLocalizedString(@" 收:");
        
        _highDescLabel = [self private_createLabel];
        _highDescLabel.text = kLocalizedString(@" 高:");

        _lowDescLabel = [self private_createLabel];
        _lowDescLabel.text = kLocalizedString(@" 低:");

        _openLabel = [self private_createLabel];
        _closeLabel = [self private_createLabel];
        _highLabel = [self private_createLabel];
        _lowLabel = [self private_createLabel];
        
        
        _MA7Label.textColor = [UIColor ma7Color];
        _MA30Label.textColor = [UIColor ma30Color];
        _openLabel.textColor = [UIColor whiteColor];
        _highLabel.textColor = [UIColor whiteColor];
        _lowLabel.textColor = [UIColor whiteColor];
        _closeLabel.textColor = [UIColor whiteColor];

        NSNumber *labelWidth = [NSNumber numberWithInt:50];
        
//        [_dateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(self.mas_bottom);
//            make.width.equalTo(@100);
//
//        }];
        
        [_openDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_openDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);
 
        }];
        _openLabel.adjustsFontSizeToFitWidth = YES;
        
        [_highDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_openLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_highDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);
        }];
        _highLabel.adjustsFontSizeToFitWidth = YES;
        
        [_lowDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_highLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lowDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];
        _lowLabel.adjustsFontSizeToFitWidth = YES;
        [_closeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lowLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_closeDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];
        _closeLabel.adjustsFontSizeToFitWidth = YES;
        [_MA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_closeLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_MA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_MA7Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
//            make.right.mas_equalTo(self.mas_right);
        }];
        _MA30Label.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;
}

+(instancetype)view
{
    Y_KLineMAView *MAView = [[Y_KLineMAView alloc]init];
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    _openLabel.text = [[model.Open stringValue] keepDecimal:8];
    _highLabel.text = [model.High.stringValue keepDecimal:8];
    _lowLabel.text = [model.Low.stringValue keepDecimal:8];
    _closeLabel.text = [model.Close.stringValue keepDecimal:8];
    NSString *ma7 = [model.MA7.stringValue keepDecimal:2];
    NSString *ma30 = [model.MA30.stringValue keepDecimal:2];
    _MA7Label.text = string(@" MA7:",ma7?ma7:@"0.00");
    _MA30Label.text = string(@" MA30:", ma30?ma30:@"0.00");
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = H7;
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}
@end
