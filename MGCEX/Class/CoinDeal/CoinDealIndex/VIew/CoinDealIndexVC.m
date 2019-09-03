// MGC
//
// CoinDealIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "CoinDealIndexVC.h"
#import "CoinDealIndexFixHeadView.h"
#import "CoinDealIndexTableHeadView.h"
#import "MGEntrustCell.h"
#import "CoinDealIndexSegView.h"
#import "TTWActionSheetView.h"
#import "MGKLineChartVC.h"
#import "CoinDealIndexVM.h"
#import "MGCoinDealEntrustRecordTVC.h"
#import "CoinDealTitleView.h"
#import "MGCoinDealTradeHeader.h"
#import "FiatTransactionRecordsIndecVC.h"

#define kCellID @"cellID"

@interface CoinDealIndexVC ()<CoindidSelectItemDelegate>
@property (nonatomic, strong) CoinDealIndexFixHeadView * fixedHeadView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) CoinDealIndexTableHeadView * coinHeadView;
@property (nonatomic, strong) CoinDealIndexSegView * selectItemSegView;
@property (nonatomic, strong) CoinDealTitleView *titleView;
@property (nonatomic, strong) CoinDealIndexVM * viewModel;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) NSMutableArray * currencysArr;
@property (nonatomic, assign) NSInteger headSelectSection;
@property (nonatomic, assign) NSInteger headSelectRow;
@property (nonatomic, strong) QuotesModel * panmianModel;//盘面
@property (nonatomic, assign) NSInteger buyOrSell;//1买入。2卖出
@property (nonatomic, assign) NSInteger buyLimitType;//0  限价。 1市价
@property (nonatomic, assign) BOOL userLogin;
@property (nonatomic, assign) BOOL isFirstMark;
@property (nonatomic, assign) BOOL shouldRun;//是否请求盘面行情
@property (nonatomic, assign) BOOL shouldResetTradePair;//是否重置交易对，（从k线图跳过来需要重置交易对）
@property (nonatomic, copy) NSString * buyHeight;//买入的最高价
@property (nonatomic, copy) NSString * sellLow;//卖出的最低价
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSArray * optionalArray;//所有添加自选的交易队列
@property (nonatomic, strong) MGMarketIndexRealTimeModel *optionalModel;//自选model
@property (nonatomic, strong) NSArray * minVolumeArr;//最小交易量数组
@property (nonatomic, strong) NSArray * minWaveArr;//最小变动单位数组
@property (nonatomic, assign) NSInteger trcodeMarkLimit;//交易对小数点位数
@property (nonatomic, assign) double orderMinVolume;//下单最小交易量
@property (nonatomic, copy) NSString * leftPriceStr;//左边第一个输入框的值
@end

@implementation CoinDealIndexVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _userLogin = kUserIsLogin;
    self.shouldRun = YES;
    self.navigationItem.titleView = self.titleView;
    [self.titleView setText:@"BTC/KBC"];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //还原初始化数据
    self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = @"8";
    self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = @"8";
    self.trcodeMarkLimit = 8;
    self.coinHeadView.leftView.slider.value = 0;
    self.coinHeadView.leftView.ppBtn2.textField.text = @"0";
    self.coinHeadView.leftView.ppBtn1.textField.text = @"0";
    
    //获取币种队列
    [self getcurrencylList];
    //刷新推荐值
    self.isFirstLoad = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.shouldRun = NO;
}
//配置基本数据
-(void)configDefaultData
{
    _userLogin = kUserIsLogin;
    self.buyOrSell = 1;
    self.buyLimitType = 0;
    self.headSelectRow = 0;
    self.headSelectSection = 0;
    self.trcodeMarkLimit = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"币币交易");
    
    //配置基本数据
    [self configDefaultData];
   // [self setUpHeadFixView];
    [self setUpTabHeadView];
    [self.tableView registerClass:[MGEntrustCell class] forCellReuseIdentifier:kCellID];
    
    //获取币种队列
    [self getcurrencylList];
  
    [self dropDownToRefreshData:^{

        //还原初始化数据
        self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = @"8";
        self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = @"8";
        self.trcodeMarkLimit = 8;
        self.coinHeadView.leftView.slider.value = 0;
        self.coinHeadView.leftView.ppBtn2.textField.text = @"0";
        self.coinHeadView.leftView.ppBtn1.textField.text = @"0";
        
        //获取币种队列
        [self getcurrencylList];
        //刷新推荐值
        self.isFirstLoad = NO;
    }];
    
    //定时器，定时拉取实时数据
    [[RACSignal interval:5.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.shouldRun) {
                
                if(self.markStr&&self.trCode){
                    //行情
                    [self getQuotesData];
                    
                }
                
            }
        });
        
    }];
    
}
-(void)bindViewModel
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoNotificationAction:) name:changeDealTypeNoti object:nil];
    
    [RACObserve(self, trCode) subscribeNext:^(id x) {
       
        [self.coinHeadView.leftView.nextBtn setTitle:[NSString stringWithFormat:@"%@%@",kLocalizedString(@"买入"), self.trCode]  forState:UIControlStateNormal];
        
        [self.coinHeadView.leftView.nextBtn setTitle:[NSString stringWithFormat:@"%@%@",kLocalizedString(@"卖出"), self.trCode]  forState:UIControlStateSelected];
    }];
}
#pragma mark -- 收到切换买卖通知触发的方法

