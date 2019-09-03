// MGC
//
// FiatTradingHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTradingHeadView.h"
#import "UILabel+TWAttribute.h"


@interface FiatTradingHeadView()
@property (nonatomic, strong) UILabel * timoutLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation FiatTradingHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    UIImageView * heaImageV = [[UIImageView alloc]init];
    [self addSubview:heaImageV];
    [heaImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    heaImageV.image = IMAGE(@"jyzt_bg");
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.font = H18;
    titleLabel.textColor = white_color;
    titleLabel.text = @"";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(35));
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.top.mas_equalTo(Adapted(25));
    }];
    /*
    UIView * frontView = [[UIView alloc]init];
    [self addSubview:frontView];
    self.frontView = frontView;
    frontView.backgroundColor = white_color;
    [frontView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-12));
        make.height.mas_equalTo(Adapted(71));
        make.top.mas_equalTo(self).offset(Adapted(62));
    }];
    [frontView shadow:UIColorFromRGB(0x240a0a) opacity:0.3 radius:5 offset:CGSizeMake(Adapted(6), Adapted(3))];
     */
    //倒计时
    UILabel * timoutLabel = [[UILabel alloc]init];
    [self addSubview:timoutLabel];
    timoutLabel.numberOfLines = 0;
    self.timoutLabel = timoutLabel;
    [timoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(35));
        make.right.mas_equalTo(Adapted(-35));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(15));
    }];
    /*
    //后台返回的内容
    UILabel * msgLabel = [[UILabel alloc]init];
    [frontView addSubview:msgLabel];
    msgLabel.numberOfLines = 0;
    msgLabel.textColor = kBackAssistColor;
    msgLabel.font = H15;
    self.msgLabel = msgLabel;
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(frontView.mas_right).offset(Adapted(-12));
        make.top.mas_equalTo(timoutLabel.mas_bottom).offset(Adapted(5));
    }];
     */
}

- (void)setModel:(FiatTradingModel *)model{
    _model = model;
    
//#ifdef DEBUG
//    model.reTime = @"0";
//#endif
    
    if(self.timer){
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    //订单状态
    self.titleLabel.text = [NSString stringWithFormat:@"%@:%@",kLocalizedString(@"交易状态"),model.tradeStatusString];
    
    if([model.buysell integerValue]){//买家
        //未支付
        if([model.reTime integerValue] >0){
            //还没有到时间
            [self openCountdownWithTimeout:[model.reTime integerValue]];
            
        }else{
            //到时间
            self.timoutLabel.text = nil;
        }
        
        self.msgLabel.text = model.promptRed;
        
    }else{//卖家
        //未支付
        if([model.reTime integerValue] >0){
            //还没有到时间
            [self openCountdownWithTimeout:[model.reTime integerValue]];
            
        }else{
            //到时间
            self.timoutLabel.text = nil;
        }
        
        self.msgLabel.text = model.promptRed;
    }
    
}

// 开启倒计时效果

- (void)openCountdownWithTimeout:(NSInteger )timeout {
    
    
    __block NSInteger time = timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.timer, ^{
        
        if(time < 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self.timer);
            
          
        }else{
            
            NSString * timeStr =[NSString stringWithFormat:@" %.2ld分 %.2ld秒",time/60,time%60];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray * arrayText = @[kLocalizedString(@"交易时限:"),timeStr];
                NSArray * arrayFont = @[H18,H18];
                NSArray * arrayColor = @[white_color,white_color];
                NSAttributedString * att = [UILabel mg_attributedTextArray:arrayText textColors:arrayColor textfonts:arrayFont];
                self.self.timoutLabel.attributedText = att;
                
            });
            
            self.complaintsTimeout = time;
            time--;
        }
    });
    
    dispatch_resume(self.timer);
}

-(void)dealloc{

    [self deleTimer];

}

//销毁定时器
-(void)deleTimer{
    if(self.timer){
        //销毁定时器
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
}
@end
