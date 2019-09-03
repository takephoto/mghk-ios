//
//  PlaceOrderVC.m
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "PlaceOrderVC.h"
#import "BuyFialDealTableViewCell.h"
#import "PlaceOrderHeader.h"
#import "PlaceOrderVM.h"
#import "FiatTradingVC.h"
#import "PlaceOrderItemModel.h"

@interface PlaceOrderVC ()
@property (nonatomic, strong) PlaceOrderHeader *header;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) NSMutableArray *dataM;
@property (nonatomic, strong) PlaceOrderVM *viewModel;

@property (nonatomic, strong) NSNumber * maxNumber;//交易的最大个数
@property (nonatomic, strong) NSNumber * minNumber;//交易的最小个数
@property (nonatomic, strong) NSNumber * maxMoney;//交易的最大金钱
@property (nonatomic, strong) NSNumber * minMoney;//交易的最小金钱
@end

@implementation PlaceOrderVC

- (void)viewDidLoad{

    [super viewDidLoad];
    self.title = string(self.isBuy ? kLocalizedString(@"买入") : kLocalizedString(@"卖出"), self.model.currency);
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    self.header.model = self.model;
    self.tableView.separatorColor = kLineColor;
    self.tableView.backgroundColor = white_color;
    [self.tableView registerClass:[BuyFialDealTableViewCell class] forCellReuseIdentifier:@"BuyFialCell"];
}

