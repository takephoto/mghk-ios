//
//  Y_VolumeMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_VolumeMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
@interface Y_VolumeMAView ()
@property (strong, nonatomic) UILabel *VolumeMA7Label;

@property (strong, nonatomic) UILabel *VolumeMA30Label;

@property (strong, nonatomic) UILabel *volumeDescLabel;

@property (strong, nonatomic) UILabel *dateDescLabel;

@end
@implementation Y_VolumeMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateDescLabel = [self private_createLabel];
        _VolumeMA7Label = [self private_createLabel];
        _VolumeMA30Label = [self private_createLabel];
        _volumeDescLabel = [self private_createLabel];


        
        _VolumeMA7Label.textColor = [UIColor ma7Color];
        _VolumeMA30Label.textColor = [UIColor ma30Color];
        _dateDescLabel.textColor = [UIColor whiteColor];
        
        [_dateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@110);
            
        }];

        [_volumeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [_VolumeMA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_volumeDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_VolumeMA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_VolumeMA7Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

+(instancetype)view
{
    Y_VolumeMAView *MAView = [[Y_VolumeMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.Date doubleValue]/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" yyyy-MM-dd HH:mm:ss"];
    NSString *dateString  = [formatter stringFromDate: date];

    _volumeDescLabel.text = [NSString stringWithFormat:@" 成交量(7,30):%.4f ",model.Volume];
    _dateDescLabel.text = dateString;
    _VolumeMA7Label.text = [NSString stringWithFormat:@"  MA7：%.2f ",model.Volume_MA7.floatValue];
    _VolumeMA30Label.text = [NSString stringWithFormat:@"  MA30：%.2f",model.Volume_MA30.floatValue];
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end
