// MGC
//
// FiatDealHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatDealHeadView.h"
#import "CustomSegmentedView.h"

@interface FiatDealHeadView()
@property (nonatomic, strong) CustomSegmentedView * segMentview;
@end

@implementation FiatDealHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self setUpTopViews];
        [self setUpBottomViews];
    }
    return self;
}

-(void)setUpTopViews{
    self.backgroundColor = kBackAssistColor;
    
    QSButton * leftBtn = [QSButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:leftBtn];
    self.leftBtn = leftBtn;
    leftBtn.style = QSButtonImageStyleRight;
    leftBtn.space = Adapted(5);
    [leftBtn setImage:IMAGE(@"coinDeal_down") forState:UIControlStateNormal];
    [leftBtn setImage:IMAGE(@"coinDeal_up") forState:UIControlStateSelected];
    [leftBtn setTitle:@"KBC/CNY" forState:UIControlStateNormal];
    [leftBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    leftBtn.titleLabel.font = H15;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(48));
        make.width.mas_equalTo(10);
    }];
    [leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIView getLabelWidthByHeight:Adapted(20) Title:@"KBC/CNY" font:H15]+Adapted(20));
    }];
    [leftBtn addTarget:self action:@selector(selectLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * rightLabel = [[UILabel alloc]init];
    [self addSubview:rightLabel];
    rightLabel.textColor = kTextColor;
    rightLabel.font = H15;
    rightLabel.text = @"";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-12));
        make.centerY.mas_equalTo(leftBtn);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
        
    }];
    self.rightLabel = rightLabel;
}


-(void)setUpBottomViews{
    
    UIView * bottomBackView = [[UIView alloc]init];
    [self addSubview:bottomBackView];
    bottomBackView.backgroundColor = kBackGroundColor;
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(Adapted(48));
    }];
    
    NSArray * segArr = @[kLocalizedString(@"买入"),kLocalizedString(@"卖出")];
    self.segMentview = [[CustomSegmentedView alloc]initWithSegmentArr:segArr frame:CGRectMake(0, 0, Adapted(180), KFiatDealSectionHeight)];
    self.segMentview.segmentColor = kBackGroundColor;
    self.segMentview.segLabel1.textColor = kGreenColor;
    self.segMentview.slidView.backgroundColor = kGreenColor;
    self.segMentview.backView.backgroundColor = kBackGroundColor;
    [bottomBackView addSubview:self.segMentview];
    @weakify(self);
    self.segMentview.segmentCallBlock = ^(NSInteger index,UILabel * label) {
        @strongify(self);
        switch (index) {
            case 0:{
                self.segMentview.segLabel1.textColor = kGreenColor;
                self.segMentview.segLabel2.textColor = k99999Color;
                self.segMentview.slidView.backgroundColor = kGreenColor;
                
                if([self.btnDelegate respondsToSelector:@selector(selectSegmentWithIndex:)]){
                    [self.btnDelegate selectSegmentWithIndex:2];
                }
                
            }
                break;
            case 1:{
                self.segMentview.segLabel1.textColor = k99999Color;
                self.segMentview.segLabel2.textColor = kRedColor;
                self.segMentview.slidView.backgroundColor = kRedColor;
                
                if([self.btnDelegate respondsToSelector:@selector(selectSegmentWithIndex:)]){
                    [self.btnDelegate selectSegmentWithIndex:1];
                }
                
            }
                
                
            default:
                break;
        }
    };
    
    UIButton * tradingRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBackView addSubview:tradingRecordBtn];
    [tradingRecordBtn setTitle:string(kLocalizedString(@"交易记录"), @"  >")  forState:UIControlStateNormal];
    [tradingRecordBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    tradingRecordBtn.titleLabel.font = H15;
    tradingRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [tradingRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.segMentview);
        make.right.mas_offset(Adapted(-10));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
        make.height.mas_equalTo(Adapted(48));
    }];
    [tradingRecordBtn addTarget:self action:@selector(TransactionRecordsClick) forControlEvents:UIControlEventTouchUpInside];
}


-(void)TransactionRecordsClick{
    if([self.btnDelegate respondsToSelector:@selector(transactionRecords)]){
        [self.btnDelegate transactionRecords];
    }
}


-(void)selectLeftClick:(UIButton *)btn{
    btn.selected = !btn.selected;
   
    if([self.btnDelegate respondsToSelector:@selector(sendFrameValue:)]){
        [self.btnDelegate sendFrameValue:self];
    }
    
}

@end