- (void)bindViewModel{
    
    self.viewModel.isBuy = self.isBuy;
    self.viewModel.model = self.model;
    
    [self.viewModel.getDataSignal subscribeNext:^(id x) {
        self.dataM = x;
        [self.tableView reloadData];
    }];
    [self limitMaxOrMin];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuyFialDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyFialCell"];
    if(!cell){
        cell = [[BuyFialDealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuyFialCell"];
    }
     cell.model = self.dataM[indexPath.row];
    cell.enterBlock = ^(NSString *text) {
        
        if(kStringIsEmpty(text)) text = @"0";
        if(indexPath.row == 2){//兑换金额
            
            PlaceOrderItemModel *model = self.dataM[3];
            model.content = [NSString stringWithFormat:@"%@",handlerDecimalNumber(SNDiv(text, self.model.unitPrice), NSRoundDown, 8)];
        }else if(indexPath.row == 3){//卖出/买入 数量
            
            PlaceOrderItemModel *model = self.dataM[2];
            model.content = [NSString stringWithFormat:@"%@",handlerDecimalNumber(SNMul(text, self.model.unitPrice), NSRoundDown, 2)];
        }
        
    };
    cell.endEditBlock = ^(NSString *text) {
        if(kStringIsEmpty(text))  text = @"0";
      
        PlaceOrderItemModel *model = self.dataM[indexPath.row];
        model.content = text;
        
        if(text.length>0){
            NSString *last = [text substringFromIndex:text.length-1];
            if([last isEqualToString:@"."]){
                
                PlaceOrderItemModel *model = self.dataM[indexPath.row];
                model.content = [text substringToIndex:([text length]-1)];
            }
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuyFialDealTableViewCell *tCell = (BuyFialDealTableViewCell *)cell;
    if (indexPath.row < 2) {
        tCell.separatorColor = kLineColor;
    } else {
        tCell.separatorColor = self.isBuy ? kGreenColor : kRedColor;
        
        UITextField *textField = [tCell valueForKey:@"_textField"];
        if(indexPath.row == 2) textField.limitDecimalDigitLength = @"2";
        if(indexPath.row == 3) textField.limitDecimalDigitLength = @"8";
    }
    
}

#pragma mark - Private
- (void)limitMaxOrMin{
    
    self.minNumber = SNDiv(self.model.limitMin, self.model.unitPrice);
    self.maxNumber = SNDiv(self.model.limitMax, self.model.unitPrice);
    self.maxNumber = SNMin(self.model.number, self.maxNumber);//最大买入量和持有量取小
    self.minNumber = SNMin(self.model.number, self.minNumber);//最小买入量和持有量取小
    
    self.minMoney = SNMul(self.minNumber, self.model.unitPrice);//最小买入量乘以单价;
    self.maxMoney = SNMul(self.maxNumber, self.model.unitPrice);//最大买入量乘以单价;
    self.minMoney = SNMin(self.model.limitMin, self.minMoney);//限额最小和卖家能卖的额度取小
    self.maxMoney = SNMin(self.model.limitMax, self.maxMoney);//限额最大和卖家能卖的额度取小
    
    
    PlaceOrderItemModel *amountModel = self.dataM[2];
    amountModel.content = [NSString stringWithFormat:@"%@",handlerDecimalNumber(self.maxMoney, NSRoundDown, 2)];
    PlaceOrderItemModel *countModel = self.dataM[3];
    countModel.content =  [NSString stringWithFormat:@"%@",handlerDecimalNumber(self.maxNumber, NSRoundDown, 8)];//保留8位小数
}

- (void)orderClickRequest:(NSString *)buySell tradeAmount:(NSString *)tradeAmount tradeQuantity:(NSString *)tradeQuantity tradeCode:(NSString *)tradeCode advertisingOrderId:(NSString *)advertisingOrderId adUserId:(NSString *)adUserId{
    
    self.viewModel.orderBuysell = buySell;
    self.viewModel.orderTradeAmount = tradeAmount;
    self.viewModel.orderTradeQuantity = tradeQuantity;
    self.viewModel.orderTradeCode = tradeCode;
    self.viewModel.orderAdvertisingOrderId = advertisingOrderId;
    self.viewModel.adUserId = adUserId;
    self.viewModel.payBuySell = buySell;
    //订阅信号
    @weakify(self);
    [self.viewModel.orderSignal subscribeNext:^(NSString * orderId) {
        @strongify(self);
        [TTWHUD showCustomMsg:kLocalizedString(@"操作成功")];
        
        
        FiatTradingVC * vc = [[FiatTradingVC alloc]init];
        vc.tradeOrderId = orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

#pragma mark - LazyLoad
- (PlaceOrderHeader *)header{
    
    if (!_header) {
        _header = [[PlaceOrderHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(60))];
    }
    return _header;
}

- (UIView *)footer{
    
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(120))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footer addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(Adapted(21));
            make.left.mas_offset(Adapted(15));
            make.right.mas_offset(Adapted(-15));
            make.height.mas_offset(Adapted(60));
        }];
        [btn setTitle:self.isBuy ? kLocalizedString(@"立即买入") : kLocalizedString(@"立即卖出") forState:UIControlStateNormal];
        [btn setTitleColor:white_color forState:UIControlStateNormal];
        btn.titleLabel.font = H18;
        btn.backgroundColor = self.isBuy ? kGreenColor : kRedColor;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [self.view endEditing:YES];
            
            PlaceOrderItemModel *amountModel = self.dataM[2];
            PlaceOrderItemModel *countModel = self.dataM[3];
            if(amountModel.content.length==0 || countModel.content.length==0){
                
                [TTWHUD showCustomMsg:kLocalizedString(@"请填写完成信息")];
                return;
            }else if([SNSub(amountModel.content, handlerDecimalNumber(self.maxMoney, NSRoundPlain, 2)) doubleValue]>0){
                
                [TTWHUD showCustomMsg:kLocalizedString(@"下单价不能超出单笔限额")];
                return;
                
            }else if ([SNSub(handlerDecimalNumber(self.minMoney, NSRoundPlain, 2), amountModel.content) doubleValue]>0){
                [TTWHUD showCustomMsg:kLocalizedString(@"下单价不能低于单笔限额")];
                return;
            }
            
            NSString *type = self.isBuy ? @"1" : @"2";
            
            [self orderClickRequest:type tradeAmount:amountModel.content tradeQuantity:countModel.content tradeCode:self.model.currency advertisingOrderId:self.model.advertisingOrderId adUserId:self.model.adUserId];
            
        }];
    
        //tips
        UILabel *lab = [[UILabel alloc] init];
        [_footer addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(btn);
            make.top.mas_equalTo(btn.mas_bottom).offset(Adapted(14));
        }];
        lab.font = H13;
        lab.numberOfLines = 0;
        lab.textColor = kRedColor;
        lab.text = self.isBuy ? kLocalizedString(@"从点击'立即买入'开始,该订单时限为20分钟") : kLocalizedString(@"从点击'立即卖出'开始,该订单时限为20分钟") ;
    }
    return _footer;
}

- (PlaceOrderVM *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [PlaceOrderVM new];
    }
    return _viewModel;
}

@end