- (void)infoNotificationAction:(NSNotification *)notification{
    
    //    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dealType,@"dealType",self.market,@"market",self.symbols,@"symbols", nil];
    BOOL isBuy = [notification.userInfo[kIsbuy] boolValue];
    self.markStr = notification.userInfo[kMarket];
    self.trCode = notification.userInfo[kSymbols];
    [self.coinHeadView.segMentView.segMentview changeToIndex:isBuy?0:1];
    
    if (self.currencysArr.count <1) {//还未初始化或未获取到数据
        return;
    }
    self.isFirstMark = YES;
    for(int i=0;i<self.currencysArr.count;i++){
        CoinDealMarkModel * model = self.currencysArr[i];
        if([model.markTitle isEqualToString:self.markStr]){
            self.headSelectSection = i;
            
            for(int j=0;j<model.privateArray.count;j++){
                CoinDealPrivateModel * primodel = model.privateArray[j];
                if([primodel.title isEqualToString:self.trCode]){
                    self.headSelectRow = j;
                }
            }
            
            
        }
    }
    [self sendItemValue:self.headSelectSection row:(NSInteger)self.headSelectRow isEmpty:NO];
}
#pragma mark-- 委托下单
-(void)addEntrustment{
    
    //验证权限
    if([TWAppTool permissionsValidationHandleFinish:nil] == NO)  return;
    
    if(self.buyOrSell == 1){//买入
        self.viewModel.buysell = @"1";
        
        if(self.buyLimitType == 0){//限价单
            self.viewModel.type = @"2";
            self.viewModel.price = self.coinHeadView.leftView.ppBtn1.textField.text;
            self.viewModel.volume = self.coinHeadView.leftView.ppBtn2.textField.text;
            self.viewModel.amount = [[NSString stringWithFormat:@"%.8f",[self.viewModel.price floatValue]*[self.viewModel.volume floatValue]] keepDecimal:8];
           
            
        }else{//市价单
            self.viewModel.type = @"1";
            self.viewModel.price = self.coinHeadView.leftView.ppBtn1.textField.text;//伪数据
            self.viewModel.volume = @"1";//伪数据
            self.viewModel.amount = [self.coinHeadView.leftView.ppBtn2.textField.text keepDecimal:8];
            

        }
        
    }else{//卖出
        self.viewModel.buysell = @"2";
        
        if(self.buyLimitType == 0){//限价单
            self.viewModel.type = @"2";
            self.viewModel.price = self.coinHeadView.leftView.ppBtn1.textField.text;
            self.viewModel.volume = self.coinHeadView.leftView.ppBtn2.textField.text;
            self.viewModel.amount = [[NSString stringWithFormat:@"%f",[self.viewModel.price floatValue]*[self.viewModel.volume floatValue]] keepDecimal:8];
     
            
        }else{//市价单
            self.viewModel.type = @"1";
            self.viewModel.price = self.coinHeadView.leftView.ppBtn1.textField.text;//伪数据
            self.viewModel.volume = self.coinHeadView.leftView.ppBtn2.textField.text;
            self.viewModel.amount = @"1";//伪数据
         
        }
        
    }
    
    if(self.orderMinVolume>0){
        if(self.coinHeadView.leftView.ppBtn2.currentNumber<self.orderMinVolume){
            [TTWHUD showCustomMsg:kLocalizedString(@"小于最小交易量")];
            return ;
        }
    }
    
    self.viewModel.market = self.markStr;
    self.viewModel.symbol = self.trCode;
    //判断下单总额是否大于10CNY
    
    //验证是否实名 设置资金密码
    [TWAppTool passRealNameAuthenticationOrAccountPwd:^(BOOL isAuthenticated, BOOL isSetAccountPwd) {
        
        if(!isAuthenticated && !isSetAccountPwd){
            [TTWHUD showCustomMsg:kLocalizedString(@"请先实名认证和设置资金密码")];
            return;
        }
        
        if(!isAuthenticated){
            [TTWHUD showCustomMsg:kLocalizedString(@"请先实名认证")];
            return;
        }
        if(!isSetAccountPwd){
            [TTWHUD showCustomMsg:kLocalizedString(@"请先设置资金密码")];
            return;
        }
        
        @weakify(self);
        [self.viewModel.addEntrustmentSignal subscribeNext:^(QuotesModel *model) {
            @strongify(self);
            [TTWHUD showCustomMsg:kLocalizedString(@"下单成功")];
            //刷新币种可用数量
            [self getCoinRemainSignal];
            //刷新列表
            [self.viewModel.entrustRefreshCommand execute:kIsRefreshY];
            
            
        } completed:^{
            
        }];
    }];
}

