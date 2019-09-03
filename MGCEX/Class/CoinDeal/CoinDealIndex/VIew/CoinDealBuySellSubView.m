// MGC
//
// CoinDealBuySellSubView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealBuySellSubView.h"

#import "TWSlider.h"

@interface CoinDealBuySellSubView()
@property (nonatomic, copy) NSString * text1Value;
@end
@implementation CoinDealBuySellSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPriceValue:) name:CoinDealprice object:nil];
        self.trCode = @"";
        self.markStr = @"";
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = kBackAssistColor;
    
    UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:titleBtn];
    self.titleBtn = titleBtn;
    [titleBtn setTitle:kLocalizedString(@"限价买入") forState:UIControlStateNormal];
    [titleBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    titleBtn.titleLabel.font = H14;
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(Adapted(5));
        make.height.mas_equalTo(Adapted(36));
    }];
    @weakify(self);
    [titleBtn mg_addTapBlock:^(UIButton *button) {
        @strongify(self);
        if(self.buylimitBlock){
            self.buylimitBlock();
        }
    }];
    
    UIImageView * downArrawImageV = [[UIImageView alloc]init];
    [self addSubview:downArrawImageV];
    downArrawImageV.image = IMAGE(@"spread");
    [downArrawImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(titleBtn);
        make.width.mas_equalTo(Adapted(10));
        make.height.mas_equalTo(Adapted(6));
    }];
    
    PPNumberButton * ppBtn1 = [[PPNumberButton alloc]initWithFrame:CGRectZero inputType:1];
    [self addSubview:ppBtn1];
    self.ppBtn1 = ppBtn1;
    ppBtn1.currentNumber = 0;
    [ppBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(titleBtn.mas_bottom).offset(Adapted(10));
        make.height.mas_equalTo(Adapted(46));
    }];
    ppBtn1.minValue = 0;
    //ppBtn1.textField.adjustsFontSizeToFitWidth;
    ppBtn1.textField.font = H14;
    ppBtn1.textField.textColor = kTextColor;
    ppBtn1.increaseImage = [UIImage imageNamed:@"jiahao2"];
    ppBtn1.decreaseImage = [UIImage imageNamed:@"jianhao2"];
    ViewBorderRadius(ppBtn1, 0, 1, kLineColor);
    ppBtn1.resultBlock = ^(float num ,BOOL increaseStatus){
    
        
    };
    
    //这种监听，当代码给textfile赋值的时候可以监听到
    RAC(self,backgroundColor) = [[RACObserve(self.ppBtn1.textField, text)  merge:self.ppBtn1.textField.rac_textSignal ] map:^id(NSString *value) {
        @strongify(self);
        
        float num = [value floatValue];
        self.text1Value = value;
        //约等于人民币
        self.cnyLabel.text = [NSString stringWithFormat:@"≈%.2f CNY",[self.model.marketPrice floatValue]*num];
        self.appraisement = [self.model.marketPrice floatValue]*num;
        //交易总价
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:kLocalizedString(@"交易额:") attributes:@{NSFontAttributeName: H15, NSForegroundColorAttributeName: kAssistTextColor}];
        NSString *contentStr = [NSString stringWithFormat:@" %.2f %@", num*self.ppBtn2.currentNumber,self.markStr];
        NSAttributedString *contentAttr = [[NSAttributedString alloc] initWithString:contentStr attributes:@{NSFontAttributeName: H18, NSForegroundColorAttributeName: kTextColor}];
        [titleAttr appendAttributedString:contentAttr];
        self.turnoverLabel.attributedText = titleAttr;
        
        if(self.ppBtn2.currentNumber>self.slider.maximumValue && [[self.availableBalance keepDecimal:8] doubleValue]){
            self.ppBtn2.textField.text = [[NSString stringWithFormat:@"%.20f",self.slider.maximumValue] keepDecimal:[self.ppBtn2.textField.limitDecimalDigitLength integerValue]];
        }
        
        [self configData];
        
        
        
        return kBackAssistColor;
    }];
    
    
    UIView * markView = [[UIView alloc]init];
    [ppBtn1 addSubview:markView];
    self.markView = markView;
    markView.hidden = YES;
    markView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UILabel * tishiLabel = [[UILabel alloc]init];
    [markView addSubview:tishiLabel];
    tishiLabel.textColor = kBackAssistColor;
    tishiLabel.font = H13;
    tishiLabel.text = kLocalizedString(@"以当前市场价格交易");
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    UILabel * cnyLabel = [[UILabel alloc]init];
    [self addSubview:cnyLabel];
    self.cnyLabel = cnyLabel;
    cnyLabel.textColor = k99999Color;
    cnyLabel.font = H10;
    //cnyLabel.text = @"≈67.5650 CNY";
    [cnyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(ppBtn1);
        make.top.mas_equalTo(ppBtn1.mas_bottom).offset(Adapted(12));
    }];
    
    PPNumberButton * ppBtn2 = [[PPNumberButton alloc]initWithFrame:CGRectZero inputType:2];
    [self addSubview:ppBtn2];
    self.ppBtn2 = ppBtn2;
    ppBtn2.minValue = 0;

    [ppBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(ppBtn1.mas_bottom).offset(Adapted(39));
        make.height.mas_equalTo(Adapted(46));
    }];

    ppBtn2.increaseImage = [UIImage imageNamed:@"jiahao2"];
    ppBtn2.decreaseImage = [UIImage imageNamed:@"jianhao2"];
    //ppBtn2.textField.adjustsFontSizeToFitWidth = YES;
    ppBtn2.textField.textColor = kTextColor;
    ppBtn2.textField.font = H14;
    ViewBorderRadius(ppBtn2, 0, 1, kLineColor);
    ppBtn2.resultBlock = ^(float num ,BOOL increaseStatus){
        @strongify(self);
        //总交易额
        self.turnoverLabel.text = [NSString stringWithFormat:@"交易额: %.2f %@",num*self.ppBtn1.currentNumber,self.markStr];
        self.slider.value = num;
        [self configData];
        
    };
    
 
    
    UILabel * btcLabel = [[UILabel alloc]init];
    [self addSubview:btcLabel];
    self.btcLabel = btcLabel;
    btcLabel.textColor = k99999Color;;
    btcLabel.font = H12;
    [btcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(ppBtn1);
        make.top.mas_equalTo(ppBtn2.mas_bottom).offset(Adapted(12));
    }];
    
    //冒泡POP
    self.progressView = [[ASProgressPopUpView alloc]init];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(btcLabel.mas_bottom).offset(Adapted(35));
        make.height.mas_equalTo(Adapted(1));
    }];
    self.progressView.popUpViewCornerRadius = 12.0;
    self.progressView.font = H24;
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.popUpViewColor = [UIColor colorWithHexString:@"#2b2c2f" alpha:0.9];
    [self.progressView hidePopUpViewAnimated:NO];
    
    TWSlider * slider = [[TWSlider alloc]init];
    [self addSubview:slider];
    self.slider = slider;
    slider.value = 0;
    //slider.maximumValue = 6588.86952381;
    slider.minimumValue = 0;
    slider.minimumTrackTintColor = kGreenColor;
    [self.slider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(btcLabel.mas_bottom).offset(Adapted(30));
        make.height.mas_equalTo(Adapted(10));
    }];
    
    //slider 值改变
    [self.slider addTarget:self action:@selector(sliderProgressChange:) forControlEvents:UIControlEventValueChanged];
    //slider 促发开始
    [self.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    //slider 促发结束
    [self.slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];

    
    
    UILabel * minLabel = [[UILabel alloc]init];
    [self addSubview:minLabel];
    self.minLabel = minLabel;
    minLabel.textColor = k99999Color;
    minLabel.font = H11;
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.width.mas_equalTo(Adapted(80));
        make.top.mas_equalTo(slider.mas_bottom).offset(Adapted(15));
    }];
    
    UILabel * maxLabel = [[UILabel alloc]init];
    [self addSubview:maxLabel];
    self.maxLabel = maxLabel;
    maxLabel.textColor = k99999Color;
    maxLabel.font = H11;
    maxLabel.numberOfLines = 0;
    //maxLabel.text = @"6588.8695 BYC";
    maxLabel.textAlignment = NSTextAlignmentRight;
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-12));
        make.left.mas_equalTo(Adapted(30));
        make.top.mas_equalTo(slider.mas_bottom).offset(Adapted(15));
    }];
    
    UILabel * turnoverLabel = [[UILabel alloc]init];
    [self addSubview:turnoverLabel];
    self.turnoverLabel = turnoverLabel;
    turnoverLabel.textColor = k99999Color;;
    turnoverLabel.font = H13;
    turnoverLabel.text = kLocalizedString(@"交易额:");
    [turnoverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(slider.mas_bottom).offset(Adapted(50));
    }];
    
    TWButton * nextBtn = [TWButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    [nextBtn setBackgroundImage:[UIImage imageWithColor:kGreenColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageWithColor:kRedColor] forState:UIControlStateSelected];;
    [nextBtn setTitle:kLocalizedString(@"买入") forState:UIControlStateNormal];
    [nextBtn setTitle:kLocalizedString(@"卖出") forState:UIControlStateSelected];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(turnoverLabel.mas_bottom).offset(Adapted(10));
        make.width.mas_equalTo(Adapted(176));
        make.height.mas_equalTo(Adapted(43));
    }];
    ViewRadius(nextBtn, 2);
    
    [RACObserve(self.nextBtn, selected) subscribeNext:^(id x) {
        self.progressView.popUpViewColor = self.nextBtn.selected ? kRedColor : kGreenColor;
    }];
    
}
- (double)availableBalanceFloat
{
    return [[self.availableBalance keepDecimal:6] floatValue];
}
//通知传值
- (void)getPriceValue:(NSNotification *)noti{
    
    NSString * price = noti.object;
    self.ppBtn1.textField.text = price;
    
}

