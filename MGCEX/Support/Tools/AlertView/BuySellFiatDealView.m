// MGC
//
// BuySellFiatDealView.m
// MGCEX
//
// Created by MGC on 2018/5/25.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "BuySellFiatDealView.h"


@interface BuySellFiatDealView()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView * toView;
@property (nonatomic, strong) FiatDealBuyOrSellModel * mode;
@property (nonatomic, assign) float alertWidth;
@property (nonatomic, assign) float subWidth;

@property (nonatomic, strong) UITextField * textFiled1;
@property (nonatomic, strong) UITextField * textFiled2;
@property (nonatomic, strong) NSNumber * maxNumber;//交易的最大个数
@property (nonatomic, strong) NSNumber * minNumber;//交易的最小个数
@property (nonatomic, strong) NSNumber * maxMoney;//交易的最大金钱
@property (nonatomic, strong) NSNumber * minMoney;//交易的最小金钱
@end

@implementation BuySellFiatDealView

-(instancetype)initWithSupView:(UIView *)toView model:(FiatDealBuyOrSellModel *)model sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock{
    
    self=[super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.toView = toView;
        self.mode = model;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        self.alertWidth = Adapted(303);
        self.subWidth = (self.alertWidth-Adapted(24)-Adapted(4))/2.0;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(Adapted(-64));
            make.width.mas_equalTo(self.alertWidth);
            make.height.mas_equalTo(Adapted(350));
        }];
        
        UIView * headView = [[UIView alloc]init];
        [self.alertView addSubview:headView];
        headView.backgroundColor = UIColorFromRGB(0xf3efef);
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.alertView);
            make.height.mas_equalTo(Adapted(44));
        }];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kBackAssistColor;
        titleLabel.font = H15;
        NSString * buyStr = kLocalizedString(@"买入");
        NSString * sellStr  = kLocalizedString(@"卖出");
        titleLabel.text = model.isBuy? [NSString stringWithFormat:@"%@%@",buyStr,model.currency] :[NSString stringWithFormat:@"%@%@",sellStr,model.currency];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(40));
            make.right.mas_equalTo(Adapted(-40));
            make.centerY.mas_equalTo(headView);
        }];
        
        UIButton * cancelBtn = [UIButton buttonWithType:0];
        [headView addSubview:cancelBtn];
        [cancelBtn setImage:IMAGE(@"guanbi") forState:UIControlStateNormal];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView);
            make.width.height.mas_equalTo(Adapted(40));
            make.centerY.mas_equalTo(headView);
        }];
        @weakify(self);
        [cancelBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(cancelBlock){
                cancelBlock();
            }
            [self hidden];
        }];
        
        //公司名称
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        msgLabel.textColor = kBackAssistColor;
        msgLabel.text = model.title;
        msgLabel.font = H15;
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(17));
            
            
        }];
        
        
        //VIP
        
        UIImageView * vipImageV = [[UIImageView alloc]init];
        [self.alertView addSubview:vipImageV];
        vipImageV.image = IMAGE(@"sjrz");
        [vipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.left.mas_equalTo(msgLabel.mas_right).offset(Adapted(5));
            make.centerY.mas_equalTo(msgLabel);
            make.width.mas_equalTo(Adapted(16));
            make.height.mas_equalTo(Adapted(12));
        }];
        
        
        
        //左----
        UILabel * leftLabel = [[UILabel alloc]init];
        [self.alertView addSubview:leftLabel];
        leftLabel.textColor = model.isBuy? kGreenColor:kRedColor;
        leftLabel.font = H13;
        leftLabel.text = model.unitPrice;
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(Adapted(10));
            make.width.mas_equalTo(self.subWidth);
        }];
        
        
        UILabel * subLeftLabel = [[UILabel alloc]init];
        [self.alertView addSubview:subLeftLabel];
        subLeftLabel.textColor = k99999Color;
        subLeftLabel.font = H11;
        subLeftLabel.text = kLocalizedString(@"单位(CNY)");
        [subLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftLabel);
            make.top.mas_equalTo(leftLabel.mas_bottom).offset(Adapted(6));
            make.width.mas_equalTo(self.subWidth);
        }];
        
        //右----
        UILabel * rightLabel = [[UILabel alloc]init];
        [self.alertView addSubview:rightLabel];
        rightLabel.textColor = kBackAssistColor;
        rightLabel.font = H13;
        rightLabel.text = [NSString stringWithFormat:@"%@~%@",model.limitMin,model.limitMax];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(Adapted(-15));
            make.top.mas_equalTo(leftLabel);
            make.width.mas_equalTo(self.subWidth);
        }];
        
        
        UILabel * subRightLabel = [[UILabel alloc]init];
        [self.alertView addSubview:subRightLabel];
        subRightLabel.textColor = k99999Color;
        subRightLabel.font = H11;
        subRightLabel.text = kLocalizedString(@"单笔限额(CNY)");
        subRightLabel.textAlignment = NSTextAlignmentRight;
        [subRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(Adapted(-15));
            make.top.mas_equalTo(subLeftLabel);
            make.width.mas_equalTo(self.subWidth);
        }];
        
        UILabel * payLabel = [[UILabel alloc]init];
        [self.alertView addSubview:payLabel];
        payLabel.font = H13;
        payLabel.textColor = k99999Color;
        payLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"支付:"), model.payString];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(subRightLabel.mas_bottom).offset(Adapted(16));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-12));
        }];
        
        //下划线
        UIView * line1 = [[UIView alloc]init];
        [self.alertView addSubview:line1];
        line1.backgroundColor = model.isBuy? kGreenColor:kRedColor;
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.right.mas_equalTo(Adapted(-12));
            make.top.mas_equalTo(payLabel.mas_bottom).offset(Adapted(44));
            make.height.mas_equalTo(1);
        }];
        
        //单位
        UILabel * danwei1 = [[UILabel alloc]init];
        [self.alertView addSubview:danwei1];
        danwei1.text = @"CNY";
        danwei1.textAlignment = NSTextAlignmentRight;
        danwei1.textColor = k99999Color;
        danwei1.font = H13;
        [danwei1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(line1).offset(Adapted(-10));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-12));
            make.width.mas_equalTo([UIView getLabelWidthByHeight:20 Title:danwei1.text font:H13]);
        }];
        
        
        //人民币
        UITextField * textField1 = [[UITextField alloc]init];
        [self.alertView addSubview:textField1];
        [textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.right.mas_equalTo(danwei1.mas_left).offset(Adapted(-15));
            make.height.mas_equalTo(Adapted(44));
            make.bottom.mas_equalTo(line1).offset(8);
        }];
        textField1.textColor = kBackAssistColor;
        textField1.keyboardType = UIKeyboardTypeDecimalPad;
    textField1.limitDecimalDigitLength = s_Integer(2);
        self.textFiled1 = textField1;
    
        
        textField1.endEditBlock = ^(NSString *text) {
            if(kStringIsEmpty(text))  text = @"0";
            if(text.length>0){
                NSString *last = [text substringFromIndex:text.length-1];
                if([last isEqualToString:@"."]){
                    self.textFiled1.text = [text substringToIndex:([text length]-1)];
                    
                }
            }
            
            
        };

        textField1.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            
            if(kStringIsEmpty(text))  text = @"0";
            
            if([SNSub(text, self.maxMoney) doubleValue]>0){
                
                //self.textFiled1.textColor = kRedColor;
                
            }else if ([SNSub(self.minMoney, text) doubleValue]>0){
                //self.textFiled1.textColor = kRedColor;
                
            }else{
                //self.textFiled1.textColor = kBackAssistColor;
                
            }
            
            self.textFiled2.text = [NSString stringWithFormat:@"%@",handlerDecimalNumber(SNDiv(text, self.mode.unitPrice ), NSRoundDown, 8)];

        };
        
        //下划线
        UIView * line2 = [[UIView alloc]init];
        [self.alertView addSubview:line2];
        line2.backgroundColor = model.isBuy? kGreenColor:kRedColor;
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.right.mas_equalTo(Adapted(-12));
            make.top.mas_equalTo(line1.mas_bottom).offset(Adapted(44));
            make.height.mas_equalTo(1);
        }];
        
        //单位
        UILabel * danwei2 = [[UILabel alloc]init];
        [self.alertView addSubview:danwei2];
        danwei2.text = model.currency;
        danwei2.textAlignment = NSTextAlignmentRight;
        danwei2.textColor = k99999Color;
        danwei2.font = H13;
        [danwei2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(line2).offset(Adapted(-10));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-12));
            make.width.mas_equalTo([UIView getLabelWidthByHeight:20 Title:danwei2.text font:H13]);
        }];
        
        //币种
        UITextField * textField2 = [[UITextField alloc]init];
        [self.alertView addSubview:textField2];
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.right.mas_equalTo(danwei2.mas_left).offset(Adapted(-15));
            make.height.mas_equalTo(Adapted(44));
            make.bottom.mas_equalTo(line2).offset(8);
        }];
        textField2.textColor = kBackAssistColor;
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.limitDecimalDigitLength = s_Integer(8);
        self.textFiled2 = textField2;
        
        textField2.endEditBlock = ^(NSString *text) {
            if(kStringIsEmpty(text))  text = @"0";
            
            if(text.length>0){
                NSString *last = [text substringFromIndex:text.length-1];
                if([last isEqualToString:@"."]){
                    self.textFiled2.text = [text substringToIndex:([text length]-1)];
                    
                }
            }
            
            
        };
        
        textField2.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            if(kStringIsEmpty(text))  text = @"0";
            
            if([SNSub(self.minNumber, text) doubleValue]>0){
                //self.textFiled2.textColor = kRedColor;
                
            }else if ([SNSub(text, self.maxNumber) doubleValue]>0){
                //self.textFiled2.textColor = kRedColor;
                
            }else{
                //self.textFiled2.textColor = kBackAssistColor;
            }
            
            self.textFiled1.text = [NSString stringWithFormat:@"%@",handlerDecimalNumber(SNMul(text, self.mode.unitPrice), NSRoundPlain, 2)];
            
        };
        
        
        UILabel * hintLabel = [[UILabel alloc]init];
        [self.alertView addSubview:hintLabel];
        hintLabel.font = H13;
        hintLabel.textColor = k99999Color;
        hintLabel.text = kLocalizedString(@"从点击'下单'开始,该订单时限为20分钟");
        hintLabel.numberOfLines = 0;
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(12));
            make.top.mas_equalTo(line2.mas_bottom).offset(Adapted(10));
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-12));
        }];
        
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:nextBtn];
        nextBtn.clipsToBounds = YES;
        nextBtn.layer.cornerRadius = Adapted(18);
        [nextBtn setBackgroundColor:model.isBuy?kGreenColor:kRedColor forState:UIControlStateNormal];
        [nextBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.top.mas_equalTo(hintLabel.mas_bottom).offset(Adapted(20));
            make.width.mas_equalTo(Adapted(200));
            make.height.mas_equalTo(Adapted(36));
        }];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.sure_block = sureBlock;
        
        [self limitMaxOrMin];
    }
    return self;
}