#pragma mark-- 获取币种可用数量
-(void)getCoinRemainSignal{
    
    if(self.buyOrSell == 1){
        self.viewModel.remainCoin = self.markStr;
        
    }else{
        self.viewModel.remainCoin = self.trCode;
        
    }
    
    
    @weakify(self);
    [self.viewModel.getCoinRemainSignal subscribeNext:^(CoinRemainModel *model) {
        @strongify(self);
        
        self.coinHeadView.leftView.availableBalance = model.availableBalance;
        self.coinHeadView.leftView.trCode = self.trCode;
        self.coinHeadView.leftView.markStr = self.markStr;
        
        if(self.buyOrSell == 1){
            
            self.coinHeadView.leftView.btcLabel.text = [NSString stringWithFormat:@"%@%@:%@",kLocalizedString(@"可用"),kNotNull(self.markStr),kNotNumber([model.availableBalance keepDecimal:8])];
            
            if(self.buyLimitType == 0){//限价
                if([self.coinHeadView.leftView.ppBtn1.textField.text floatValue]>0){
                    if ([kNotNumber(model.availableBalance) floatValue]/[[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:8] floatValue]>0) {
                        self.coinHeadView.leftView.slider.maximumValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue]/[self.coinHeadView.leftView.ppBtn1.textField.text floatValue];
                    }
                    
                    
                    self.coinHeadView.leftView.maxLabel.text = [NSString stringWithFormat:@"%.8f %@",[kNotNumber([model.availableBalance keepDecimal:8]) floatValue]/[[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:8] floatValue],kNotNull(self.trCode)];
                }
                
                self.coinHeadView.leftView.minLabel.text = @"0";
                
                self.coinHeadView.leftView.ppBtn2.maxValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue]/[[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:8] floatValue];
                
            }else{//市价
                
                
                if ([kNotNumber(model.availableBalance) floatValue]>0) {
                    self.coinHeadView.leftView.slider.maximumValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue];
                }
                self.coinHeadView.leftView.maxLabel.text = [NSString stringWithFormat:@"%@ %@",kNotNumber([model.availableBalance keepDecimal:8]),kNotNull(self.markStr)];
                self.coinHeadView.leftView.ppBtn2.maxValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue];
                self.coinHeadView.leftView.minLabel.text = @"0";
            }
            
            
            
            
        }else{//卖出
            
            self.coinHeadView.leftView.btcLabel.text = [NSString stringWithFormat:@"%@%@:%@",kLocalizedString(@"可用"),kNotNull(self.trCode),kNotNumber([model.availableBalance keepDecimal:8])];
            
            if ([kNotNumber(model.availableBalance) floatValue]>0) {
                self.coinHeadView.leftView.slider.maximumValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue];
            }
            
            self.coinHeadView.leftView.maxLabel.text = [NSString stringWithFormat:@"%@ %@",kNotNumber([model.availableBalance keepDecimal:8]),kNotNull(self.trCode)];
            
            self.coinHeadView.leftView.ppBtn2.maxValue = [kNotNumber([model.availableBalance keepDecimal:8]) floatValue];
            
            self.coinHeadView.leftView.minLabel.text = @"0";
        }
       
        //最小保留位数
        self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = s_Integer(self.trcodeMarkLimit);
            //最小变动单位z
        self.coinHeadView.leftView.ppBtn1.PriceminUnit = 1.0/pow(10,self.trcodeMarkLimit);
        self.coinHeadView.leftView.ppBtn1.textField.text = [[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
            
        
        
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark-- 获取币种队列
-(void)getcurrencylList{
    
    
    @weakify(self);
    [self.viewModel.getcurrencysSignal subscribeNext:^(NSMutableArray * array) {
        @strongify(self);
        self.currencysArr = array;
    
        //默认 KBC,BTC
        if(self.isFirstMark == NO){
            self.isFirstMark = YES;
            for(int i=0;i<self.currencysArr.count;i++){
                CoinDealMarkModel * model = self.currencysArr[i];
                if([model.markTitle isEqualToString:@"KBC"]){
                    self.headSelectSection = i;
                    
                    for(int j=0;j<model.privateArray.count;j++){
                        CoinDealPrivateModel * primodel = model.privateArray[j];
                        if([primodel.title isEqualToString:@"BTC"]){
                            self.headSelectRow = j;
                        }
                    }
                    
                    
                }
            }
        }
        
        
        //配置默认币种队列----防止下次刷新改变币种队列造成数组越界
        if((self.currencysArr.count-1)<self.headSelectSection ){
            
            CoinDealMarkModel * model = self.currencysArr[0];
            self.markStr = model.markTitle;
            CoinDealPrivateModel * primodel = model.privateArray[0];
            self.trCode = primodel.title;
            NSString * btnStr =[NSString stringWithFormat:@"%@/%@",primodel.title,model.markTitle];
            [self.fixedHeadView.leftBtn setTitle:btnStr forState:UIControlStateNormal];
            
        }else{
            
            CoinDealMarkModel * model = self.currencysArr[self.headSelectSection];
            self.markStr = model.markTitle;
            
            if(model.privateArray.count-1<self.headSelectRow){
                
                CoinDealPrivateModel * primodel = model.privateArray[0];
                self.trCode = primodel.title;
                NSString * btnStr =[NSString stringWithFormat:@"%@/%@",primodel.title,model.markTitle];
                [self.fixedHeadView.leftBtn setTitle:btnStr forState:UIControlStateNormal];
            }else{
                
                CoinDealPrivateModel * primodel = model.privateArray[self.headSelectRow];
                self.trCode = primodel.title;
                NSString * btnStr =[NSString stringWithFormat:@"%@/%@",primodel.title,model.markTitle];
                [self.fixedHeadView.leftBtn setTitle:btnStr forState:UIControlStateNormal];
            }
            
            
            
        }
        self.coinHeadView.leftView.markStr = self.markStr;
        self.coinHeadView.leftView.trCode = self.trCode;
        
        
        //获取我的自选
        [self getMyCurrentChoice];
        //获取盘面
        [self getQuotesData];
        //获取该币种可用数量
        [self getCoinRemainSignal];
        //获取币币交易委托队列
        [self getFiatEntrustListData];
        //获取最小交易量
        [self getMinVolume];
        //获取最小变动单位
        [self getMinWaveSignal];
        
        self.coinHeadView.rightView.priceLab.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"价格"),self.markStr];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark-- 买卖五档
-(void)getUnsettledGear{
    
    self.viewModel.tradeCode = [NSString stringWithFormat:@"%@:%@",self.markStr,self.trCode];
    
    @weakify(self);
    [self.viewModel.unsettledGearSignal subscribeNext:^(NSMutableDictionary * dic) {
        @strongify(self);
        self.coinHeadView.rightView.mutabDic = dic;
        NSArray * buyArr = dic[@"buyArr"];
        NSArray * sellArr = dic[@"sellArr"];
        if(buyArr.count>4&&sellArr.count>4){
            UnsettledGearModel * buyModel = buyArr[0];
            UnsettledGearModel * sellModel = sellArr[4];
            self.buyHeight = buyModel.price;
            self.sellLow = sellModel.price;
            
            //刷新后重新赋值
            if(self.isFirstLoad == NO){
                self.isFirstLoad = YES;
          
                if(self.buyOrSell == 1){
                    self.leftPriceStr = self.sellLow;
                    self.coinHeadView.leftView.ppBtn1.textField.text = [[self.sellLow keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
                    
                }else{
                    self.leftPriceStr = self.buyHeight;
                    self.coinHeadView.leftView.ppBtn1.textField.text = [[self.buyHeight keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
                    
                }
            }
            
        }else{
            
            if(self.isFirstLoad == NO){
                self.isFirstLoad = YES;
                
                if([[self.panmianModel.c keepDecimal:8] floatValue]>0){
                    self.leftPriceStr = self.panmianModel.c;
                    self.buyHeight = [[self.panmianModel.c keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
                    self.sellLow = [[self.panmianModel.c keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
                    
                }else{
                    self.buyHeight = @"0.00";
                    self.sellLow = @"0.00";
           
                }
                
                //此处有网络先后导致的问题，必须在获取交易对小数位时再设置一次
                self.coinHeadView.leftView.ppBtn1.textField.text = [[self.panmianModel.c keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];
                
            }
            
            
        }
    
        //此处有网络先后导致的问题，必须在获取交易对小数位时再设置一次
        self.coinHeadView.rightView.priceLimit = self.trcodeMarkLimit;
        
  
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark--  获取盘面详情
-(void)getQuotesData{
    
    if(self.markStr.length==0||self.trCode.length==0){
        
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    NSString * str = [NSString stringWithFormat:@"%@:%@",self.markStr,self.trCode];
    self.viewModel.transPares =  @[str];
    
    @weakify(self);
    [self.viewModel.quotesSignal subscribeNext:^(QuotesModel *model) {
        @strongify(self);

        if(self.trcodeMarkLimit>0){
            model.c = [model.c keepDecimal:self.trcodeMarkLimit];
        }else{
            model.c = [model.c keepDecimal:8];
        }
        
        
        self.panmianModel = model;
        self.coinHeadView.rightView.numberBgLab.text = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"数量"),self.trCode];
        NSString *fee = model.gains.removeFloatAllZero;

         self.coinHeadView.leftView.model = model;
        //配置盘面信息
//        self.fixedHeadView.midLabel.text =  model.c;
//        self.fixedHeadView.submidLabel.text = [NSString stringWithFormat:@"≈%.2f CNY",[[model.marketPrice keepDecimal:8]doubleValue]*[[model.c keepDecimal:8]doubleValue]];
        
//        self.fixedHeadView.rightLabel.text = [NSString stringWithFormat:@"%@%.2f%%", model.gainSymbol,[fee floatValue]*100];
//        self.fixedHeadView.rightLabel.textColor = model.gainsColor;
        
       
        self.coinHeadView.rightView.header.price = model.c;
        self.coinHeadView.rightView.header.cnyPrice = [NSString stringWithFormat:@"≈%.2f CNY",[[model.marketPrice keepDecimal:8]doubleValue]*[[model.c keepDecimal:8]doubleValue]];
        self.coinHeadView.rightView.header.rose = [NSString stringWithFormat:@"%@%.2f%%", model.gainSymbol,[fee floatValue]*100];
        
        
 
        NSString *jsonStr = [model yy_modelToJSONString];
        self.optionalModel = [MGMarketIndexRealTimeModel yy_modelWithJSON:jsonStr];
        
        //买卖五档
        [self getUnsettledGear];
        
    } completed:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark--获取币币交易委托队列
-(void)getFiatEntrustListData{
    
    _userLogin = kUserIsLogin;
    if(_userLogin == NO)  return;
    
    self.viewModel.markStr = self.markStr;
    self.viewModel.trocodeStr = self.trCode;
    
    //订阅信号
    @weakify(self);
    [[self.viewModel.entrustRefreshCommand executionSignals] subscribeNext:^(id x) {
        [x subscribeNext:^(NSMutableArray *dataArray) {
            @strongify(self);
            
            self.dataArray = dataArray;
            if(kArrayIsEmpty(dataArray)){
                
                self.tableView.tableFooterView = self.noDataView;
            } else {
                self.tableView.tableFooterView = nil;
            }
            
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
            
        }error:^(NSError *error) {
            
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            
            
        }];
        
        [x subscribeCompleted:^{
            @strongify(self);
            if (self.viewModel.hasMoreData) {
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }];
    
    [self.viewModel.entrustRefreshCommand execute:kIsRefreshY];
}

#pragma mark-- 添加自选
-(void)addMyCurrentChoice{
    
    if(self.markStr.length==0||self.trCode.length==0){
        return;
    }
    
    self.viewModel.transPare = [NSString stringWithFormat:@"%@:%@",self.trCode,self.markStr];
    
    @weakify(self);
    [self.viewModel.addMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        @strongify(self);
        //刷新自选列表
        [self getMyCurrentChoice];
        self.coinHeadView.segMentView.optionalBtn.selected = YES;
    } completed:^{
        
    }];
    
}

#pragma mark-- 取消自选
-(void)cancelMyCurrentChoice{
    
    for (OptionalModel * model in self.optionalArray) {
        
        if ([model.transPare rangeOfString:self.trCode].location != NSNotFound && [model.transPare rangeOfString:self.markStr].location != NSNotFound) {
            //拿到自选ID
            self.viewModel.transPare = [NSString stringWithFormat:@"%@:%@",self.trCode,self.markStr];
    
        }
    }
    
    
    @weakify(self);
    [self.viewModel.cancelMyChoiceSignal subscribeNext:^(QuotesModel *model) {
        @strongify(self);
        //刷新自选列表
        [self getMyCurrentChoice];
        self.coinHeadView.segMentView.optionalBtn.selected = NO;
    } completed:^{
        
    }];
}

#pragma mark-- 获取我的自选
-(void)getMyCurrentChoice{
    //初始化
    self.coinHeadView.segMentView.optionalBtn.selected = NO;
    
    if(!kUserIsLogin)  return;
    
    @weakify(self);
    [self.viewModel.getMyChoiceSignal subscribeNext:^(NSArray *arr) {
        @strongify(self);
        
        self.optionalArray = arr;
        for (OptionalModel * model in arr) {
            
            if ([model.transPare rangeOfString:self.trCode].location != NSNotFound && [model.transPare rangeOfString:self.markStr].location != NSNotFound) {
                //标记为自选
                self.coinHeadView.segMentView.optionalBtn.selected = YES;
                self.optionalModel.isOptional = self.coinHeadView.segMentView.optionalBtn.selected;
            }
        }
        
    } completed:^{
        
    }];
}

#pragma mark -- 获取最小交易量（单个币种）
-(void)getMinVolume{
    
    
    @weakify(self);
    [self.viewModel.minVolumeSignal subscribeNext:^(NSArray *arr) {
        @strongify(self);
        
        self.minVolumeArr = arr;
        [arr enumerateObjectsUsingBlock:^(MinVolumeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.tradeCode isEqualToString:self.markStr]) {
                *stop = YES;
           
                if(self.buyLimitType == 1&&self.buyOrSell == 1){//市价//买入
                   
                    //最小变动单位
                    self.coinHeadView.leftView.ppBtn2.NumberminUnit = [model.minWave doubleValue];
                    if([model.scale integerValue] == 0){
                        //整数
                        self.coinHeadView.leftView.ppBtn2.textField.keyboardType = UIKeyboardTypeNumberPad;
                        //传limitDecimalDigitLength=0，代表滑杆滑动时，保留0位，向下舍
                        self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
                    }else{
                        //最小保留位数
                        self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
                        self.coinHeadView.leftView.ppBtn2.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    }
                    
                    //最小交易量
                    self.orderMinVolume = [model.minVolume doubleValue];
                }
              
            }
        }];
        
        
        [arr enumerateObjectsUsingBlock:^(MinVolumeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.tradeCode isEqualToString:self.trCode]) {
                *stop = YES;
                
                if(self.buyLimitType != 1||self.buyOrSell != 1){
                    //最小变动单位
                    self.coinHeadView.leftView.ppBtn2.NumberminUnit = [model.minWave doubleValue];
                    if([model.scale integerValue] == 0){
                        //整数
                        self.coinHeadView.leftView.ppBtn2.textField.keyboardType = UIKeyboardTypeNumberPad;
                        //传limitDecimalDigitLength=0，代表滑杆滑动时，保留0位，向下舍
                        self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
                    }else{
                        //最小保留位数
                        self.coinHeadView.leftView.ppBtn2.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
                        self.coinHeadView.leftView.ppBtn2.textField.keyboardType = UIKeyboardTypeDecimalPad;
            
                    }
                    
                    //最小交易量
                    self.orderMinVolume = [model.minVolume doubleValue];
                }
   
            
            }
        }];
        
    } completed:^{
        
    }];
}

#pragma mark -- 获取最小变动单位(交易对)
-(void)getMinWaveSignal{
    
    @weakify(self);
    [self.viewModel.minWaveSignal subscribeNext:^(NSArray *arr) {
        @strongify(self);
        
        self.minWaveArr = arr;
        if(self.minWaveArr.count==0) return;
        
        [arr enumerateObjectsUsingBlock:^(MinWaveModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.symbol isEqualToString:self.trCode]&&[model.market isEqualToString:self.markStr]) {
                *stop = YES;
                
               self.fixedHeadView.midLabel.text = [self.fixedHeadView.midLabel.text keepDecimal:[model.scale integerValue]];

                if([model.scale integerValue] == 0){
  
                    self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
                }else{
                    //最小保留位数
                    self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = s_Integer([model.scale integerValue]);
   
                }
               
                self.coinHeadView.rightView.priceLimit = [model.scale integerValue];
                //重新拉取数据，避免之前数据被截取，导致截取位数不够
                self.coinHeadView.leftView.ppBtn1.textField.text = [[self.leftPriceStr keepDecimal:[model.scale integerValue]] removeFloatAllZero];
                //最小变动单位
                self.coinHeadView.leftView.ppBtn1.PriceminUnit = 1.0/pow(10,[model.scale integerValue]);
                self.trcodeMarkLimit = [model.scale integerValue];
                
                
                
            }
        }];
   
        
    } completed:^{
        
    }];
}
/*
-(void)setUpHeadFixView{
    
    //最顶上固定头部
    self.fixedHeadView = [[CoinDealIndexFixHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(48) + kStatusBarHeight)];
    
    [self.view addSubview:self.fixedHeadView];
    
    //选中币种队列
    @weakify(self);
    self.fixedHeadView.segBlock = ^(CoinDealIndexFixHeadView *headV) {
        @strongify(self);
        if(self.currencysArr.count==0)  return ;
        
        CGRect rect = [headV convertRect:headV.frame toView:nil];
        
        self.selectItemSegView = [[CoinDealIndexSegView alloc]initWithRect:rect maxCell:8 selectSection:self.headSelectSection selectRow:self.headSelectRow dataArray:self.currencysArr];
        self.selectItemSegView.selectDelegate = self;
        [self.selectItemSegView show];
    };
   
}
 */
-(void)setUpTabHeadView{
    
    self.tableView.backgroundColor = kBackGroundColor;
    self.tableView.separatorColor = kLineColor;
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.tableHeaderView = self.coinHeadView;
    self.coinHeadView.leftView.buyLimitType = self.buyLimitType;
    self.coinHeadView.leftView.buyOrSell = self.buyOrSell;
    
    
    //1买入。2卖出切换
    @weakify(self);
    self.coinHeadView.segMentView.segmentBlock = ^(NSInteger index) {
        @strongify(self);
        switch (index) {
            case 1:{
                self.buyOrSell = 1;
                self.coinHeadView.leftView.buyOrSell = self.buyOrSell;
                if(self.buyLimitType == 0){
                    [self.coinHeadView.leftView.titleBtn setTitle:kLocalizedString(@"限价买入") forState:UIControlStateNormal];
                }else{
                    [self.coinHeadView.leftView.titleBtn setTitle:kLocalizedString(@"市价买入") forState:UIControlStateNormal];
                }
                self.coinHeadView.leftView.nextBtn.selected = NO;
                self.coinHeadView.leftView.ppBtn1.textField.text = [self.sellLow removeFloatAllZero];
                self.coinHeadView.leftView.slider.minimumTrackTintColor = kGreenColor;
                self.coinHeadView.leftView.buyLimitType = self.buyLimitType;
                
                //最小保留位数
                self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = s_Integer(self.trcodeMarkLimit);
                //最小变动单位
                self.coinHeadView.leftView.ppBtn1.PriceminUnit = 1.0/pow(10,self.trcodeMarkLimit);
                self.coinHeadView.leftView.ppBtn1.textField.text = [[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];

                
                [self.tableView.mj_header beginRefreshing];
            }
                
                break;
            case 2:{
                self.buyOrSell = 2;
                self.coinHeadView.leftView.buyOrSell = self.buyOrSell;
                if(self.buyLimitType == 0){
                    [self.coinHeadView.leftView.titleBtn setTitle:kLocalizedString(@"限价卖出") forState:UIControlStateNormal];
                }else{
                    [self.coinHeadView.leftView.titleBtn setTitle:kLocalizedString(@"市价卖出") forState:UIControlStateNormal];
                }
                
                self.coinHeadView.leftView.nextBtn.selected = YES;
                self.coinHeadView.leftView.ppBtn1.textField.text = [self.buyHeight removeFloatAllZero];
                self.coinHeadView.leftView.slider.minimumTrackTintColor = kRedColor;
                self.coinHeadView.leftView.buyLimitType = self.buyLimitType;
           
                //最小保留位数
                self.coinHeadView.leftView.ppBtn1.textField.limitDecimalDigitLength = s_Integer(self.trcodeMarkLimit);
                //最小变动单位
                self.coinHeadView.leftView.ppBtn1.PriceminUnit = 1.0/pow(10,self.trcodeMarkLimit);
                self.coinHeadView.leftView.ppBtn1.textField.text = [[self.coinHeadView.leftView.ppBtn1.textField.text keepDecimal:self.trcodeMarkLimit] removeFloatAllZero];

                
                
                [self.tableView.mj_header beginRefreshing];
            }
                
                break;
            case 3:
            {
                if(self.coinHeadView.segMentView.optionalBtn.selected == YES){
                    //取消自选
                    [TWAppTool permissionsValidationHandleFinish:^{
                        [self cancelMyCurrentChoice];
                    }];
                    
                }else{
                    //添加自选
                    [TWAppTool permissionsValidationHandleFinish:^{
                        [self addMyCurrentChoice];
                    }];
                    
                }
                
                
                
            }
                break;
            case 4:
            {
                //跳转到k线图页面
                
                MGKLineChartVC *vc = [[MGKLineChartVC alloc]init];
                vc.symbols = self.trCode;
                vc.market = self.markStr;
                vc.model = self.optionalModel;
                vc.model.valuation = self.panmianModel.valuation;
                vc.model.isOptional = self.coinHeadView.segMentView.optionalBtn.selected;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
                break;
            default:
                break;
        }
        
        [self getCoinRemainSignal];
    };
    
    
    //市价买入。限价买入
    
    self.coinHeadView.leftView.buylimitBlock = ^{
        @strongify(self);
        
        [self buyLimitHanldler];
    };
    
    //下单
    [[self.coinHeadView.leftView.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        
        [self addEntrustment];
    }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adapted(40);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGEntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.model = self.dataArray[indexPath.row];
    //监听按钮(撤单)
    [[[cell.button rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        
        [self removrOrderSignalWith:cell.model.Id];
        
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

#pragma mark--撤单
-(void)removrOrderSignalWith:(NSString * )orderId{
    
    BOOL isOK = [TWAppTool permissionsValidationHandleFinish:nil];
    
    if(isOK == NO)  return;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:kLocalizedString(@"确认撤销当前委托？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.viewModel.orderId = orderId;
                                                              @weakify(self);
                                                              [self.viewModel.removrOrderSignal subscribeNext:^(id x) {
                                                                  @strongify(self);
                                                                  [TTWHUD showCustomMsg:kLocalizedString(@"撤销成功")];
                                                                  [self.tableView.mj_header beginRefreshing];
                                                              } completed:^{
                                                                  
                                                              }];
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(40))];
        _headerView.backgroundColor = kBackGroundColor;
        UILabel *priceLab = [[UILabel alloc]init];
        [_headerView addSubview:priceLab];
        priceLab.textColor = kTextColor;
        priceLab.text = kLocalizedString(@"当前委托");
        priceLab.font = H15;
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(Adapted(12));
        }];
        
//        UIImageView * youjianImageV = [[UIImageView alloc]init];
//        [_headerView addSubview:youjianImageV];
//        youjianImageV.image = IMAGE(@"jiantou-heng");
//        [youjianImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-12);
//            make.centerY.mas_equalTo(0);
//            make.width.mas_equalTo(Adapted(8));
//            make.height.mas_equalTo(Adapted(14));
//        }];
        
        UILabel *numberBgLab = [[UILabel alloc]init];
        [_headerView addSubview:numberBgLab];
        numberBgLab.textColor = kAssistColor;
        numberBgLab.userInteractionEnabled = YES;
        numberBgLab.textAlignment = NSTextAlignmentRight;
        numberBgLab.text = string(kLocalizedString(@"历史记录"), @">");
        numberBgLab.font = H15;
        [numberBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(Adapted(-10));
            make.height.mas_equalTo(Adapted(40));
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHistoryRecordListVC)];
        [numberBgLab addGestureRecognizer:tap];
        
        
    }
    return _headerView;
}

-(void)gotoHistoryRecordListVC{
    
    @weakify(self);
    [TWAppTool permissionsValidationHandleFinish:^{
        @strongify(self);
        
        FiatTransactionRecordsIndecVC * vc =[[FiatTransactionRecordsIndecVC alloc]init];
        vc.selectedIndex = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
//        MGCoinDealEntrustRecordTVC *tvc = [[MGCoinDealEntrustRecordTVC alloc]init];
//        tvc.markStr = self.markStr;
//        tvc.trCode = self.trCode;
//        [self.navigationController pushViewController:tvc animated:YES];
        
    }];
    
}

#pragma mark-- 限价 市价
-(void)buyLimitHanldler{
    NSArray * arr;
    if(self.buyOrSell ==1){
        arr = @[kLocalizedString(@"限价买入"),kLocalizedString(@"市价买入")];
    }else{
        arr = @[kLocalizedString(@"限价卖出"),kLocalizedString(@"市价卖出")];
    }
    
    @weakify(self);
    TTWActionSheetView * sheetView = [[TTWActionSheetView alloc]initWithTitle:@"" selectIndex:self.buyLimitType cancelButtonTitle:kLocalizedString(@"取消")  destructiveButtonTitle:@"" otherButtonTitles:arr handler:^(TTWActionSheetView *actionSheetView, NSInteger buttonIndex) {
        @strongify(self);
        
        switch (buttonIndex) {
            case 0://限价买入/限价卖出
            {
                
                self.buyLimitType = 0;
                [self.coinHeadView.leftView.titleBtn setTitle:arr[buttonIndex] forState:UIControlStateNormal];
                self.coinHeadView.leftView.markView.hidden = YES;
                self.coinHeadView.rightView.isDisable = NO;
                self.coinHeadView.leftView.cnyLabel.hidden = NO;
                self.coinHeadView.leftView.buyLimitType = self.buyLimitType;
                self.coinHeadView.leftView.turnoverLabel.hidden = NO;
                [self.tableView.mj_header beginRefreshing];
                
            }
                break;
            case 1://市价买入/市价卖出
            {
                self.buyLimitType = 1;
                [self.coinHeadView.leftView.titleBtn setTitle:arr[buttonIndex] forState:UIControlStateNormal];
                self.coinHeadView.leftView.markView.hidden = NO;
                self.coinHeadView.leftView.ppBtn1.currentNumber = [self.panmianModel.c floatValue];
                
                self.coinHeadView.leftView.cnyLabel.text = [NSString stringWithFormat:@"≈%.4f CNY",[self.panmianModel.c floatValue]*[self.panmianModel.marketPrice floatValue]];
                self.coinHeadView.rightView.isDisable = YES;
                self.coinHeadView.leftView.cnyLabel.hidden = YES;
                self.coinHeadView.leftView.buyLimitType = self.buyLimitType;
                self.coinHeadView.leftView.turnoverLabel.hidden = YES;
                [self.tableView.mj_header beginRefreshing];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [sheetView show];
    
}

#pragma mark-- CoindidSelectItemDelegate

- (void)sendItemValue:(NSInteger )section row:(NSInteger )row  isEmpty:(BOOL)isEmpty{
    
    if(isEmpty == NO){

        self.headSelectSection = section;
        self.headSelectRow = row;
        CoinDealMarkModel * model = self.currencysArr[section];
        self.markStr = model.markTitle;
        CoinDealPrivateModel * primodel = model.privateArray[row];
        self.trCode = primodel.title;
        
        NSString * btnStr =[NSString stringWithFormat:@"%@/%@",primodel.title,model.markTitle];
//        [self.fixedHeadView.leftBtn setTitle:btnStr forState:UIControlStateNormal];
        [self.titleView setText:btnStr];
        //刷新推荐值
        self.isFirstLoad = NO;
        
        [self.tableView.mj_header beginRefreshing];
    }
    
//    self.fixedHeadView.leftBtn.selected = NO;
    self.titleView.selected =  !self.titleView.selected;
}

-(CoinDealIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[CoinDealIndexVM alloc]init];
    }
    return _viewModel;
}

-(NSMutableArray *)currencysArr{
    if(!_currencysArr){
        _currencysArr = [NSMutableArray new];
    }
    return _currencysArr;
}

-(CoinDealIndexTableHeadView *)coinHeadView{
    if(!_coinHeadView){
        _coinHeadView = [[CoinDealIndexTableHeadView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(433))];
    }
    return _coinHeadView;
    
}

- (CoinDealTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [[CoinDealTitleView alloc] init];
        @weakify(self);
        _titleView.clickBlock = ^(BOOL selected) {
        
            @strongify(self);
            if(self.currencysArr.count==0)  return ;
            
            CGRect rect = [self.navigationController.navigationBar convertRect:self.navigationItem.titleView.frame toView:nil];
            
            self.selectItemSegView = [[CoinDealIndexSegView alloc]initWithRect:rect maxCell:8 selectSection:self.headSelectSection selectRow:self.headSelectRow dataArray:self.currencysArr];
            self.selectItemSegView.selectDelegate = self;
            [self.selectItemSegView show];
            
        };
    }
    return _titleView;
}

- (UIView *)noDataView{
    
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, Adapted(145))];
        _noDataView.backgroundColor = white_color;
        UIImageView *imageView = [[UIImageView alloc] init];
        [_noDataView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(Adapted(-30));
        }];
        imageView.image = IMAGE(@"icon_norecord");
        
        //无记录
        UILabel *lab = [[UILabel alloc] init];
        [_noDataView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_offset(0);
            make.top.mas_equalTo(imageView.mas_bottom).offset(Adapted(5));
        }];
        lab.font = H14;
        lab.textColor = k99999Color;
        lab.text = kLocalizedString(@"暂无委托");
    }
    return _noDataView;
}
@end