//滑块值改变
-(void)sliderProgressChange:(UISlider *)slid{
    float progress = slid.value/self.slider.maximumValue;
    if(slid.value>0){
        [self.progressView setProgress:progress animated:YES];
    }
    if ([self availableBalanceFloat]<=0) {
        return;
    }
    self.ppBtn2.textField.text = [[NSString stringWithFormat:@"%.20f",slid.value] keepDecimal:[self.ppBtn2.textField.limitDecimalDigitLength integerValue]];
    
    self.turnoverLabel.text = [NSString stringWithFormat:@"%@ %.2f %@",kLocalizedString(@"交易额:"),slid.value*self.ppBtn1.currentNumber,self.markStr];

    if(self.ppBtn2.currentNumber>self.slider.maximumValue){
        self.ppBtn2.textField.text = [[NSString stringWithFormat:@"%.20f",self.slider.maximumValue] keepDecimal:[self.ppBtn2.textField.limitDecimalDigitLength integerValue]];
    }
    
    [self configData];
    
    
}

//根据市价限价和买入卖出配置联动信息
-(void)configData{
    
    if(self.buyOrSell == 1){
        
        self.btcLabel.text = [NSString stringWithFormat:@"%@:%@ %@",kLocalizedString(@"可用"),kNotNumber([self.availableBalance keepDecimal:8]),kNotNull(self.markStr)];
        
        if(self.buyLimitType == 0){//限价
            if([self.ppBtn1.textField.text floatValue]>0){
                if ([kNotNumber([self.availableBalance keepDecimal:8]) floatValue]/[self.ppBtn1.textField.text floatValue]>0) {
                    self.slider.maximumValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue]/[[self.ppBtn1.textField.text keepDecimal:8] floatValue];
                }

                self.maxLabel.text = [NSString stringWithFormat:@"%.8f %@",[kNotNumber([self.availableBalance keepDecimal:8]) floatValue]/[[self.ppBtn1.textField.text keepDecimal:8] floatValue],kNotNull(self.trCode)];
            }


            self.minLabel.text = @"0";
            self.ppBtn2.maxValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue]/[[self.ppBtn1.textField.text keepDecimal:8] floatValue];

            if([self.ppBtn2.textField.text floatValue] == 0){
                self.ppBtn2.textField.text = @"";
                self.ppBtn2.textField.placeholder = [NSString stringWithFormat:@"(%@)%@",kNotNull(self.trCode),kLocalizedString(@"数量")];
            }
        }else{//市价


            if ([kNotNumber(self.availableBalance) floatValue]) {
                self.slider.maximumValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue];
            }
            self.maxLabel.text = [NSString stringWithFormat:@"%@ %@",kNotNumber([self.availableBalance keepDecimal:8]),kNotNull(self.markStr)];
            self.minLabel.text = @"0";
            self.ppBtn2.maxValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue];

            if([self.ppBtn2.textField.text floatValue] == 0){
                self.ppBtn2.textField.text = @"";
                self.ppBtn2.textField.placeholder = [NSString stringWithFormat:@"(%@)%@",kNotNull(self.markStr),kLocalizedString(@"数量")];
            }
        }
        
        
        
        
    }else{//卖出
     
        self.btcLabel.text = [NSString stringWithFormat:@"%@%@:%@",kLocalizedString(@"可用"),kNotNull(self.trCode),kNotNumber([self.availableBalance keepDecimal:8])];
        
        if ([kNotNumber(self.availableBalance) floatValue]>0) {
            self.slider.maximumValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue];
        }
            
        self.maxLabel.text = [NSString stringWithFormat:@"%@ %@",kNotNumber([self.availableBalance keepDecimal:8]),kNotNull(self.trCode)];
            
        self.ppBtn2.maxValue = [kNotNumber([self.availableBalance keepDecimal:8]) floatValue];
        self.minLabel.text = @"0";
    
        if([self.ppBtn2.textField.text floatValue] == 0){
            self.ppBtn2.textField.text = @"";
            self.ppBtn2.textField.placeholder = [NSString stringWithFormat:@"(%@)%@",kNotNull(self.trCode),kLocalizedString(@"数量")];
           
        }
    }
    if (self.slider.maximumValue == 0) {
        self.slider.maximumValue = 1.0;
    }
}

// slider 按下去
-(void)sliderTouchDown:(UISlider *)slid{
    if(slid.maximumValue>0){
        [self.progressView showPopUpViewAnimated:YES];
    }else{
        [self.progressView hidePopUpViewAnimated:YES];
    }
    
}

//slider 结束
-(void)sliderTouchUpInSide:(UISlider *)slid{
    [self.progressView hidePopUpViewAnimated:YES];
}


-(void)setTrCode:(NSString *)trCode{
    if(kStringIsEmpty(trCode)){
        _trCode = @"";
    }
    _trCode = trCode;
}

-(void)setMarkStr:(NSString *)markStr{
    if(kStringIsEmpty(markStr)){
        _markStr = @"";
    }
    _markStr = markStr;
}

-(void)setModel:(QuotesModel *)model{
    _model = model;
    //改变估值 重新计算余额 和 单价估值
    self.ppBtn1.textField.text = self.text1Value;
    
}

-(NSString *)availableBalance{
    if(kStringIsEmpty(_availableBalance)){
        _availableBalance = @"0";
    }
    return _availableBalance;
}

@end