- (void)limitMaxOrMin{
    
    self.minNumber = SNDiv(self.mode.limitMin, self.mode.unitPrice);
    self.maxNumber = SNDiv(self.mode.limitMax, self.mode.unitPrice);
    self.maxNumber = SNMin(self.mode.number, self.maxNumber);//最大买入量和持有量取小
    self.minNumber = SNMin(self.mode.number, self.minNumber);//最小买入量和持有量取小
   
    
    self.minMoney = SNMul(self.minNumber, self.mode.unitPrice);//最小买入量乘以单价;
    self.maxMoney = SNMul(self.maxNumber, self.mode.unitPrice);//最大买入量乘以单价;
    self.minMoney = SNMin(self.mode.limitMin, self.minMoney);//限额最小和卖家能卖的额度取小
    self.maxMoney = SNMin(self.mode.limitMax, self.maxMoney);//限额最大和卖家能卖的额度取小
    
    
    self.textFiled1.text = [NSString stringWithFormat:@"%@",handlerDecimalNumber(self.maxMoney, NSRoundDown, 2)];
    self.textFiled2.text = [NSString stringWithFormat:@"%@",handlerDecimalNumber(self.maxNumber, NSRoundDown, 8)];//保留8位小数
  
}

-(void)nextBtnClick{
    
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(self.textFiled1.text.length==0||self.textFiled2.text.length==0){
        
        [TTWHUD showCustomMsg:kLocalizedString(@"请填写完成信息")];
        return;
    }else if([SNSub(self.textFiled1.text, handlerDecimalNumber(self.maxMoney, NSRoundPlain, 2)) doubleValue]>0){
        
        [TTWHUD showCustomMsg:kLocalizedString(@"下单价不能超出单笔限额")];
        [self.textFiled1 shake];
        return;
        
    }else if ([SNSub(handlerDecimalNumber(self.minMoney, NSRoundPlain, 2), self.textFiled1.text) doubleValue]>0){
        [TTWHUD showCustomMsg:kLocalizedString(@"下单价不能低于单笔限额")];
        [self.textFiled1 shake];
        return;
    }
    
    if(self.sure_block){
        self.sure_block(self.textFiled1.text, self.textFiled2.text, self.mode.currency);
        
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)show
{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    
    [self.toView addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alertView.alpha = 1;
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)hidden{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}


@end
