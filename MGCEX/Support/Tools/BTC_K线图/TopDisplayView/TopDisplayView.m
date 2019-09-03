//
//  TopDisplayView.m
//  BTC-Kline
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 yate1996. All rights reserved.
//

#import "TopDisplayView.h"
#import "Masonry.h"

@interface TopDisplayView(){
}
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *CNYLabel;
@property (nonatomic, strong) UILabel *floatLabel;

@property (nonatomic, strong) UILabel *heightPriceLabel;
@property (nonatomic, strong) UILabel *lowPriceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;

@end

@implementation TopDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self bindModel];
    }
    return self;
}
- (void)bindModel
{
    KWeakSelf;
    [RACObserve(weakSelf, model)subscribeNext:^(MGMarketIndexRealTimeModel *model) {
        if (model) {
            weakSelf.priceLabel.text = [model.c keepDecimal:8];
            weakSelf.CNYLabel.text = [NSString stringWithFormat:@"≈%@CNY",[model.valuation keepDecimal:2]];
            double floatNum = [model.gains doubleValue]*100;
            if (floatNum > 0) {
                weakSelf.floatLabel.text = [NSString stringWithFormat:@"+%.2lf%%",floatNum];
                weakSelf.floatLabel.textColor = kGreenColor;
            }else{
                weakSelf.floatLabel.text = [NSString stringWithFormat:@"%.2lf%%",floatNum];
                weakSelf.floatLabel.textColor = kRedColor;
            }
            
            
            weakSelf.heightPriceLabel.text = [model.h keepDecimal:8];
            weakSelf.lowPriceLabel.text = [model.l keepDecimal:8];
            weakSelf.volumeLabel.text = [model.accVolume keepDecimal:0].toTenThousandUnit;
        }
    }];
}
- (void)setupSubViews
{
    self.backgroundColor = kKLineBGColor;
    //价格
    UILabel *priceLabel = [UILabel new];
    [self addSubview:priceLabel];
    priceLabel.textColor = green_color;
    priceLabel.font = [UIFont systemFontOfSize:20];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
    }];
    self.priceLabel = priceLabel;
    
    //约等CNY
    UILabel *CNYLabel = [UILabel new];
    [self addSubview:CNYLabel];
    CNYLabel.textColor = UIColorFromRGB(0xA2A2A2);
    CNYLabel.font = [UIFont systemFontOfSize:12];
    [CNYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(priceLabel.mas_left);
    }];
    self.CNYLabel = CNYLabel;
    //浮动+0.3%
    UILabel *floatLabel = [UILabel new];
    [self addSubview:floatLabel];
    floatLabel.textColor = [UIColor redColor];
    floatLabel.font = [UIFont systemFontOfSize:12];
    [floatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(CNYLabel.mas_right).offset(5);
    }];
    self.floatLabel = floatLabel;
    
    NSArray *titleStrArr = @[kLocalizedString(@"高"),kLocalizedString(@"低"),kLocalizedString(@"24H量")];
    for (int i=0;i<titleStrArr.count;i++) {
        //数据
        UILabel *dataLabel = [UILabel new];
        [self addSubview:dataLabel];
        dataLabel.textColor = green_color;
        dataLabel.font = [UIFont systemFontOfSize:12];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+30*i);
            make.right.mas_equalTo(-10);
        }];
        
        
        //标题
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = UIColorFromRGB(0xA2A2A2);
        titleLabel.text =titleStrArr[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dataLabel);
            make.right.mas_equalTo(dataLabel.mas_left).offset(-10);
        }];
        switch (i) {
            case 0:
                self.heightPriceLabel = dataLabel;
                break;
            case 1:
                self.lowPriceLabel = dataLabel;
                break;
            case 2:
                self.volumeLabel = dataLabel;
                self.volumeLabel.hidden = YES;
                titleLabel.hidden = YES;
                break;
        }
    }
    
    
}
@end
